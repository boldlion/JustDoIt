//
//  CategoryTVC.swift
//  JustDoIt
//
//  Created by Bold Lion on 5.12.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//
import CoreData
import UIKit

class CategoryTVC: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }

    @IBAction func addCategoryTapped(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let name = textField.text {
                let category = Category(context: self.context)
                category.name = name
                self.categories.append(category)
                self.saveCategories()
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
                destination.selectedCategory = categories[indexPath.row]
            }
        }
    }
    
    func saveCategories() {
        do {
            try context.save()
        }
        catch {
            print("Error saving categories:", error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func fetchCategories(with request: NSFetchRequest <Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        }
        catch {
            print("Error while fetching Categories from context:", error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        cell.category = categories[indexPath.row]
        return cell
    }
    
    // MARK: Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
}
