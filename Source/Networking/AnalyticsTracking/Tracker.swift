//
//  Tracker.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-02.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Type that can track events and sending them to some third party network storage
struct Tracker {

    private let preferences: Preferences

    init(preferences: Preferences = .default) {
        self.preferences = preferences
    }
}

// MARK: - Tracking
extension Tracker: Tracking {
    func track(event: TrackableEvent) {
        let eventName = "event: '\(event.eventName)'"
        guard preferences.isTrue(.hasAcceptedAnalyticsTracking) else {
            return log.verbose("User haven't accepted analytics tracker, omitting \(eventName)")
        }
        log.verbose("tracked \(eventName) 🌍")
    }
}
