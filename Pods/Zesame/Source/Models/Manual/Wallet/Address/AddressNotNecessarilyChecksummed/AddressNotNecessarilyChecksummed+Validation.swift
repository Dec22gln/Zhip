//
//  AddressNotNecessarilyChecksummed+Validation.swift
//  Zesame
//
//  Created by Alexander Cyon on 2019-01-12.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

public extension AddressNotNecessarilyChecksummed {
    public static let lengthOfValidAddresses: Int = 40
    static func validate(hexString: HexStringConvertible) throws {
        let length = hexString.length
        if length < lengthOfValidAddresses {
            throw Address.Error.tooShort
        }
        if length > lengthOfValidAddresses {
            throw Address.Error.tooLong
        }
        // is valid
    }
}
