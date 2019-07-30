//
//  ViewController.swift
//  chess_database
//
//  Created by Andrew's Laptop on 7/22/19.
//  Copyright © 2019 Andrew's Laptop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var turn = "W"
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func executeMove(notation:String){
        let m = moveExecution()
        let info = m.executeMove(notation: notation)
        let color1 = m.getSquareColor(square: info.endSquare)
        let color2 = m.getSquareColor(square: info.startSquare)
        var assetName = ""
        assetName = assetName + turn + info.piece + color1 + "Square"
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
        if(notationText.text! == "0-0" && turn == "W"){
            chessBoard[CalcIndex(square: "e1")].image = UIImage(named: "BSquare")
            chessBoard[CalcIndex(square: "f1")].image = UIImage(named: "WRookWSquare")
            chessBoard[CalcIndex(square: "g1")].image = UIImage(named: "WKingBSquare")
            chessBoard[CalcIndex(square: "h1")].image = UIImage(named: "WSquare")
        }
        else if(notationText.text! == "0-0" && turn == "B"){
            chessBoard[CalcIndex(square: "e8")].image = UIImage(named: "WSquare")
            chessBoard[CalcIndex(square: "f8")].image = UIImage(named: "BRookBSquare")
            chessBoard[CalcIndex(square: "g8")].image = UIImage(named: "BKingWSquare")
            chessBoard[CalcIndex(square: "h8")].image = UIImage(named: "BSquare")
        }
        else if(notationText.text! == "0-0-0" && turn == "W"){
            chessBoard[CalcIndex(square: "a1")].image = UIImage(named: "BSquare")
            chessBoard[CalcIndex(square: "c1")].image = UIImage(named: "WKingBSquare")
            chessBoard[CalcIndex(square: "d1")].image = UIImage(named: "WRookWSquare")
            chessBoard[CalcIndex(square: "e1")].image = UIImage(named: "BSquare")
        }
        else if(notationText.text! == "0-0-0" && turn == "B"){
            chessBoard[CalcIndex(square: "a8")].image = UIImage(named: "WSquare")
            chessBoard[CalcIndex(square: "c8")].image = UIImage(named: "BKingWSquare")
            chessBoard[CalcIndex(square: "d8")].image = UIImage(named: "BRookBSquare")
            chessBoard[CalcIndex(square: "e8")].image = UIImage(named: "WSquare")
        }
        else{
            executeMove(notation: notationText.text!)
        }
         if(turn == "W"){
            turn = "B"
        }
        else{
            turn = "W"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var chessBoard: [UIImageView]!
    
}

