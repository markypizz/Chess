//
//  Chess.swift
//  Model and Constants Library
//
//  Created by Mark Pizzutillo on 12/31/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//
import Foundation

enum PlayerType : Int {
    case user = 0
    case ai = 1
}

/// Singleton Class Chess,
/// holds the game and scene instances
class Chess {
    var game : ChessGame!
    var scene : ChessScene!
    
    var demoScene : DemoScene!
    
    static var sharedInstance = Chess()
    
    static let boardChoices = ["regularchessboard","woodchessboard","graychessboard","greenchessboard","jebhead"]
    static let boardBodies = [String]()
    
    var boardSelection = UserDefaults.standard.integer(forKey: "boardIndex") {
        didSet {
            UserDefaults.standard.set(boardSelection, forKey: "boardIndex")
        }
    }
    
    static let chessColumnsToInteger : [String:Int] = ["A":1,"B":2,"C":3,"D":4,"E":5,"F":6,"G":7,"H":8]
    
    //Mostly used for debugging purposes
    static let chessColumnsToLetter : [Int:String] = [1:"A",2:"B",3:"C",4:"D",5:"E",6:"F",7:"G",8:"H"]
    
    init() {}
}

enum ChessError : Error {
    case humanMoveRequestedOnNonHumanTurn
    case noMoveOcurredOnTurn
}
