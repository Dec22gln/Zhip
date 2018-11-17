//
//  TrackableEvent.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

/// Trackable event, most likely user interaction, i.e, button tap.
protocol TrackableEvent {
    var eventName: String { get }
    var eventContext: String { get }
}

// MARK: Default Implemtation for `enum` that do not have RawTypes, using reflection
extension TrackableEvent {
    var eventName: String {
        if isEnum(type: self) {
            guard let nameOfEnumCase = nameOf(enumCase: self) else { incorrectImplementation("Fix the code that recursivly extracts name of nested enums, it contains some bug.") }
            return nameOfEnumCase
        } else {
            incorrectImplementation("You need to conform to `TrackableEvent`")
        }
    }

    var eventContext: String {
        return String(describing: type(of: self))
    }
}

