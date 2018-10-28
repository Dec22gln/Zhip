//
//  ScrollViewOwner.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

typealias ScrollingStackView = ScrollView & StackViewStyling

class ScrollView: UIScrollView {

    init() {
        super.init(frame: .zero)
        privateSetup()
    }

    // Subclass me
    func setup() {}

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

private extension ScrollView {
    func privateSetup() {
        setupContentView()
        contentInsetAdjustmentBehavior = .never
        setupRefreshControl()
        setup()
    }

    func setupContentView() {
        let contentView = makeView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.heightToSuperview()
        contentView.widthToSuperview()
        contentView.edgesToSuperview()
    }

    func makeView() -> UIView {
        guard let viewProvider = self as? ContentViewProvider else { fatalError("should conform to `ContentViewProvider`") }
        return viewProvider.makeContentView()
    }

    func setupRefreshControl() {
        alwaysBounceVertical = true
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl = refreshControl
    }
}

import RxSwift
import RxCocoa
extension Reactive where Base: ScrollingStackView {
    var isRefreshing: Binder<Bool> {
        return base.refreshControl!.rx.isRefreshing
    }

    var pullToRefreshTrigger: Driver<Void> {
        return base.refreshControl!.rx.controlEvent(.valueChanged)
            .asDriverOnErrorReturnEmpty()
    }
}
