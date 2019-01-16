//
//  ViewController.swift
//  Todoey
//
//  Created by Amit Wankhade on 15/1/19.
//  Copyright © 2019 Amit Wankhade. All rights reserved.
//

import UIKit

class ToDOListViewController: UITableViewController {

    var itemArray : [ToDoItem] = []
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("dataFilePath = \(dataFilePath)")
        loadToDoItems()
    }

    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        print("Table reload")
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        print("\(indexPath.row) " + item.title)
        item.done = !item.done
        saveToDoItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var localTextField = UITextField();
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("user clicks add item. \(localTextField.text)" );
            
            let item = ToDoItem()
            item.title = localTextField.text!
            self.itemArray.append(item)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveToDoItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            localTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveToDoItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print(error)
        }
        
        print("Items saved. reloading table")
        tableView.reloadData()
    }
    
    func loadToDoItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            }catch{
                print("Error while decoding data ")
            }
        }
    }
}

