//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import UIKit

extension UIFont {
    // For `UITextField` floating placeholder
    static let hint = Font(.𝟙𝟞, .medium).make()

    /// For bread text
    static let body = Font(.𝟙𝟠, .regular).make()

    // `UIViewController`'s `title`, checkboxes, `UIBarButtonItem`, `UITextField`'s placeholder & value
    static let title = Font(.𝟙𝟠, .semiBold).make()

    // UIButton
    static let callToAction = Font(.𝟚𝟘, .semiBold).make()

    // First label in a scene
    static let header = Font(.𝟛𝟜, .bold).make()

    // Welcome, ChoseWallet scene
    static let impression = Font(.𝟜𝟠, .bold).make()

    static let bigBang = Font(.𝟠𝟞, .semiBold).make()
}

extension UIFont {
    static let sceneTitle: UIFont = .title
    static let checkbox: UIFont = .title
    static let barButtonItem: UIFont = .title
    static let button: UIFont = .callToAction

    enum Label {
        static let impression: UIFont = .impression
        static let header: UIFont = .header
        static let body: UIFont = .body
    }

    enum Field {
        static let floatingPlaceholder: UIFont = .hint
        static let textAndPlaceholder: UIFont = .title
    }
}

enum FontBarlow: String, FontNameExpressible {
    case regular = "Barlow-Regular"
    case medium = "Barlow-Medium"
    case bold = "Barlow-Bold"
    case semiBold = "Barlow-SemiBold"
}

struct Font {
    let size: FontSize
    fileprivate let name: String
    init(_ size: FontSize, _ barlow: FontBarlow) {
        self.size = size
        self.name = barlow.name
    }
}

extension Font {
    enum FontSize: CGFloat {
        // 𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡

        case 𝟙𝟞 = 16
        case 𝟙𝟠 = 18
        case 𝟚𝟘 = 20

        case 𝟛𝟜 = 34

        case 𝟜𝟠 = 48
        case 𝟠𝟞 = 86
    }
}

protocol FontNameExpressible {
    var name: String { get }
}

extension FontNameExpressible where Self: RawRepresentable, Self.RawValue == String {
    var name: String {
        return rawValue
    }
}

extension Font {
    func make() -> UIFont {
        guard let customFont = UIFont(name: name, size: size.rawValue) else {
            incorrectImplementation("Failed to load custom font named: '\(name)'")
        }
        return customFont
    }
}
