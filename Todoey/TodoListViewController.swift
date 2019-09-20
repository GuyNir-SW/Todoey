//
//  ViewController.swift
//  Todoey
//
//  Created by Guy Nir on 17/09/2019.
//  Copyright © 2019 Guy Nir. All rights reserved.
//

import UIKit
class Item : Codable {
    // Properties
    var name : String = ""
    var isSelected : Bool = false
    
    /*
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
    */
    
}

class TodoListViewController: UITableViewController {

    //MARK: Properties
    var itemArray : [Item] = []
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        // Do any additional setup after loading the view.
        loadItems()
        
        
    
    }
    
    // Mark: Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        return cell
    
    }
    
    //MARK: TableView delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row: " + String(indexPath.row) + " Item: " + itemArray[indexPath.row].name)
        
        let item = itemArray[indexPath.row]
        item.isSelected = !item.isSelected
        
        // Selection is a single click, so automatically deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Save the new change
        self.saveItems()
        
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
            
            let item : Item = Item()
            item.name = String(helperTextField.text!)
            
            self.itemArray.append(item)
            
            // Save data on storage
            self.saveItems()
            
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
    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error decoding \(error)")
            }
        }
    }
    
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print ("Error saving item: \(error)")
        }
    }
    

}

