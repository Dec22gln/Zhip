//
//  ButtonWithSpinner.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ButtonWithSpinner: UIButton {

    private lazy var spinnerView = SpinnerView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

private extension ButtonWithSpinner {

    func setup() {
        addSubview(spinnerView)
        spinnerView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
    }

    func startSpinning() {
        titleLabel?.layer.opacity = 0
        bringSubviewToFront(spinnerView)
        spinnerView.startSpinning()
    }

    func stopSpinning () {
        titleLabel?.layer.opacity = 1
        sendSubviewToBack(spinnerView)
        spinnerView.stopSpinning()
    }

    func changeTo(isSpinning: Bool) {
        if isSpinning {
            startSpinning()
        } else {
            stopSpinning()
        }
    }
}

extension Reactive where Base: ButtonWithSpinner {
    var isLoading: Binder<Bool> {
        return Binder(base) {
            $0.changeTo(isSpinning: $1)
        }
    }
}
