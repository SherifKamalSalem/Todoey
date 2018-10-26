//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sherif Kamal on 10/26/18.
//  Copyright © 2018 Sherif Kamal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ADD CATEGORY", style: .default) { (alertAction) in
            
            let category = Category(context: self.context)
            category.name = textField.text
            
            self.categoryArray.append(category)
            self.saveData()
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
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    //MARK: Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as? TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC!.selectedCategory = self.categoryArray[indexPath.row]
        }
    }
    
    //MARK: Data manipolation methods
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error saving data into db \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            try categoryArray = context.fetch(request)
        } catch {
            print("error fetching data from db \(error)")
        }
        
        tableView.reloadData()
    }
}
