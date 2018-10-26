//
//  ChooseWalletView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

final class ChooseWalletView: ScrollingStackView {

    private lazy var createNewWalletButton: UIButton = "New Wallet"
    private lazy var restoreWalletButton = UIButton.Style("Restore Wallet", textColor: .white, colorNormal: .blue).make()

    lazy var stackViewStyle: UIStackView.Style = [
        createNewWalletButton,
        restoreWalletButton,
        .spacer
    ]
}

extension ChooseWalletView: ViewModelled {
    typealias ViewModel = ChooseWalletViewModel
    var userInput: UserInput {
        return UserInput(
            createNewTrigger: createNewWalletButton.rx.tap.asDriver(),
            restoreTrigger: restoreWalletButton.rx.tap.asDriver()
        )
    }
}
