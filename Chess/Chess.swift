//
//  Chess.swift
//  Model and Constants Library
//
//  Created by Mark Pizzutillo on 12/31/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

let chessColumnsToInteger : [String:Int] = ["A":1,"B":2,"C":3,"D":4,"E":5,"F":6,"G":7,"H":8]

//Mostly used for debugging purposes
let chessColumnsToLetter : [Int:String] = [1:"A",2:"B",3:"C",4:"D",5:"E",6:"F",7:"G",8:"H"]


enum PlayerType : Int{
    case user = 0
    case ai = 1
}

/// Singleton Class Chess,
/// holds the game and scene instances
class Chess {
    var game : ChessGame!
    var scene : ChessScene!
    
    static var sharedInstance = Chess()
    
    init() {}
}
