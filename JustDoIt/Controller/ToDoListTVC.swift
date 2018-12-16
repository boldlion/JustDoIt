//
//  ViewController.swift
//  JustDoIt
//
//  Created by Bold Lion on 26.11.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListTVC: SwipeTVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            fetchItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = selectedCategory?.name
        guard let color = selectedCategory?.backgroundColor else { fatalError() }
        setNavBar(withHexColor: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar(withHexColor: "DA7553")
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let catColor = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
    
                cell.backgroundColor = catColor
                cell.textLabel?.textColor = ContrastColorOf(catColor, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No items yet"
        }
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }
            catch {
                print("Error deleting an item: ", error.localizedDescription)
            }
        }
    }
    
    func setNavBar(withHexColor hexColor: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        guard let navBarTintColor = UIColor(hexString: hexColor) else { fatalError() }
        navBar.barTintColor = navBarTintColor
        searchBar.barTintColor = navBarTintColor
        navBar.tintColor = ContrastColorOf(navBarTintColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarTintColor, returnFlat: true)]
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
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
