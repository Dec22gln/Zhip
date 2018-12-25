//
//  UnlockAppWithPincodeView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift

private typealias € = L10n.Scene.UnlockAppWithPincode

final class UnlockAppWithPincodeView: ScrollingStackView {

    private lazy var inputPincodeView = InputPincodeView()

    lazy var stackViewStyle: UIStackView.Style = [
        inputPincodeView,
        .spacer
    ]
}

extension UnlockAppWithPincodeView: ViewModelled {
    typealias ViewModel = UnlockAppWithPincodeViewModel

    func populate(with viewModel: UnlockAppWithPincodeViewModel.Output) -> [Disposable] {
        return [
            viewModel.inputBecomeFirstResponder --> inputPincodeView.rx.becomeFirstResponder
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            pincode: inputPincodeView.rx.pincode.asDriver()
        )
    }
}
