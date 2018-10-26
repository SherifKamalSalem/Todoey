//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sherif Kamal on 10/26/18.
//  Copyright © 2018 Sherif Kamal. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ADD CATEGORY", style: .default) { (alertAction) in
            
            let category = Category()
            category.name = textField.text!
            
            self.save(category: category)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    //MARK: Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as? TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC!.selectedCategory = self.categories?[indexPath.row]
        }
    }
    
    //MARK: Data manipolation methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving data into db \(error)")
        }
        tableView.reloadData()
    }
    
    func load() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
