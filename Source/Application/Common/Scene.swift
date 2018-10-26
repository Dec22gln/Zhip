//
//  Scene.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

import RxSwift
import TinyConstraints

/// Use typealias when you don't require a subclass. If your use case requires subclass, inherit from `SceneController`.
typealias Scene<View: UIView & ViewModelled> = SceneController<View>

/// The "Single-Line Controller" base class
class SceneController<ViewType>: UIViewController where ViewType: UIView & ViewModelled {
    typealias View = ViewType
    typealias ViewModel = View.ViewModel

    private let bag = DisposeBag()

    private let viewModel: ViewModel

    override func loadView() {
        view = View()
        view.backgroundColor = .white
        view.bounds = UIScreen.main.bounds
    }

    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewToViewModel()
        edgesForExtendedLayout = .bottom
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

private extension Scene {
    func bindViewToViewModel() {
        guard let contentView = view as? View else { return }

        let controllerInput = ControllerInput(
            viewDidLoad: rx.viewDidLoad,
            viewWillAppear: rx.viewWillAppear,
            viewDidAppear: rx.viewDidAppear
        )

        let input = ViewModel.Input(fromView: contentView.inputFromView, fromController: controllerInput)

        let output = viewModel.transform(input: input)

        contentView.populate(with: output).forEach { $0.disposed(by: bag) }
    }
}
