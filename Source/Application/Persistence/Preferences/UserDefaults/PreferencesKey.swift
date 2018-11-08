//
//  PreferencesKey.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Insensitive values to be stored into e.g. `UserDefaults`, such as `hasAcceptedTermsOfService`
enum PreferencesKey: String, KeyConvertible {
    case hasAcceptedTermsOfService
    case hasAcceptedAnalyticsTracking
    case skipShowingERC20Warning
}

/// Abstraction of UserDefaults
typealias Preferences = KeyValueStore<PreferencesKey>
