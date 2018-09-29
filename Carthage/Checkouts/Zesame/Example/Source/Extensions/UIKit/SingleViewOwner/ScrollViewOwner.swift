//
//  ScrollViewOwner.swift
//  ZesameiOSExample
//
//  Created by Alexander Cyon on 2018-09-20.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

typealias ScrollingStackView = ScrollView & StackViewStyling

class ScrollView: UIScrollView {

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

private extension ScrollView {
    func setup() {
        setupContentView()
        contentInsetAdjustmentBehavior = .never
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
}
