//
//  TitledValueView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-14.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TitledValueView: UIStackView {

    fileprivate let titleLabel: UILabel
    fileprivate let valueTextView: UITextView

    init(
        titleStyle: UILabel.Style? = nil,
        valueStyle: UITextView.Style? = nil
        ) {

        let defaultTitleStyle = UILabel.Style(font: UIFont.Label.title, textColor: .black)

        let defaultValueStyle = UITextView.Style(
            font: UIFont.Label.value,
            textColor: .darkGray,
            isEditable: false,
            isScrollEnabled: false,
            // UILabel and UITextView horizontal alignment differs, change inset: stackoverflow.com/a/45113744/1311272
            contentInset: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        )

        let defaultStackViewStyle = UIStackView.Style(spacing: 8, margin: 0, isLayoutMarginsRelativeArrangement: false)

        let mergedTitleStyle = defaultTitleStyle.merge(yieldingTo: titleStyle)
        let mergedValueStyle = defaultValueStyle.merge(yieldingTo: valueStyle)

        self.titleLabel = UILabel(frame: .zero).withStyle(mergedTitleStyle)
        self.valueTextView = UITextView(frame: .zero).withStyle(mergedValueStyle)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        apply(style: defaultStackViewStyle)
        [valueTextView, titleLabel].forEach { insertArrangedSubview($0, at: 0) }
    }

    required init(coder: NSCoder) { interfaceBuilderSucks }
}

extension TitledValueView {
    func setValue(_ value: CustomStringConvertible) {
        valueTextView.text = value.description
    }

    func titled(_ text: CustomStringConvertible) -> TitledValueView {
        titleLabel.text = text.description
        return self
    }
}

extension Reactive where Base: TitledValueView {
    var title: Binder<String?> { return base.titleLabel.rx.text }
    var value: ControlProperty<String?> { return base.valueTextView.rx.text }
}
