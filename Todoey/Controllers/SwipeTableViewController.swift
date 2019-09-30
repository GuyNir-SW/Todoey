//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Guy Nir on 29/09/2019.
//  Copyright © 2019 Guy Nir. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print ("Delete cell")
            self.updateModelAtDelete(at: indexPath)
            /*
            do {
                try self.realm.write {
                    if let category = self.categoryArray?[indexPath.row] {
                        self.realm.delete(category)
                        tableView.reloadData()
                    }
                }
            } catch {
                
            }
             */
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    // Function triggered upon deletion
    func updateModelAtDelete(at indexPath: IndexPath) {
        // Do nothing here, child classes should override
    }

    

}
