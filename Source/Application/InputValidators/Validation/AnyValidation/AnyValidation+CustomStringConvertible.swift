//
//  AnyValidation+CustomStringConvertible.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-11.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

// MARK: - CustomStringConvertible
extension AnyValidation: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty: return "empty"
        case .valid(let remark):
            if let remark = remark {
                return "valid, with remark: \(remark)"
            } else {
                return "valid"
            }
        case .errorMessage(let errorMsg): return "error: \(errorMsg)"
        }
    }
}
