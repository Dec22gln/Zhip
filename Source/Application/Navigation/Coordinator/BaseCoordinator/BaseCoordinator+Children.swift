//
//  BaseCoordinator+Children.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-11-18.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import Foundation

extension BaseCoordinator {
    func anyCoordinatorOf<C>(type: C.Type) -> C? where C: AnyCoordinator {
        guard let coordinator = childCoordinators.compactMap({ $0 as? C }).first else {
            log.error("Coordinator has no child coordinator of type: `\(String(describing: type))`")
            return nil
        }
        return coordinator
    }

    func remove(childCoordinator: AnyCoordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}
