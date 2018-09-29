//
//  RestoreWalletViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxCocoa
import RxSwift
import Zesame

final class RestoreWalletViewModel {
    private let bag = DisposeBag()

    private weak var navigator: RestoreWalletNavigator?
    private let useCase: ChooseWalletUseCase

    init(navigator: RestoreWalletNavigator, useCase: ChooseWalletUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
}

extension RestoreWalletViewModel: ViewModelType {

    struct Input {
        let privateKey: Driver<String>
        let restoreTrigger: Driver<Void>
    }

    struct Output {}

    func transform(input: Input) -> Output {

        let wallet = input.privateKey
            .flatMapLatest {
                self.useCase
                    .restoreWallet(from: .privateKey(hexString: $0))
                    .asDriverOnErrorReturnEmpty()
        }

        input.restoreTrigger
            .withLatestFrom(wallet)
            .do(onNext: {
                self.navigator?.toMain(restoredWallet: $0)
            }).drive().disposed(by: bag)

        return Output()
    }
}
