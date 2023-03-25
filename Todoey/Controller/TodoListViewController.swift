//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pino Omodei on 23/03/23.
//

import UIKit

class TodoListViewController: UITableViewController { // as a UITVCtrl already inherit datasource and delegate protocols and outlets
    
    var todoListBrain = TodolistBrain()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Debug NavigationBar background and title colors: https://stackoverflow.com/questions/70834421
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
                
        // This will alter the navigation bar title appearance
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white] //alter to fit your needs
        appearance.titleTextAttributes = titleAttribute

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // end debug navigationBar background and title colors
        
        todoListBrain.loadData()

    }
    
    // MARK methods as datasource of the tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListBrain.itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listItemCellIdentifier, for: indexPath)
 
        // Configure content of the cell  (cell.textLabel = ... is going to be deprecated)
        var content = cell.defaultContentConfiguration()
        content.text = todoListBrain.itemsArray[indexPath.row].label
        content.imageProperties.tintColor = .purple
        cell.contentConfiguration = content
        cell.accessoryType = todoListBrain.itemsArray[indexPath.row].checked ? .checkmark : .none
        
        return(cell)
    }
    
    // MARK methods as delegate of the tableView: check/unchek the item + only "flash" when selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoListBrain.itemsArray[indexPath.row].checked = !todoListBrain.itemsArray[indexPath.row].checked
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.todoListBrain.saveData()
        // tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add Items
    @IBAction func onAddItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item in Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let newItemLabel = alert.textFields?[0].text {
                if newItemLabel != "" {
                    let newItem = TodoListItem(label: newItemLabel)
                    self.todoListBrain.itemsArray.append(newItem)
                    self.todoListBrain.saveData()
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.todoListBrain.itemsArray.count - 1, section: 0), at: .top, animated: true)
                }
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter the new item"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
