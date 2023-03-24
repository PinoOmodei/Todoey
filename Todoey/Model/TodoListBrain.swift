//
//  TodoListBrain.swift
//  Todoey
//
//  Created by Pino Omodei on 24/03/23.
//

import Foundation

struct TodolistBrain {
    var itemsArray: [TodoListItem] = []
    
    mutating func loadData (n: Int) {
        // load the data from UserDefaults.standard
        // UserDefaults.standard.removeObject(forKey: K.udItemsArray)
        let samples = ["Mangiare carne", "Bere vino", "Studiare Swift", "Salutare la famiglia", "Guadagnare di più", "Sistemare i bagni", "Pagare il conto", "Finire la scuola", "Andare in USA", "Preparare ESTA"]
        
        for _ in 1...n {
            itemsArray.append(TodoListItem(label: samples[Int.random(in: 0...9)]))
        }
    }
    
    func saveData() {
        print("saveData is disabled")
    }
    
}
