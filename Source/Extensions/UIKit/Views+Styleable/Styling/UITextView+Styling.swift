//
//  UITextView+Styling.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UITextView: Styling, StaticEmptyInitializable, ExpressibleByStringLiteral {

    public static func createEmpty() -> UITextView {
        return UITextView()
    }

    public final class Style: ViewStyle, Makeable, ExpressibleByStringLiteral {

        public typealias View = UITextView

        public let text: String?
        public let textAlignment: NSTextAlignment?
        public let textColor: UIColor?
        public let font: UIFont?
        public let isEditable: Bool?
        public let isSelectable: Bool?
        public let contentInset: UIEdgeInsets?
        public let isScrollEnabled: Bool?

        public init(
            _ text: String? = nil,
            textAlignment: NSTextAlignment? = nil,
            height: CGFloat? = nil,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            isEditable: Bool? = nil,
            isSelectable: Bool? = nil,
            isScrollEnabled: Bool? = nil,
            contentInset: UIEdgeInsets? = nil
            ) {
            self.text = text
            self.textAlignment = textAlignment
            self.textColor = textColor
            self.font = font
            self.isEditable = isEditable
            self.isSelectable = isSelectable
            self.isScrollEnabled = isScrollEnabled
            self.contentInset = contentInset
            super.init(height: height, backgroundColor: backgroundColor)
        }

        public convenience init(stringLiteral title: String) {
            self.init(title)
        }

        static var `default`: Style {
            return Style()
        }

        public func merged(other: Style, mode: MergeMode) -> Style {
            func merge<T>(_ attributePath: KeyPath<Style, T?>) -> T? {
                return mergeAttribute(other: other, path: attributePath, mode: mode)
            }

            return Style(
                merge(\.text),
                textAlignment: merge(\.textAlignment),
                height: merge(\.height),
                font: merge(\.font),
                textColor: merge(\.textColor),
                backgroundColor: merge(\.backgroundColor),
                isEditable: merge(\.isEditable),
                isSelectable: merge(\.isSelectable),
                isScrollEnabled: merge(\.isScrollEnabled),
                contentInset: merge(\.contentInset)
            )
        }
    }

    public func apply(style: Style) {
        text = style.text
        textAlignment = style.textAlignment ?? .left
        font = style.font ?? UIFont.small
        textColor = style.textColor ?? .defaultText
        isEditable = style.isEditable ?? true
        isSelectable = style.isSelectable ?? true
        isScrollEnabled = style.isScrollEnabled ?? true
        contentInset = style.contentInset ?? UIEdgeInsets.zero
    }
}

extension UITextView.Style {
    static var huge: UITextView.Style {
        return UITextView.Style(font: UIFont.huge)
    }
}
