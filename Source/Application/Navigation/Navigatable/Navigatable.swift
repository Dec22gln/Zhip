//
//  Navigatable.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-10-27.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import RxCocoa

protocol Navigatable {
    associatedtype NavigationStep
    var navigator: Navigator<NavigationStep> { get }
}
