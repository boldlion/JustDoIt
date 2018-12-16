//
//  CategoryTVC.swift
//  JustDoIt
//
//  Created by Bold Lion on 5.12.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//
import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTVC: SwipeTVC {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        fetchCategories()
    }

    @IBAction func addCategoryTapped(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let name = textField.text {
                let category = Category()
                category.name = name
                category.backgroundColor = RandomFlatColor().hexValue()
                self.saveCategories(category: category)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "New Category Name"
            textField = alertTextField
        }
        alert.addAction(cancel)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destination = segue.destination as! ToDoListTVC
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    // MARK: - Data Methods
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving categories:", error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func fetchCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            if let category = self.categories?[indexPath.row] {
                try self.realm.write {
                    self.realm.delete(category)
                }
            }
        }
        catch {
            print("Error deleting the category: ", error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let catColor = UIColor(hexString: category.backgroundColor) else { fatalError() }
            cell.textLabel?.textColor = ContrastColorOf(catColor, returnFlat: true)
            cell.backgroundColor = catColor
        }
        return cell
    }
    
    // MARK: Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
}
