//
//  ViewController.swift
//  chess_database
//
//  Created by Andrew's Laptop on 7/22/19.
//  Copyright © 2019 Andrew's Laptop. All rights reserved.
//

import UIKit
import GRDB

class ViewController: UIViewController {
    var turn = "B"
    var moveList = [String]()
    var index = -1
    var maxIndex = -1
    var dbQueue = DatabaseQueue()
    var notation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notationText.text! = notation
        //initialize database
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
        //for when segueing from search
        EnterGameScoreFunc()
    }
    
    func CalcIndex(square:String) ->Int{
        let file = String(square.prefix(1))
        //file is a letter so ascii can be used to bypass having a giant switch statement
        let asciiVal = Character(file).unicodeScalars.first?.value
        let rank = Int(square.suffix(1))
        //(Int(asciiVal!) - 97)) is file number and its subtracted from 7 cuz
        //UIImageView outlet collection was input in wrong order
        let index = (rank!-1)*8 + (7 - (Int(asciiVal!) - 97))
        //array is 64 big so subtract from 63 to bypass wrong ordering
        return 63 - index
    }
    
    func executeMove(notation:String, reverse:Bool){
        if(index > maxIndex){
            print("end of game score")
        }
        else if(moveList[index] == "0-0" && turn == "W"){
            chessBoard[CalcIndex(square: "e1")].image = UIImage(named: "BSquare")
            chessBoard[CalcIndex(square: "f1")].image = UIImage(named: "WRookWSquare")
            chessBoard[CalcIndex(square: "g1")].image = UIImage(named: "WKingBSquare")
            chessBoard[CalcIndex(square: "h1")].image = UIImage(named: "WSquare")
        }
        else if(moveList[index] == "0-0" && turn == "B"){
            chessBoard[CalcIndex(square: "e8")].image = UIImage(named: "WSquare")
            chessBoard[CalcIndex(square: "f8")].image = UIImage(named: "BRookBSquare")
            chessBoard[CalcIndex(square: "g8")].image = UIImage(named: "BKingWSquare")
            chessBoard[CalcIndex(square: "h8")].image = UIImage(named: "BSquare")
        }
        else if(moveList[index] == "0-0-0" && turn == "W"){
            chessBoard[CalcIndex(square: "a1")].image = UIImage(named: "BSquare")
            chessBoard[CalcIndex(square: "c1")].image = UIImage(named: "WKingBSquare")
            chessBoard[CalcIndex(square: "d1")].image = UIImage(named: "WRookWSquare")
            chessBoard[CalcIndex(square: "e1")].image = UIImage(named: "BSquare")
        }
        else if(moveList[index] == "0-0-0" && turn == "B"){
            chessBoard[CalcIndex(square: "a8")].image = UIImage(named: "WSquare")
            chessBoard[CalcIndex(square: "c8")].image = UIImage(named: "BKingWSquare")
            chessBoard[CalcIndex(square: "d8")].image = UIImage(named: "BRookBSquare")
            chessBoard[CalcIndex(square: "e8")].image = UIImage(named: "WSquare")
        }
        else {
            let m = moveExecution()
            let info = m.executeMove(notation: notation, reverse: reverse)
            //for pawn promotion 
            if(info.endSquare.suffix(1) == "8" && turn == "W" || info.endSquare.suffix(1) == "1" && turn == "B"){
                let alert = UIAlertController(title: "Select promotion", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Queen", style: .default, handler: {action in
                    self.defultMoveExecution(piece: "Queen" , notation: notation, reverse: reverse)
                }))
                alert.addAction(UIAlertAction(title: "Rook", style: .default, handler: {action in
                    self.defultMoveExecution(piece: "Rook", notation: notation, reverse: reverse)
                }))
                alert.addAction(UIAlertAction(title: "Knight", style: .default, handler: {action in
                    self.defultMoveExecution(piece: "Knight" ,notation: notation, reverse: reverse)
                }))
                alert.addAction(UIAlertAction(title: "Bishop", style: .default, handler: {action in
                    self.defultMoveExecution(piece: "Bishop", notation: notation, reverse: reverse)
                }))
                present(alert, animated: true, completion: nil)
            }
            defultMoveExecution(piece: info.piece,notation: notation, reverse: reverse)
        }
    }
    func defultMoveExecution(piece: String, notation:String , reverse:Bool) -> Void{
            let m = moveExecution()
            let info = m.executeMove(notation: notation, reverse: reverse)
            let color1 = m.getSquareColor(square: info.endSquare)
            let color2 = m.getSquareColor(square: info.startSquare)
            var assetName = ""
            assetName = assetName + turn + piece + color1 + "Square"
            let pieceImage = UIImage(named: assetName)
            let assetName2 = color2 + "Square"
            let pieceImage2 = UIImage(named: assetName2)
            let index1 = CalcIndex(square: info.endSquare)
            chessBoard[index1].image = pieceImage
            let index2 = CalcIndex(square: info.startSquare)
            chessBoard[index2].image = pieceImage2
    }
    
    @IBOutlet weak var notationText: UITextField!
 
    @IBAction func EnterMove(_ sender: Any) {
        if(turn == "W"){
            turn = "B"
        }
        else{
            turn = "W"
        }
        index = index + 1
        executeMove(notation: moveList[index], reverse: false)
    }
    
    @IBAction func ReverseMove(_ sender: Any) {
        executeMove(notation: moveList[index], reverse: true)
        index = index - 1
        if(turn == "W"){
            turn = "B"
        }
        else{
            turn = "W"
        }
    }
    
    //This code needs to be called for initialization too so its pulled out
    func EnterGameScoreFunc(){
        var acc = ""
        for x in notationText.text! {
            if(x != " "){
                acc = acc + String(x)
            }
            else{
                moveList.append(acc)
                acc = ""
                maxIndex = maxIndex + 1
            }
        }
        if(acc != ""){
            moveList.append(acc)
            maxIndex = maxIndex + 1
        }
    }
    
    @IBAction func EnterGameScore(_ sender: Any) {
        EnterGameScoreFunc()
    }
    
    @IBAction func enterToDatabase(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Game Data", message: nil, preferredStyle: .alert)
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
                try db.execute("""
                INSERT INTO chessDatabaseFile (player1, player2, gameScore)
                VALUES (?, ?, ?)
                """, arguments: [player1, player2, self.notationText.text!])
                }
            }
            catch{
                print(error)
            }
            }))
            present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var chessBoard: [UIImageView]!
}
