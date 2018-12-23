//
//  CreateNewWalletCoordinator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import Zesame

import RxSwift
import RxCocoa

final class CreateNewWalletCoordinator: BaseCoordinator<CreateNewWalletCoordinator.NavigationStep> {
    enum NavigationStep {
        case didCreate(wallet: Wallet)
    }

    private let useCaseProvider: UseCaseProvider
    private lazy var walletUseCase = useCaseProvider.makeWalletUseCase()

    init(navigationController: UINavigationController, useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }

    override func start(didStart: Completion? = nil) {
        toCreateWallet()
    }
}

// MARK: Private
private extension CreateNewWalletCoordinator {

    func toCreateWallet() {
        let viewModel = CreateNewWalletViewModel(useCase: walletUseCase)

        push(scene: CreateNewWallet.self, viewModel: viewModel) { [unowned self] userDid in
            switch userDid {
            case .createWallet(let wallet): self.toBackupWallet(wallet: wallet)
            }
        }
    }

    func toBackupWallet(wallet: Wallet) {
        let coordinator = BackupWalletCoordinator(
            navigationController: navigationController,
            useCase: useCaseProvider.makeWalletUseCase(),
            wallet: .just(wallet)
        )

        start(coordinator: coordinator) { [unowned self] userFinished in
            switch userFinished {
            case .abort, .backUp: self.toMain(wallet: wallet)
            }
        }
    }

    func toMain(wallet: Wallet) {
        navigator.next(.didCreate(wallet: wallet))
    }

}
