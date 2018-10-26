//
//  ViewController.swift
//  Todoey
//
//  Created by Sherif Kamal on 10/25/18.
//  Copyright © 2018 Sherif Kamal. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARk: Tableview data structure methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveData()
        tableView.reloadData()
    }
    //MARK: adding new Item
    @IBAction func addBtnPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            if let text = textField.text {
                
                let item = Item(context: self.context)
                item.title = text
                item.done = false
                item.parentCategory = self.selectedCategory
                self.itemArray.append(item)
                self.saveData()
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch let error {
            print("error can't save into database \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), andPredicate predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch let error {
            print("error cannot retrieve data from DB \(error)")
        }
    }
}
//MARK: searchbar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, andPredicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

