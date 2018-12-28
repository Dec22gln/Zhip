//
//  RestoreWalletNavigator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

final class RestoreWalletCoordinator: BaseCoordinator<RestoreWalletCoordinator.NavigationStep> {
    enum NavigationStep {
        case finishedRestoring(wallet: Wallet)
    }

    private let useCase: WalletUseCase

    init(navigationController: UINavigationController, useCase: WalletUseCase) {
        self.useCase = useCase
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toRestoreWallet()
    }
}

// MARK: - Private
private extension RestoreWalletCoordinator {

    func toRestoreWallet() {
        let viewModel = RestoreWalletViewModel(useCase: useCase)

        push(scene: RestoreWallet.self, viewModel: viewModel) { [unowned self] userIntendsTo in
            switch userIntendsTo {
            case .restoreWallet(let wallet): self.finishedRestoring(wallet: wallet)
            }
        }
    }

    func finishedRestoring(wallet: Wallet) {
        navigator.next(.finishedRestoring(wallet: wallet))
    }
}