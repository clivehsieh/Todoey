//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Clive Hsieh on 2018/5/10.
//  Copyright © 2018年 Clive Hsieh. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        cell.textLabel?.text  = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "categoryToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    
    }
    
    
    //MARK: - Mdoel Manipulation Methods
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            
            categoryArray = try context.fetch(request)
        
        } catch {
            
            print("Error loading category data\(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveCategories() {
        
        do {
            try context.save()
        
        } catch {
            print("Error saving category data\(error)")
        
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add Categories
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryName = UITextField()
        
        let alert = UIAlertController(title: "Add a New Category" , message: "message", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            let addNewCategory = Category(context: self.context)
            
            addNewCategory.name = newCategoryName.text
            self.categoryArray.append(addNewCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Category"
            newCategoryName = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
}

//MARK: - Searchbar Methods

extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        loadCategories(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            
            loadCategories()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
        }
    }
}
