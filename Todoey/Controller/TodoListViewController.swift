//
//  ViewController.swift
//  Todoey
//
//  Created by Sherif Kamal on 10/25/18.
//  Copyright © 2018 Sherif Kamal. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.separatorStyle = .none
    }
    
    //MARk: Tableview data structure methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = todoItems?[indexPath.row].title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todoItems?.count)!)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = todoItems?[indexPath.row].done ?? false ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added for This Category"
        }
        
        return cell
    }
    
    //MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            try? realm.write {
                item.done = !item.done
            }
        }
        
        tableView.reloadData()
    }
    //MARK: adding new Item
    @IBAction func addBtnPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            if let text = textField.text, let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = text
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(item: Item) {
        
        try! realm.write {
                realm.add(item)
            }
    }
    
    func loadData() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            try? realm.write {
                realm.delete(item)
            }
        }
    }
}
//MARK: searchbar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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

