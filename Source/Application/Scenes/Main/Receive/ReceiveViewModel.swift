//
//  ReceiveViewModel.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame


final class ReceiveViewModel: Navigatable {
    enum Step {}

    private let wallet: Driver<Wallet>
    let stepper = Stepper<Step>()

    init(wallet: Driver<Wallet>) {
        self.wallet = wallet
    }
}


extension ReceiveViewModel: ViewModelType {

    struct Input: InputType {
        struct FromView {
            let qrCodeImageWidth: CGFloat
            let amountToReceive: Driver<String>
        }
        let fromView: FromView
        let fromController: ControllerInput
        
        init(fromView: FromView, fromController: ControllerInput) {
            self.fromView = fromView
            self.fromController = fromController
        }
    }

    struct Output {
        let receivingAddress: Driver<String>
        let qrImage: Driver<UIImage?>
    }

    func transform(input: Input) -> Output {

        let receivingAmount = input.fromView.amountToReceive
            .map { Double($0) }
            .filterNil()
            .startWith(0)
            .map { try? Amount(double: $0) }.filterNil()

        let qrImage = Driver.combineLatest(receivingAmount, wallet.map { $0.address }) { QRCoding.Transaction(amount: $0, to: $1) }
            .map { QRCoding.image(of: $0, size: input.fromView.qrCodeImageWidth) }

        return Output(
            receivingAddress: wallet.map { $0.address.checksummedHex },
            qrImage: qrImage
        )
    }
}
