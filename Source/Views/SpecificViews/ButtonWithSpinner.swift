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

    private lazy var spinnerView: SpinnerView = {
        let spinnerView = _spinnerView ?? SpinnerView(strokeColor: titleColor(for: .normal))
        addSubview(spinnerView)
        spinnerView.edgesToSuperview(insets: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
        return spinnerView
    }()
    private var _spinnerView: SpinnerView?

    init(title: CustomStringConvertible? = nil, strokeColor: UIColor? = nil) {
        if let strokeColor = strokeColor {
            _spinnerView = SpinnerView(strokeColor: strokeColor)
        }
        super.init(frame: .zero)
        setTitle(title?.description, for: .normal)
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

private extension ButtonWithSpinner {

    func beginRefreshing() {
        titleLabel?.layer.opacity = 0
        bringSubviewToFront(spinnerView)
        spinnerView.beginRefreshing()
    }

    func endRefreshing () {
        titleLabel?.layer.opacity = 1
        sendSubviewToBack(spinnerView)
        spinnerView.endRefreshing()
    }

    func changeTo(isLoading: Bool) {
        if isLoading {
            beginRefreshing()
        } else {
            endRefreshing()
        }
    }
}

extension Reactive where Base: ButtonWithSpinner {
    var isLoading: Binder<Bool> {
        return Binder(base) {
            $0.changeTo(isLoading: $1)
        }
    }
}
