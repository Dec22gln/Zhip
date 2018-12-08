//
//  RestoreWalletUsingKeystoreViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-06.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import RxCocoa
import RxSwift

private typealias € = L10n.Scene.RestoreWallet

// MARK: - RestoreWalletViewModel
final class RestoreWalletUsingKeystoreViewModel {

    let output: Output

    // swiftlint:disable:next function_body_length
    init(inputFromView: InputFromView) {
        let encryptionPassphraseMode: WalletEncryptionPassphrase.Mode = .restore

        let validEncryptionPassphrase: Driver<String?> =
            inputFromView.encryptionPassphrase.map {
            try? WalletEncryptionPassphrase(passphrase: $0, confirm: $0, mode: encryptionPassphraseMode)
            }.map { $0?.validPassphrase }
            .distinctUntilChanged()

        let keyRestoration: Driver<KeyRestoration?> = Driver.combineLatest(inputFromView.keystoreText, validEncryptionPassphrase) {
            guard let newEncryptionPassphrase = $1 else { return nil }
            return try? KeyRestoration(keyStoreJSONString: $0, encryptedBy: newEncryptionPassphrase)
        }

        let encryptionPassphrasePlaceHolder = Driver.just(€.Field.encryptionPassphrase(WalletEncryptionPassphrase.minimumLenght(mode: encryptionPassphraseMode)))

        self.output = Output(
            encryptionPassphrasePlaceholder: encryptionPassphrasePlaceHolder,
            keyRestoration: keyRestoration
        )
    }
}

extension RestoreWalletUsingKeystoreViewModel {

    struct InputFromView {
        let keystoreText: Driver<String>
        let encryptionPassphrase: Driver<String>
    }

    struct Output {
        let encryptionPassphrasePlaceholder: Driver<String>
        let keyRestoration: Driver<KeyRestoration?>
    }
}
