//
//  ViewModelled.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-09-08.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import RxSwift

protocol ViewModelled: EmptyInitializable {
    associatedtype ViewModel: ViewModelType
    typealias InputFromView = ViewModel.Input.FromView
    var inputFromView: InputFromView { get }
    func populate(with viewModel: ViewModel.Output) -> [Disposable]
}

extension ViewModelled {
    func populate(with viewModel: ViewModel.Output) -> [Disposable] { return [] }
}
