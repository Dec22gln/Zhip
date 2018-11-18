//
//  ReceiveView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Zesame

private typealias € = L10n.Scene.Receive

// MARK: - ReceiveView
private let stackViewMargin: CGFloat = 16
final class ReceiveView: ScrollingStackView {

    private lazy var qrImageView = UIImageView()

    private lazy var addressView = LabelsView(
        title: €.Label.myPublicAddress,
        valueStyle: UILabel.Style(numberOfLines: 0),
        stackViewStyle: UIStackView.Style(spacing: 0)
    )

    private lazy var amountToReceiveField = UITextField.Style(€.Field.amount, text: "237").make()

    private lazy var shareButton = UIButton(type: .custom)
        .withStyle(.secondary)
        .titled(normal: €.Button.share)

    private lazy var copyMyAddressButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.copyMyAddress)

    private lazy var buttonsStackView = UIStackView.Style([shareButton, copyMyAddressButton], axis: .horizontal, distribution: .fillEqually, margin: 0).make()

    // MARK: - StackViewStyling
    lazy var stackViewStyle = UIStackView.Style([
        qrImageView,
        addressView,
        amountToReceiveField,
        buttonsStackView
    ], margin: stackViewMargin)

    override func setup() {
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.clipsToBounds = true
    }
}

// MARK: - SingleContentView
extension ReceiveView: ViewModelled {
    typealias ViewModel = ReceiveViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            copyMyAddressTrigger: copyMyAddressButton.rx.tap.asDriver(),
            shareTrigger: shareButton.rx.tap.asDriverOnErrorReturnEmpty(),
            qrCodeImageWidth: UIScreen.main.bounds.width - 2 * stackViewMargin,
            amountToReceive: amountToReceiveField.rx.text.orEmpty.asDriver()
        )
    }

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {

        return [
            viewModel.receivingAddress      --> addressView.rx.value,
            viewModel.qrImage               --> qrImageView.rx.image
        ]
    }
}
