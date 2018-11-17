//
//  ConfirmNewPincodeViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - ConfirmNewPincodeUserAction
enum ConfirmNewPincodeUserAction: TrackedUserAction {
    case confirmPincode
    case skip
}

// MARK: - ConfirmNewPincodeViewModel
final class ConfirmNewPincodeViewModel: BaseViewModel<
    ConfirmNewPincodeUserAction,
    ConfirmNewPincodeViewModel.InputFromView,
    ConfirmNewPincodeViewModel.Output
> {
    private let useCase: PincodeUseCase
    private let unconfirmedPincode: Pincode

    init(useCase: PincodeUseCase, confirm unconfirmedPincode: Pincode) {
        self.useCase = useCase
        self.unconfirmedPincode = unconfirmedPincode
    }

    // swiftlint:disable:next function_body_length
    override func transform(input: Input) -> Output {
        let unconfirmedPincode = self.unconfirmedPincode
        let confirmedPincode = input.fromView.pincode.map { pincode -> Pincode? in
            guard pincode == unconfirmedPincode else { return nil }
            return pincode
        }
        let isConfirmPincodeEnabled = Driver.combineLatest(confirmedPincode.map { $0 != nil }, input.fromView.haveBackedUpPincode) { $0 && $1 }

        bag <~ [
            input.fromView.confirmedTrigger.withLatestFrom(confirmedPincode.filterNil())
                .do(onNext: { [unowned self] in
                self.useCase.userChoose(pincode: $0)
                self.stepper.step(.confirmPincode)
            }).drive(),

            input.fromController.rightBarButtonTrigger.do(onNext: { [unowned stepper] in
                stepper.step(.skip)
            }).drive()
        ]

        return Output(
            isConfirmPincodeEnabled: isConfirmPincodeEnabled
        )
    }
}

extension ConfirmNewPincodeViewModel {
    struct InputFromView {
        let pincode: Driver<Pincode?>
        let haveBackedUpPincode: Driver<Bool>
        let confirmedTrigger: Driver<Void>
    }

    struct Output {
        let isConfirmPincodeEnabled: Driver<Bool>
    }

}
