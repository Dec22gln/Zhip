//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import RxSwift
import RxCocoa

// MARK: - ChooseWalletUserAction
enum ChooseWalletUserAction: String, TrackedUserAction {
    case createNewWallet
    case restoreWallet
}

// MARK: - ChooseWalletViewModel
final class ChooseWalletViewModel: BaseViewModel<
    ChooseWalletUserAction,
    ChooseWalletViewModel.InputFromView,
    ChooseWalletViewModel.Output
> {

    override func transform(input: Input) -> Output {
        func userIntends(to intention: NavigationStep) {
            navigator.next(intention)
        }

        bag <~ [
            input.fromView.createNewWalletTrigger
                .do(onNext: { userIntends(to: .createNewWallet) })
                .drive(),

            input.fromView.restoreWalletTrigger
                .do(onNext: { userIntends(to: .restoreWallet) })
                .drive()
        ]
        return Output()
    }
}

extension ChooseWalletViewModel {

    struct InputFromView {
        let createNewWalletTrigger: Driver<Void>
        let restoreWalletTrigger: Driver<Void>
    }

    struct Output {}
}
