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
        
        var allPieceLocations = Chess.sharedInstance.game.gameInstance.board.getLocations(of: Color.white)
        allPieceLocations += Chess.sharedInstance.game.gameInstance.board.getLocations(of: Color.black)
        
        initializePieces(locations: allPieceLocations)
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
        
        //Alignment is a bit different
        return SCNVector3(x: y, y: 0.51, z: x)
        
    }
    
    func initializePieces(locations : [BoardLocation]) {
        var baseNode : SCNNode!
        var scenePiece : SCNNode!
        for location in locations {
            let piece = Chess.sharedInstance.game.gameInstance.board.getPiece(at: location)

            //White Pieces
            if (piece?.type == Piece.PieceType.pawn && (piece?.color)! == Color.white) {
                baseNode = (scene?.rootNode.childNode(withName: "WhitePawn", recursively: false))!
            } else if (piece?.type == Piece.PieceType.rook && piece?.color == Color.white) {
                baseNode = (scene?.rootNode.childNode(withName: "WhiteRook", recursively: false))!
            } else if (piece?.type == Piece.PieceType.knight && piece?.color == Color.white) {
                baseNode = (scene?.rootNode.childNode(withName: "WhiteKnight", recursively: false))!
            } else if (piece?.type == Piece.PieceType.bishop && piece?.color == Color.white) {
                baseNode = (scene?.rootNode.childNode(withName: "WhiteBishop", recursively: false))!
            } else if (piece?.type == Piece.PieceType.queen && piece?.color == Color.white) {
                baseNode = (scene?.rootNode.childNode(withName: "WhiteQueen", recursively: false))!
            } else if (piece?.type == Piece.PieceType.king && piece?.color == Color.white) {
                baseNode = (scene?.rootNode.childNode(withName: "WhiteKing", recursively: false))!
                
            //Black Pieces
            } else if (piece?.type == Piece.PieceType.pawn && piece?.color == Color.black) {
                baseNode = (scene?.rootNode.childNode(withName: "BlackPawn", recursively: false))!
            } else if (piece?.type == Piece.PieceType.rook && piece?.color == Color.black) {
                baseNode = (scene?.rootNode.childNode(withName: "BlackRook", recursively: false))!
            } else if (piece?.type == Piece.PieceType.knight && piece?.color == Color.black) {
                baseNode = (scene?.rootNode.childNode(withName: "BlackKnight", recursively: false))!
            } else if (piece?.type == Piece.PieceType.bishop && piece?.color == Color.black) {
                baseNode = (scene?.rootNode.childNode(withName: "BlackBishop", recursively: false))!
            } else if (piece?.type == Piece.PieceType.queen && piece?.color == Color.black) {
                baseNode = (scene?.rootNode.childNode(withName: "BlackQueen", recursively: false))!
            } else if (piece?.type == Piece.PieceType.king && piece?.color == Color.black) {
                baseNode = (scene?.rootNode.childNode(withName: "BlackKing", recursively: false))!
            }
            
            scenePiece = baseNode.clone()
            scenePiece.geometry = baseNode.geometry?.copy() as? SCNGeometry
            scenePiece.isHidden = false
            scenePiece.position = nodePositionFor(boardLocation: location)
            scene?.rootNode.addChildNode(scenePiece)
            pieces.append(SceneChessPiece(loc: location, piece: scenePiece))
        }
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
