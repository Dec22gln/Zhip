//
//  Unbound.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-12-30.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

public protocol Unbound: NoLowerbound & NoUpperbound {
    associatedtype Magnitude: Comparable & Numeric

    // "Designated" init, check bounds
    init(qa: Magnitude)

    /// Most important "convenience" init
    init(_ value: Magnitude)

    /// Various convenience inits
    init(_ doubleValue: Double)
    init(_ intValue: Int)
    init(_ stringValue: String) throws
    init<UE>(amount: UE) where UE: ExpressibleByAmount & Unbound
    init(zil: Zil)
    init(li: Li)
    init(qa: Qa)
    init(zil: String) throws
    init(li: String) throws
    init(qa: String) throws
}

public extension ExpressibleByAmount where Self: Unbound {
    /// Most important "convenience" init
    init(_ value: Magnitude) {
        self.init(qa: Self.toQa(magnitude: value))
    }

    init(valid: Magnitude) {
        self.init(valid)
    }
}

public extension ExpressibleByAmount where Self: Unbound {

    init(_ doubleValue: Double) {
        self.init(qa: Self.toQa(double: doubleValue))
    }

    init(_ intValue: Int) {
        self.init(Magnitude(intValue))
    }

    init(_ stringValue: String) throws {
        if let mag = Magnitude(decimalString: stringValue) {
            self = Self.init(mag)
        } else if let double = Double(stringValue) {
            self.init(double)
        } else {
            throw AmountError<Self>.nonNumericString
        }
    }
}

public extension ExpressibleByAmount where Self: Unbound {
    init<UE>(amount: UE) where UE: ExpressibleByAmount & Unbound {
        self.init(qa: amount.qa)
    }

    init(zil: Zil) {
        self.init(amount: zil)
    }

    init(li: Li) {
        self.init(amount: li)
    }

    init(qa: Qa) {
        self.init(amount: qa)
    }
}

public extension ExpressibleByAmount where Self: Unbound {
    init(zil zilString: String) throws {
        self.init(zil: try Zil(zilString))
    }

    init(li liString: String) throws {
        self.init(li: try Li(liString))
    }

    init(qa qaString: String) throws {
        self.init(qa: try Qa(qaString))
    }
}

// MARK: - ExpressibleByFloatLiteral
public extension ExpressibleByAmount where Self: Unbound {
    init(floatLiteral double: Double) {
        self.init(double)
    }
}

// MARK: - ExpressibleByIntegerLiteral
public extension ExpressibleByAmount where Self: Unbound {
    init(integerLiteral int: Int) {
        self.init(int)
    }
}

// MARK: - ExpressibleByStringLiteral
public extension ExpressibleByAmount where Self: Unbound {
    init(stringLiteral string: String) {
        do {
            try self = Self(string)
        } catch {
            fatalError("The `String` value (`\(string)`) passed was invalid, error: \(error)")
        }
    }
}
