//
//  ChessScene.swift
//  Chess
//
//  Created by Mark Pizzutillo on 12/25/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import SceneKit
import SwiftChess

class ChessScene {
    
    //Generate Chess Scene
    let scene = SCNScene(named: "ChessScene.scn")
    
    //Offset to obtain column/row from piece coordinate
    let pieceCoordOffset : Float = 3.5
    let boardCoordOffset : Float = 4.0
    
    var pieces = [SceneChessPiece]()
    
    init() {
        let material = SCNMaterial()
        
        //Set chessboard image on plane
        material.diffuse.contents = UIImage(named: "chessboard")
        
        scene?.rootNode.childNode(withName: "plane", recursively: false)?.geometry?.materials = [material]
        
        let bgImage = UIImage(named: "woodenlounge")

        scene?.background.contents = bgImage
        
        initializeWhitePieces(locations: Chess.sharedInstance.game.gameInstance.board.getLocations(of: Color.white))
        initializeBlackPieces(locations: Chess.sharedInstance.game.gameInstance.board.getLocations(of: Color.black))
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
    
    func nodePositionFor(boardLocation : BoardLocation) -> SCNVector3 {
        let x = Float(boardLocation.x) - pieceCoordOffset
        let y = Float(boardLocation.y) - pieceCoordOffset
        
        print("\(x),\(y)")
        
        return SCNVector3(x: x, y: 0.51, z: y)
        
    }
    
    func initializeWhitePieces(locations : [BoardLocation]) {
        for location in locations {
            let piece = Chess.sharedInstance.game.gameInstance.board.getPiece(at: location)
            
            if (piece?.type == Piece.PieceType.pawn) {
                let scenePiece = scene?.rootNode.childNode(withName: "WhitePawn", recursively: false)?.clone()
                scenePiece?.isHidden = false
                scenePiece?.position = nodePositionFor(boardLocation: location)
            }
        }
    }
    
    func initializeBlackPieces(locations : [BoardLocation]) {
        
    }
}

class SceneChessPiece {
    var location : BoardLocation
    var scenePiece : SCNNode
    
    init(loc : BoardLocation, piece: SCNNode) {
        location = loc
        scenePiece = piece
    }
}
