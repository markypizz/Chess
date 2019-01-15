//
//  ConstantsModel.swift
//  Constants Library
//
//  Created by Mark Pizzutillo on 12/31/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import Foundation

let chessColumnsToInteger : [String:Int] = ["A":1,"B":2,"C":3,"D":4,"E":5,"F":6,"G":7,"H":8]

//Mostly used for debugging purposes
let chessColumnsToLetter : [Int:String] = [1:"A",2:"B",3:"C",4:"D",5:"E",6:"F",7:"G",8:"H"]

enum PlayerType {
    case ai
    case user
}
