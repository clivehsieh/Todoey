//
//  ViewController.swift
//  Todoey
//
//  Created by Clive Hsieh on 2018/1/10.
//  Copyright © 2018年 Clive Hsieh. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet {
            
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.done ? .checkmark : .none
     
        return cell

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(itemArray[indexPath.row])")
    
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
    
        var newItemTitle = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "message", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks on the Add Item button on our UIAlert
         
        let newItem = Item(context: self.context)
            
        newItem.title = newItemTitle.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
            
        self.itemArray.append(newItem)
            
        self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTitle = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods

    func saveItems() {
 
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

        tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        
            request.predicate = compoundPredicate
 
        } else {
        
            request.predicate = categoryPredicate
       
        }
        
        do {
        
            itemArray = try context.fetch(request)
            
        } catch {
            
            print("Error saving context \(error)")
        
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
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

