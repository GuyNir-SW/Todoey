//
//  ViewController.swift
//  Todoey
//
//  Created by Guy Nir on 17/09/2019.
//  Copyright © 2019 Guy Nir. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

/*
class Item : Codable {
    // Properties
    var name : String = ""
    var isSelected : Bool = false
    
    
    // Methods
    override init()     {
        name = ""
        isSelected = false
    }
    
    init(json: [String: Any])
    {
        self.name = json["name"] as! String
        self.isSelected = json["isSelected"] as! Bool
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.isSelected, forKey: "isSelected")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.isSelected = aDecoder.decodeObject(forKey: "isSelected") as! Bool
    }
 
    
}
 */

class TodoListViewController: UITableViewController {

    //MARK: Properties
    let realm = try! Realm()
    
    var itemArray : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        //loadItems()
        
        
    
    }
    
    // Mark: Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.isSelected ? .checkmark : .none
        }
        
        return cell
    
    }
    
    //MARK: TableView delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = itemArray?[indexPath.row] {
            print("Row: " + String(indexPath.row) + " Item: " + item.name)
            do {
                try realm.write {
                    item.isSelected = !item.isSelected
                }
            } catch {
                 print ("Error saving item: \(error)")
            }
            
        }
        
        // Selection is a single click, so automatically deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Make sure ui is updated
        self.tableView.reloadData()
        
    }
    
    //MARK: Add New item
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        var helperTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            // What will happen once the user clicks the add Button on the alert
            
            print ("Success")
            print(String(helperTextField.text!))
            
            
            // Add only if we have a category
            if let parentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.name = String(helperTextField.text!)
                        item.isSelected = false
                        parentCategory.items.append(item)
                    }
                }
                catch {
                    print ("Error saving item: \(error)")
                }
                
            }
            
            // Refresh UI
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create mew item"
            helperTextField = textField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    //MARK: Load & Save
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "name")
        self.tableView.reloadData()
    }
    
    /*
    func loadItems (with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        // Add predicate for category, combine it with the previous one if already exist.
        let predicateCategory = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
        
        if (request.predicate == nil) {
            request.predicate = predicateCategory
        } else {
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [request.predicate!, predicateCategory])
            request.predicate = compound
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print ("Error loading items: \(error)")
        }
        
        tableView.reloadData()
    }
 */
 
    
    
    func saveNewItem (item : Item) {
        
        
        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch {
            print ("Error saving item: \(error)")
        }
    }
    
    
    

}


//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Check for empty search
        if ((searchBar.text != nil) && (searchBar.text! != "" )) {
            itemArray = itemArray?.filter("name CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
            self.tableView.reloadData()
        }
        
        print (searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print ("Search change trigger, new value: " + searchBar.text!)
        
        if (searchBar.text?.count == 0) {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // It is like an empty search
        print ("Cancel was clicked")
        loadItems()
    }

}

