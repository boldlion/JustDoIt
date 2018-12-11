//
//  ViewController.swift
//  JustDoIt
//
//  Created by Bold Lion on 26.11.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            fetchItems()
        }
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { alertTextField in
            alertTextField.placeholder = "Enter your To-Do Item here..."
            textField = alertTextField
        })
        let okayAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let title = textField.text, let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = title
                        item.dateCreated = Date()
                        category.items.append(item)
                    }
                }
                catch {
                    print("Error while saving the item: ", (error.localizedDescription) )
                }
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as! ToDoItemTVC
        cell.item = items?[indexPath.row]
        return cell
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }
            catch {
                print("Error while updating the status: ", error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    
    func fetchItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

// MARK: - Search Bar Methods
extension ToDoListTVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
