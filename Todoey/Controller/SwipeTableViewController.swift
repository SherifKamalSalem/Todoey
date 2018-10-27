//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Sherif Kamal on 10/27/18.
//  Copyright © 2018 Sherif Kamal. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deletionAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.updateModel(at: indexPath)
        }
        
        deletionAction.image = UIImage(named: "delete-icon")
        
        return [deletionAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
   
    func updateModel(at indexPath: IndexPath) {
        
    }

}
