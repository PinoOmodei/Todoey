//
//  TodoListBrain.swift
//  Todoey
//
//  Created by Pino Omodei on 24/03/23.
//

import Foundation

struct TodolistBrain {
    var itemsArray: [TodoListItem] = []
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: K.plistFilename)
        
    mutating func loadData() {
        // bulkLoadData(n: 30)
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            let items = try decoder.decode([TodoListItem].self, from: data)
        } catch {
            print("Error loading itemsArray: \(error)")
        }
  
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error saving itemsArray: \(error)")
        }
    }
    
    mutating func bulkLoadData (n: Int) {
        // load the data from UserDefaults.standard
        // UserDefaults.standard.removeObject(forKey: K.udItemsArray)
        let samples = ["Mangiare carne", "Bere vino", "Studiare Swift", "Salutare la famiglia", "Guadagnare di più", "Sistemare i bagni", "Pagare il conto", "Finire la scuola", "Andare in USA", "Preparare ESTA"]
        
        for _ in 1...n {
            itemsArray.append(TodoListItem(label: samples[Int.random(in: 0...9)]))
        }
    }

    
}
