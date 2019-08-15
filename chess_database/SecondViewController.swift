//
//  SecondViewController.swift
//  chess_database
//
//  Created by Andrew's Laptop on 8/13/19.
//  Copyright © 2019 Andrew's Laptop. All rights reserved.
//

import UIKit
import GRDB

class SecondViewController: UIViewController {
    
    var dbQueue = DatabaseQueue()
    var data: [String] = []

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterGame(_ sender: Any) {
        performSegue(withIdentifier: "EnterGame", sender: self)
    }
    
    @IBAction func SearchGame(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Search parameters", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "player1"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "player2"
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            action in
            let player1 = (alert.textFields?.first?.text!)!
            let player2 = (alert.textFields?.last?.text!)!
            do {
                try self.dbQueue.inDatabase { db in
                self.data = try String.fetchAll(db,"SELECT gameScore FROM chessDatabaseFile WHERE player1 = ? AND player2 = ?", arguments: [player1, player2])
                }
            }
            catch{
                print(error)
            }
            self.performSegue(withIdentifier: "SearchGame", sender: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SearchGame"){
            let destVC : TableViewController = segue.destination as! TableViewController
            destVC.data = data
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
