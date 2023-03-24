//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pino Omodei on 23/03/23.
//

import UIKit

class TodoListViewController: UITableViewController { // as a UITVCtrl already inherit datasource and delegate protocols and outlets
    
    var itemsArray: [String] = []

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
        
        // load the data from UserDefaults.standard
        // UserDefaults.standard.removeObject(forKey: K.udItemsArray)
        if let items = UserDefaults.standard.array(forKey: K.udItemsArray) as? [String] {
            itemsArray = items
        }

    }
    
    // MARK methods as datasource of the tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listItemCellIdentifier, for: indexPath)
 
        // Configure content of the cell  (cell.textLabel = ... is going to be deprecated)
        var content = cell.defaultContentConfiguration()
        content.text = itemsArray[indexPath.row]
        content.imageProperties.tintColor = .purple
        cell.contentConfiguration = content
        
        return(cell)
    }
    
    // MARK methods as delegate of the tableView: check/unchek the item + only "flash" when selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if (cell.accessoryType == .checkmark) {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
            UserDefaults.standard.set(itemsArray, forKey: K.udItemsArray)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add Items
    @IBAction func onAddItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item in Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let newItemLabel = alert.textFields?[0].text {
                if newItemLabel != "" {
                    let newItem = newItemLabel
                    self.itemsArray.append(newItem)
                    self.tableView.reloadData()
                    UserDefaults.standard.set(self.itemsArray, forKey: K.udItemsArray)
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
