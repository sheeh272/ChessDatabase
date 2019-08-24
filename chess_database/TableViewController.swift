//
//  TableViewController.swift
//  chess_database
//
//  Created by Andrew's Laptop on 8/13/19.
//  Copyright © 2019 Andrew's Laptop. All rights reserved.
//

import UIKit
import GRDB
class TableViewController: UITableViewController {
    
    var data = [String]()
    var notation = ""
    var dbQueue = DatabaseQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
            dbQueue = try DatabaseQueue(path: databaseURL.path)
            try dbQueue.inDatabase { db in
            try db.execute("""
            CREATE TABLE chessDatabaseFile (
            id INTEGER PRIMARY KEY,
            player1 TEXT NOT NULL,
            player2 Text NOT NULL,
            gameScore Text Not NULL)
            """)
            }
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        // Configure the cell...
        cell.accessoryType = .detailDisclosureButton
        cell.textLabel?.text = String(describing: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        notation = String(describing: data[indexPath.row])
        let alert = UIAlertController(title: "Select or Delete", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            action in
            do {
                try self.dbQueue.inDatabase { db in
                    try db.execute("DELETE FROM chessDatabaseFile WHERE gameScore = ?", arguments: [self.notation])
                }
                self.data.remove(at: indexPath.row)
                tableView.reloadData()
            }
            catch{
                print(error)
            }
        }))
         alert.addAction(UIAlertAction(title: "Select", style: .default, handler: {
            action in
            self.performSegue(withIdentifier: "SelectGame", sender: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : ViewController = segue.destination as! ViewController
        destVC.notation = notation
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
