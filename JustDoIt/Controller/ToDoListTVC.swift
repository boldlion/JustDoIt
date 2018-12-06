//
//  ViewController.swift
//  JustDoIt
//
//  Created by Bold Lion on 26.11.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var items = [Item]()
    var selectedCategory : Category? {
        didSet {
            fetchItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { alertTextField in
            alertTextField.placeholder = "Enter your To-Do Item here..."
            textField = alertTextField
        })
        let okayAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let title = textField.text {
                let item = Item(context: self.context)
                item.done = false
                item.title = title
                item.parentCategory = self.selectedCategory
                self.items.insert(item, at: 0)
                self.saveData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as! ToDoItemTVC
        cell.item = items[indexPath.row]
        return cell
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveData() {
        do {
           try context.save()
        }
        catch {
            print("Error while saving the context", error)
        }
        tableView.reloadData()
    }
    
    func fetchItems(with request: NSFetchRequest <Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context.fetch(request)
        }
        catch {
            print("Error while fetching Items from context:", error.localizedDescription )
        }
        tableView.reloadData()
    }
    
}

// MARK: - Search Bar Methods
extension ToDoListTVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest <Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchItems(with: request, predicate: predicate)
     }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
