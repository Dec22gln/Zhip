// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Presentation
extension Coordinating {

    /// This method is used to push a new Scene (ViewController).
    ///
    /// - Parameters:
    ///   - scene: Type of `Scene` (UIViewController) to present.
    ///   - viewModel: An instance of the ViewModel used by the `Scene`s View.
    ///   - animated: Whether to animate the presentation of the scene or not.
    ///   - navigationPresentationCompletion: Optional closure invoked when the
    ///       presentation of the scene is done (animation has finished). This
    ///       is convenient when you want to present any other scene after this
    ///       scene.
    ///   - navigationHandler: **Required** closure for handling navigation steps
    ///       from the ViewModel.
    ///   - step: Navigation step emitted by the scene's `viewModel`
    func push<S, V>(
        scene _: S.Type,
        viewModel: V.ViewModel,
        animated: Bool = true,
        navigationPresentationCompletion: Completion? = nil,
        navigationHandler: @escaping (_ step: V.ViewModel.NavigationStep) -> Void
        ) where S: Scene<V>, V: ContentView, V.ViewModel: Navigating {

        // Create a new instance of the `Scene`, injecting its ViewModel
        let scene = S.init(viewModel: viewModel)

        // Present the viewController
        navigationController.setRootViewControllerIfEmptyElsePush(
            viewController: scene,
            animated: animated,
            completion: navigationPresentationCompletion
        )

        // Subscribe to the navigation steps emitted by the viewModel's navigator
        // And invoke the navigationHandler closure passed in to this method
        bag <~ viewModel.navigator.navigation.do(onNext: {
            navigationHandler($0)
        }).drive()
    }
}

private extension UINavigationController {
    func setRootViewControllerIfEmptyElsePush(
        viewController: UIViewController,
        animated: Bool,
        completion: Completion? = nil
        ) {

        if viewControllers.isEmpty {
            setViewControllers([viewController], animated: false)
        } else {
            pushViewController(viewController, animated: animated)
        }

        // Add extra functionality to pass a "completion" closure even for `push`ed ViewControllers.
        guard let completion = completion else { return }
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
