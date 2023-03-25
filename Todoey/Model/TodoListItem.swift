//
//  TodoListItem.swift
//  Todoey
//
//  Created by Pino Omodei on 24/03/23.
//

import Foundation

struct TodoListItem : Codable {
    let label: String
    var checked: Bool = false
}
