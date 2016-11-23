//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Harry Ferrier on 8/8/16.
//  Copyright © 2016 CASTOVISION LIMITED. All rights reserved.
//

import UIKit



// Create a global variable places which is array array which is filled with dictionary values for keys: name, latitude and longitude. Initialize it to be empty..
var places = [Dictionary<String, String>()]

// Create 'activePlace variable globally and assign it a value of -1.
var activePlace = -1


class TableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if let temporaryPlaces =  UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
        
            places = temporaryPlaces
        
        }
        
        
        // If there is 1 value in the places array, and the values stored at index number 0 (the first and only item) are equal to 0 (or nil, basically there is nothing stored there)...
        if places.count == 1 && places[0].count == 0 {
            
            // Remove whatever value, if there is even one, to empty the array..
            places.remove(at: 0)
            
            // Then append the array with a dictionary value for the Taj Mahal...
            places.append(["name": "Taj Mahal", "latitude": "27.175277", "longitude": "78.042128"])
            
            
            
            
            // Save places into permenant storage
            UserDefaults.standard.set(places, forKey: "places")
            
        }
        
        activePlace = -1
        
        table.reloadData()
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.set(places, forKey: "places")
            
            table.reloadData()
        
        }
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return places.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        
        if places[indexPath.row]["name"] != nil {
        
            cell.textLabel?.text = places[indexPath.row]["name"]

        } else {
        
            cell.textLabel?.text = "Nothing stored in places array"
        
        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activePlace = indexPath.row
        
        performSegue(withIdentifier: "toMap", sender: nil)
        
    }

    
    
    
    
    
    
}
