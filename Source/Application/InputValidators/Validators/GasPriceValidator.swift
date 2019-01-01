//
//  GasPriceValidator.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-15.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Zesame

import Validator

struct GasPriceValidator: InputValidator {

    typealias Error = AmountError<Li>

    func validate(input li: String) -> InputValidationResult<GasPrice, Error> {
        let gasPrice: GasPrice
        do {
            gasPrice = try GasPrice.init(li: li)
        } catch {
            return self.error(Error(error: error)!)
        }
        return .valid(gasPrice)
    }
}
