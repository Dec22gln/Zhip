//
//  TableViewOwner.swift
//  Zhip
//
//  Created by Alexander Cyon on 2019-01-13.
//  Copyright © 2019 Open Zesame. All rights reserved.
//

import Foundation

protocol TableViewOwner {
    associatedtype Header
    associatedtype Cell: ListCell
    var tableView: SingleCellTypeTableView<Header, Cell> { get }
}
