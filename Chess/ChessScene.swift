//
//  ChessScene.swift
//  Chess
//
//  Created by Mark Pizzutillo on 12/25/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import SceneKit

class ChessScene {
    
    //Generate Chess Scene
    let scene = SCNScene(named: "ChessScene.scn")
    
    //Offset to obtain column/row from piece coordinate
    let pieceCoordOffset : Float = 3.5
    let boardCoordOffset : Float = 4.0
    
    init() {
        let material = SCNMaterial()
        
        //Set chessboard image on plane
        material.diffuse.contents = UIImage(named: "chessboard")
        
        scene?.rootNode.childNode(withName: "plane", recursively: false)?.geometry?.materials = [material]
        
        let bgImage = UIImage(named: "woodenlounge")

        scene?.background.contents = bgImage
    }
    
    func tapped(node: SCNNode) {
        let position = node.worldPosition
        let column = chessColumnsToLetter[Int(position.z + pieceCoordOffset + 1)]!
        let row = Int(position.x + pieceCoordOffset + 1)
        print("\(column)\(row)")
    }
    
    func tapped(boardLocation : SCNVector3) {
        
        let column = chessColumnsToLetter[Int(boardLocation.z + boardCoordOffset+1)]!
        
        let row = Int(boardLocation.x + boardCoordOffset + 1)
        
        print("\(column)\(row)")
    }
}
