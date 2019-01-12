//
//  Wallet.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-05-25.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

public struct Wallet {
    public let keystore: Keystore
    public let address: AddressChecksummed

    public init(keystore: Keystore, address: AddressChecksummedConvertible) {
        self.keystore = keystore
        self.address = address.checksummedAddress
    }
}
