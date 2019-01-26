// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import Zesame

struct AmountFormatter {
    func format<Amount>(amount: Amount, in unit: Zesame.Unit, showUnit: Bool = false) -> String where Amount: ExpressibleByAmount {
        let amountString = amount.formatted(unit: unit)
        guard showUnit else {
            return amountString
        }

        let unitName: String
        switch unit {
        case .li, .qa: unitName = unit.name
        case .zil: unitName = L10n.Generic.zils
        }

        return "\(amountString) \(unitName)"
    }
}

extension ExpressibleByAmount {
    func formatted(unit targetUnit: Zesame.Unit) -> String {
        let separator = Locale.current.decimalSeparator ?? "."
        let string = asString(in: targetUnit)
        guard !string.contains(separator) else {
            return string
        }
        return string.thousands
    }
}

extension String {
    var thousands: String {
        return inserting(string: " ", every: 3)
    }
}
