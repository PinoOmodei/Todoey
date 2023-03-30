//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pino Omodei on 30/03/23.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // it's exactly as a DBMS session
    var categoriesArray: [Category] = []   // After a LONG and DEEP reasoning it is CORRECT to have the array in the controller, not in the model

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
        loadData()
 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCategoryCellIdentifier, for: indexPath)
        
        // Configure content of the cell  (cell.textLabel = ... is going to be deprecated)
        var content = cell.defaultContentConfiguration()
        content.text = categoriesArray[indexPath.row].name
        content.imageProperties.tintColor = .purple
        cell.contentConfiguration = content
        
        return(cell)
    }

    // MARK: - methods as delegate of the tableView: navigate to Items + delete on leadingSwipe
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // print("Category \(categoriesArray[indexPath.row].name ?? "(none)") was selected")
        performSegue(withIdentifier: K.segue, sender: self)

    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            if let self = self {
                self.context.delete(self.categoriesArray[indexPath.row])
                self.saveData()
                self.categoriesArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    

    // MARK: - onAdd to add Categories
    @IBAction func onAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category in Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let newCategoryName = alert.textFields?[0].text {
                if newCategoryName != "" {
                    let newCategory = Category(context: self.context)  // insert new category in the Todoey.Category Entity
                    newCategory.name = newCategoryName
                    self.saveData()
                    self.categoriesArray.append(newCategory)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.categoriesArray.count - 1, section: 0), at: .top, animated: true)
                }
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter the new category name"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Persistence management (save, load)
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoriesArray = try context.fetch(request)  // select * into categoriesArray from Todoey.Category
        } catch {
            print("Error fetching categories: \(error)")
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
