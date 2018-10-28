//
//  WarningERC20ViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-29.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WarningERC20ViewModel: AbstractViewModel<
    WarningERC20ViewModel.Step,
    WarningERC20ViewModel.InputFromView,
    WarningERC20ViewModel.Output
> {
    enum Step {
        case understandsRisks
        case understandsRisksSkipWarningFromNowOn
    }
    
    override func transform(input: Input) -> Output {
        bag <~ [
            input.fromView.accept.do(onNext: { [weak s=stepper] in
                s?.step(.understandsRisks)
            }).drive(),
            
            input.fromView.doNotShowAgain.do(onNext: { [weak s=stepper] in
                s?.step(.understandsRisksSkipWarningFromNowOn)
            }).drive()
        ]
        return Output()
    }
}

extension WarningERC20ViewModel {
    struct InputFromView {
        let accept: Driver<Void>
        let doNotShowAgain: Driver<Void>
    }
    
    
    struct Output {}
    
    
}
