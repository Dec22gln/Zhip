//
//  RestoreWalletView.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class RestoreWalletView: ScrollingStackView {

    private lazy var privateKeyField: UITextField = "Private Key"
    private lazy var encryptionPassphraseField: UITextField = "Encryption passphrase"
    private lazy var confirmEncryptionPassphraseField: UITextField = "Confirm encryption passphrase"
    private lazy var restoreWalletButton = UIButton.Style("Restore Wallet", isEnabled: false).make()

    lazy var stackViewStyle: UIStackView.Style = [
        privateKeyField,
        encryptionPassphraseField,
        confirmEncryptionPassphraseField,
        restoreWalletButton,
        .spacer
    ]
}

extension RestoreWalletView: ViewModelled {
    typealias ViewModel = RestoreWalletViewModel
    var inputFromView: ViewModel.Input {
        return ViewModel.Input(
            privateKey: privateKeyField.rx.text.asDriver(),
            encryptionPassphrase: encryptionPassphraseField.rx.text.asDriver(),
            confirmEncryptionPassphrase: confirmEncryptionPassphraseField.rx.text.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }

    func populate(with viewModel: RestoreWalletViewModel.Output) -> [Disposable] {
        return [
            viewModel.isRestoreButtonEnabled --> restoreWalletButton.rx.isEnabled
        ]
    }
}
