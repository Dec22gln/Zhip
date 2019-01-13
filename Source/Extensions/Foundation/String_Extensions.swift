//
//  String_Extensions.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-26.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension String {

    enum CharacterInsertionPlace {
        case end
    }

    func inserting(string: String, every interval: Int) -> String {
        return String.inserting(string: string, every: interval, in: self)
    }

    static func inserting(
        string character: String,
        every interval: Int,
        in string: String,
        at insertionPlace: CharacterInsertionPlace = .end
    ) -> String {
        guard string.count > interval else { return string }
        var string = string
        var new = ""

        switch insertionPlace {
        case .end:
            while let piece = string.droppingLast(interval) {
                let toAdd: String = string.isEmpty ? "" : character
                new = "\(toAdd)\(piece)\(new)"
            }
            if !string.isEmpty {
                new = "\(string)\(new)"
            }
        }

        return new
    }

    mutating func droppingLast(_ k: Int) -> String? {
        guard k <= count else { return nil }
        let string = String(suffix(k))
        removeLast(k)
        return string
    }

    func sizeUsingFont(_ font: UIFont) -> CGSize {
        return self.size(withAttributes: [.font: font])
    }

    func widthUsingFont(_ font: UIFont) -> CGFloat {
        return sizeUsingFont(font).width
    }
}
