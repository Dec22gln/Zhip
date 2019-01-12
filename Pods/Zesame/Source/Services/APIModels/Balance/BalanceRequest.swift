//
//  BalanceRequest.swift
//  Zesame
//
//  Created by Alexander Cyon on 2018-09-10.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation
import JSONRPCKit

public struct BalanceRequest: JSONRPCKit.Request {
    public typealias Response = BalanceResponse

    public let address: AddressChecksummed
    public init(address: AddressChecksummedConvertible) {
        self.address = address.checksummedAddress
    }
}

public extension BalanceRequest {
    var method: String {
        return "GetBalance"
    }

    var parameters: Encodable? {
        return [address.checksummedAddress]
    }
}
