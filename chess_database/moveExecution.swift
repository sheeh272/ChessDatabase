//
//  moveExecution .swift
//  chess_database
//
//  Created by Andrew's Laptop on 7/28/19.
//  Copyright © 2019 Andrew's Laptop. All rights reserved.
//

import Foundation

struct Moveinfo {
    var piece = "unset"
    var startSquare = "unset"
    var endSquare = "unset"
}

class moveExecution {
    //notation in form Nf3-d2
    func executeMove(notation:String) -> Moveinfo{
        var ret = Moveinfo()
        let piece = notation.prefix(1)
        switch piece{
            case "P":
                ret.piece = "Pawn"
            case "N":
                ret.piece = "Knight"
            case "B" :
                ret.piece = "Bishop"
            case "R" :
                ret.piece = "Rook"
            case "K" :
                ret.piece = "King"
            case "Q" :
                ret.piece = "Queen"
            default :
                ret.piece = "Error"
        }
        let temp = notation.prefix(3)
        ret.startSquare = String(temp.suffix(2))
        ret.endSquare = String(notation.suffix(2))
        return ret
    }
    func getSquareColor(square:String) -> String {
        let file = square.prefix(1)
        let rank = Int(square.suffix(1))!
        if(file == "a" || file == "c" || file == "e" || file == "g"){
            if(rank%2 == 0){
                return "W"
            }
            else {
                return "B"
            }
        }
        else{
             if(rank%2 == 0){
                return "B"
            }
            else {
                return "W"
            }
        }
    }
}
