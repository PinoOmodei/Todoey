//
//  TodoListBrain.swift
//  Todoey
//
//  Created by Pino Omodei on 24/03/23.
//

import Foundation

struct TodolistBrain {
    var itemsArray: [String] = []
    
    mutating func loadData () {
        // load the data from UserDefaults.standard
        // UserDefaults.standard.removeObject(forKey: K.udItemsArray)
        if let items = UserDefaults.standard.array(forKey: K.udItemsArray) as? [String] {
            itemsArray = items
        }

    }
    
    func saveData() {
        UserDefaults.standard.set(itemsArray, forKey: K.udItemsArray)
    }
    
}
