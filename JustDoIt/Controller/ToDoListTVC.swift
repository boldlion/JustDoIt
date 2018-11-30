//
//  ViewController.swift
//  JustDoIt
//
//  Created by Bold Lion on 26.11.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit

class ToDoListTVC: UITableViewController {
    
   // var items = [String]()
    var items = [Item]()

    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = Item(title: "Blah blah")
        let item2 = Item(title: "Blah blah")
        items.append(item1)
        items.append(item2)
        
        if let itemsArray = defaults.array(forKey: "ToDoItems") as? [Item] {
            items = itemsArray
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
            if let itemTitle = textField.text {
                 let item = Item(title: itemTitle)
                self.items.insert(item, at: 0)
                //self.defaults.set(self.items, forKey: "ToDoItems")
                self.tableView.reloadData()
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
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

