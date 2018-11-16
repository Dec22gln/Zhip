//
//  BarButton.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

enum BarButton {
    case skip
}

// MARK: BarButtonContent
extension BarButton {
    var content: BarButtonContent {
        switch self {
        case .skip: return BarButtonContent(title: L10n.Generic.skip)
        }
    }
}
