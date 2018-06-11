//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Clive Hsieh on 2018/5/10.
//  Copyright © 2018年 Clive Hsieh. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryList: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)

        loadCategories()

    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        cell.textLabel?.text  = categoryList?[indexPath.row].name ?? "Start Creating Categories"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryList?.count ?? 1
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "categoryToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryList?[indexPath.row]
            
        }
    
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func loadCategories() {

        categoryList = realm.objects(Category.self)

        tableView.reloadData()

    }
    
    func save(category: Category) {
        
        do {
            try realm.write{
                realm.add(category)
            }
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
        
            let addNewCategory = Category()
            
            addNewCategory.name = newCategoryName.text!

            self.save(category: addNewCategory)
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

        categoryList = categoryList?.filter("name CONTAINS %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    
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
