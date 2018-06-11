//
//  ViewController.swift
//  Todoey
//
//  Created by Clive Hsieh on 2018/1/10.
//  Copyright © 2018年 Clive Hsieh. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet {
            
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType =  item.done ? .checkmark : .none
            
        } else {
        
            cell.textLabel?.text = "Please add items"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = todoItems?[indexPath.row] {
        
        do {
            try realm.write{
                
                item.done = !item.done
            
            }
         
            } catch {
                print("Error writing to done property of item\(error)")
                
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
    
        var newItemTitle = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "message", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks on the Add Item button on our UIAlert

            if let currentCategory = self.selectedCategory {
            
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        
                        newItem.title = newItemTitle.text!
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
                self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTitle = alertTextField

        }
        
        alert.addAction(action)
        alert.view.layoutIfNeeded()
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods

    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}

//MARK: - Search bar Methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {

            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()

            }
        }
    }
}

