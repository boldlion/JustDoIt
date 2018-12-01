//
//  ViewController.swift
//  JustDoIt
//
//  Created by Bold Lion on 26.11.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit

class ToDoListTVC: UITableViewController {
    
    var items = [Item]()

    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems()
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataPath!)
        }
        catch {
            print("Error while encoding items array", error)
        }
        tableView.reloadData()
    }
    
    func fetchItems() {
    
        if let data = try? Data(contentsOf: dataPath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("error decoding items", error.localizedDescription)
            }
        }
    }
    
}

