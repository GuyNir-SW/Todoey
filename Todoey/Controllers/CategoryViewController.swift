//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Guy Nir on 27/09/2019.
//  Copyright © 2019 Guy Nir. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "99ff66")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.colorHexCode)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat:true)
        } else {
            cell.textLabel?.text = ""
        }
        
        
        
        
        
        return cell
    }
    
    
    //MARK: Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray?[indexPath.row]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var helperTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            // What will happen once the user clicks the add Button on the alert
            
            print ("Success")
            print(String(helperTextField.text!))
            
            let category = Category()
            category.name = String(helperTextField.text!)
            category.colorHexCode = UIColor.randomFlat()?.hexValue() ?? "555555"
            
            // Save data on storage
            self.saveNewCat(cat: category)
            
            // Refresh UI
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create mew category"
            helperTextField = textField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Load & Save
    
    func loadCategories () {
        
        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
    
    
    func saveNewCat (cat : Category) {
        
        
        do {
            try realm.write {
                realm.add(cat)
            }
        }
        catch {
            print ("Error saving item: \(error)")
        }
    }
    
    
    // MARK: Handle delete
    override func updateModelAtDelete(at indexPath: IndexPath) {
        super.updateModelAtDelete(at: indexPath)
        
        do {
            try self.realm.write {
                if let category = self.categoryArray?[indexPath.row] {
                    self.realm.delete(category)
                    //tableView.reloadData()
                }
            }
        } catch {
            
        }
        
    }
    
}



