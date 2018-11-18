//
//  MainView.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-16.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias € = L10n.Scene.Main

final class MainView: ScrollingStackView, PullToRefreshCapable {

    private lazy var balanceLabels = LabelsView(
        titleStyle: .Large,
        valueStyle: .huge
        ).titled(€.Label.Balance.title)

    private lazy var sendButton = UIButton(type: .custom)
        .withStyle(.primary)
        .titled(normal: €.Button.send)

    private lazy var receiveButton = UIButton(type: .custom)
        .withStyle(.secondary)
        .titled(normal: €.Button.receive)

    lazy var stackViewStyle = UIStackView.Style([
        balanceLabels,
        .spacer(verticalContentHuggingPriority: .defaultHigh),
        sendButton,
        receiveButton
        ], spacing: 8)
}

extension MainView: ViewModelled {
    typealias ViewModel = MainViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            pullToRefreshTrigger: rx.pullToRefreshTrigger,
            sendTrigger: sendButton.rx.tap.asDriverOnErrorReturnEmpty(),
            receiveTrigger: receiveButton.rx.tap.asDriverOnErrorReturnEmpty()
        )
    }

    func populate(with viewModel: MainViewModel.Output) -> [Disposable] {
        return [
            viewModel.balance --> balanceLabels.rx.value
        ]
    }
}
