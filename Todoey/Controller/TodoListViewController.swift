//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pino Omodei on 23/03/23.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController { // as a UITVCtrl already inherit datasource and delegate protocols and outlets
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // it's exactly as a DBMS session
    var itemsArray: [TodoListItem] = []   // After a LONG and DEEP reasoning it is CORRECT to have the array in the controller, not in the model
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debug NavigationBar background and title colors: https://stackoverflow.com/questions/70834421
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        
        // This will alter the navigation bar title appearance
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white] //alter to fit your needs
        appearance.titleTextAttributes = titleAttribute
        
        // PINO WAS HERE: white buttons please!
        navigationController?.navigationBar.tintColor = UIColor.white;
   
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // end debug navigationBar background and title colors
        
        // load the array from the (data)model
        self.title = selectedCategory?.name ?? "(none)"        
        loadData()
    }
    
    // MARK: - methods as datasource of the tableView - the datasource IS the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listItemCellIdentifier, for: indexPath)
 
        // Configure content of the cell  (cell.textLabel = ... is going to be deprecated)
        var content = cell.defaultContentConfiguration()
        content.text = itemsArray[indexPath.row].label
        content.imageProperties.tintColor = .purple
        cell.contentConfiguration = content
        cell.accessoryType = itemsArray[indexPath.row].checked ? .checkmark : .none
        
        return(cell)
    }
    
    // MARK: - methods as delegate of the tableView: check/unchek the item + only "flash" when selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsArray[indexPath.row].checked = !itemsArray[indexPath.row].checked  // this is an UPDATE in the context
        saveData()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            if let self = self {
                self.context.delete(self.itemsArray[indexPath.row])
                self.saveData()
                self.itemsArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    // MARK: - Adding an Item
    @IBAction func onAddItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item in Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let newItemLabel = alert.textFields?[0].text {
                if newItemLabel != "" {
                    let newItem = TodoListItem(context: self.context)  // insert new item in the Todoey.TodoListItem Entity
                    newItem.label = newItemLabel
                    newItem.checked = false
                    newItem.category = self.selectedCategory
                    self.saveData()
                    self.itemsArray.append(newItem)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.itemsArray.count - 1, section: 0), at: .top, animated: true)
                }
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter the new item"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Persistence management (save, load)
    //    func loadData(with request: NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()) {
    func loadData(with otherPredicate: NSPredicate? = nil) {
        let request: NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "category = %@", selectedCategory!)
        if otherPredicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, otherPredicate!])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemsArray = try context.fetch(request)  // select * into itemsArray from Todoey.TodoListItems ...
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
   
    
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let predicate = NSPredicate(format: "label CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        
        loadData(with: predicate)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadData()
            tableView.reloadData()
        }
    }
    
    
}
