//
//  MainViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift
import RxCocoa
import Zesame

// MARK: - MainUserAction
enum MainUserAction: TrackedUserAction {
    case send
    case receive
    case goToSettings
}

// MARK: - MainViewModel
private typealias € = L10n.Scene.Main
final class MainViewModel: BaseViewModel<
    MainUserAction,
    MainViewModel.InputFromView,
    MainViewModel.Output
> {

    private let transactionUseCase: TransactionsUseCase
    private let walletUseCase: WalletUseCase

    // MARK: - Initialization
    init(transactionUseCase: TransactionsUseCase, walletUseCase: WalletUseCase) {
        self.transactionUseCase = transactionUseCase
        self.walletUseCase = walletUseCase
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        func userIntends(to intention: Step) {
            stepper.step(intention)
        }

        let wallet = walletUseCase.wallet.filterNil().asDriverOnErrorReturnEmpty()

        let activityIndicator = ActivityIndicator()

        let fetchTrigger = Driver.merge(input.fromView.pullToRefreshTrigger, wallet.mapToVoid())

        let balanceResponse: Driver<BalanceResponse> = fetchTrigger.withLatestFrom(wallet).flatMapLatest {
            self.transactionUseCase
                .getBalance(for: $0.address)
                .trackActivity(activityIndicator)
                .asDriverOnErrorReturnEmpty()
        }

        let zeroBalance = wallet.map { WalletBalance(wallet: $0) }

        let balanceFromApi = Driver.combineLatest(wallet, balanceResponse) {
            WalletBalance(wallet: $0, balance: $1.balance, nonce: $1.nonce)
        }

        let balance = Driver.merge(zeroBalance, balanceFromApi)

        bag <~ [
            input.fromController.rightBarButtonTrigger
                .do(onNext: { userIntends(to: .goToSettings) })
                .drive(),

            input.fromView.sendTrigger
                .do(onNext: { userIntends(to: .send) })
                .drive(),

            input.fromView.receiveTrigger
                .do(onNext: { userIntends(to: .receive) })
                .drive()
        ]

        return Output(
            isFetchingBalance: activityIndicator.asDriver(),
            balance: balance.map { €.Label.Balance.value($0.balance.amount.description) }
        )
    }
}

extension MainViewModel {
    struct InputFromView {
        let pullToRefreshTrigger: Driver<Void>
        let sendTrigger: Driver<Void>
        let receiveTrigger: Driver<Void>
    }

    struct Output {
        let isFetchingBalance: Driver<Bool>
        let balance: Driver<String>
    }
}
