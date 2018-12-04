//
//  BackupWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.BackupWallet

extension UILabel {
    convenience init(text: CustomStringConvertible?) {
        self.init(frame: .zero)
        self.text = text?.description
    }
}

final class BackupWalletView: ScrollingStackView {

    private lazy var beSafeLabel = UILabel(text: €.Label.storeKeystoreSecurely).withStyle(.title)

    private lazy var keystoreTextView = ScrollableContentSizedTextView().withStyle(.nonEditable) { customizableSTyle in
        customizableSTyle
            .textAlignment(.left)
            .font(.tiny)
    }

    private lazy var copyKeystoreButton = UIButton(title: €.Button.copyKeystore)
        .withStyle(.primary)

    private lazy var urgeUserToSecurlyBackupPassphraseLabel = UILabel(text: €.Label.urgeSecureBackupOfKeystore)
        .withStyle(.body)

    private lazy var understandsRisksCheckbox = CheckboxWithLabel(titled: €.SwitchLabel.keystoreIsBackedUp)

    private lazy var haveBackedUpProceedButton = UIButton(title: €.Button.haveBackedUpProceed)
        .withStyle(.secondary)
        .disabled()

    // MARK: - StackViewStyling
    lazy var stackViewStyle: UIStackView.Style = [
        beSafeLabel,
        keystoreTextView,
        copyKeystoreButton,
        urgeUserToSecurlyBackupPassphraseLabel,
        understandsRisksCheckbox,
        haveBackedUpProceedButton,
        .spacer
    ]

    override func setup() {
        keystoreTextView.addBorder()
    }
}

extension BackupWalletView: ViewModelled {
    typealias ViewModel = BackupWalletViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.keystoreText              --> keystoreTextView,
            viewModel.isProceedButtonEnabled    --> haveBackedUpProceedButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            copyKeystoreToPasteboardTrigger: copyKeystoreButton.rx.tap.asDriver(),
            isUnderstandsRiskCheckboxChecked: understandsRisksCheckbox.rx.isChecked.asDriver(),
            proceedTrigger: haveBackedUpProceedButton.rx.tap.asDriver()
        )
    }
}
