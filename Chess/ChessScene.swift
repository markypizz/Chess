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
    
    var rendered = false
    
    //Adjustable
    let nodeMovement : nodeMovementType = nodeMovementType.constantDuration
    let pieceMoveSpeed : Float = 3
    let nodeMoveDuration : TimeInterval = TimeInterval(0.25)
    
    var pieces = [SceneChessPiece]()
    var highlightedPiece : SCNNode? = nil
    
    var firstTappedLocation : BoardLocation? {
        didSet {
            //Highlight board piece on location, clear last highlight
            
            guard firstTappedLocation != nil else {
                //clear glow
                //
                //
                return
            }
            
            if let piece = pieceAtLocation(firstTappedLocation!) {
                //Piece found
                
                //Highlight piece
                highlight(node: piece)
                highlightedPiece = piece
            }
        }
    }
    
    var secondTappedLocation : BoardLocation? {
        didSet {
            if secondTappedLocation != nil {
                
                //If tapped same position twice, negate the second tap
                guard secondTappedLocation != firstTappedLocation else {
                    secondTappedLocation = nil
                    return
                }
                
                //Second square is not occupied by the same player's piece. Otherwise treat as new selection
                guard !Chess.sharedInstance.game.gameInstance.currentPlayer!.occupiesSquare(at: secondTappedLocation!) else {
                    firstTappedLocation = secondTappedLocation
                    secondTappedLocation = nil
                    return
                }
                
                do {
                    try Chess.sharedInstance.game.movePiece(start: firstTappedLocation!, end: secondTappedLocation!)
                } catch {
                    print(error)
                }
                
                //Deselect after move attempt (or user attempted to clear selection)
                firstTappedLocation = nil
                secondTappedLocation = nil
            }
        }
    }
    
    init() {
        let planeMaterial = SCNMaterial()
        
        //Set chessboard image on plane
        planeMaterial.diffuse.contents = UIImage(named: "chessboard")
        
        scene?.rootNode.childNode(withName: "plane", recursively: false)?.geometry?.materials = [planeMaterial]
        
        //Not working!--------------------------
        let boardMaterial = SCNMaterial()
        boardMaterial.diffuse.contents = UIImage(named: "woodtile")
        scene?.rootNode.childNode(withName: "board", recursively: false)?.geometry?.materials = [boardMaterial]
        //--------------------------------------
        
        var allPieceLocations = Chess.sharedInstance.game.gameInstance.board.getLocations(of: Color.white)
        allPieceLocations += Chess.sharedInstance.game.gameInstance.board.getLocations(of: Color.black)
        
        initializePieces(locations: allPieceLocations)
        
        #if !targetEnvironment(simulator)
            let bgImage = UIImage(named: "woodenlounge")
            scene?.background.contents = bgImage
        #endif
        
    }
    
    func tapped(node: SCNNode) {
        let position = node.worldPosition
        
        tapped(location: position)
    }
    
    func tapped(location : SCNVector3) {
        
        
        if (Chess.sharedInstance.game.gameInstance.currentPlayer is Human) {
            if (firstTappedLocation == nil) {
                if (Chess.sharedInstance.game.gameInstance.currentPlayer!.occupiesSquare(at: boardLocationFor(nodePosition: location))) {
                    firstTappedLocation = boardLocationFor(nodePosition: location)
                    
                    //Otherwise, will disregard first tap
                }
            } else {
                secondTappedLocation = boardLocationFor(nodePosition: location)
            }
        }
    }
    
    //Why does this work?
    func nodePositionFor(boardLocation : BoardLocation) -> SCNVector3 {
        let x = Float(boardLocation.x) - pieceCoordOffset
        let y = Float(boardLocation.y) - pieceCoordOffset
        
        //Alignment is a bit different
        return SCNVector3(x: y, y: 0.51, z: x)
        
    }
    
    //When this one does with +1?
    func boardLocationFor(nodePosition : SCNVector3) -> BoardLocation {
        
        let column = Int(nodePosition.z + boardCoordOffset)
        let row = Int(nodePosition.x + boardCoordOffset)
        print("\(column)\(row)")
        
        let location = BoardLocation(x: column, y: row)
        
        return location
    }
    
    func pieceAtLocation(_ location : BoardLocation) -> SCNNode? {
        for piece in pieces {
            if piece.location == location {
                return piece.scenePiece
            }
        }
        return nil
    }
    
    func removePieceFromBoard(_ piece : SCNNode) {
        for i in 0..<pieces.count {
            if pieces[i].scenePiece == piece {
                //Fade piece out
                let fade = SCNAction.fadeOut(duration: 0.5)
                
                piece.runAction(fade) {
                    piece.removeFromParentNode()
                }
                
                pieces.remove(at: i)
                return
            }
        }
    }
    
    func updateLocationFor(piece : SCNNode, location: BoardLocation) {
        for i in 0..<pieces.count {
            if pieces[i].scenePiece == piece {
                pieces[i].location = location
                return
            }
        }
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
    
    // TODO: Finish
    func highlight(node: SCNNode) {
        //let technique = SCNTechnique.init(bySequencingTechniques: )
    }
    
    func unhighlight(node : SCNNode) {
        
    }
    
    func moveNode(from: BoardLocation, to: BoardLocation) {
        let startPiece = pieceAtLocation(from)
        
        
        let startCoords = nodePositionFor(boardLocation: from)
        let finalCoords = nodePositionFor(boardLocation: to)
        
        var duration : TimeInterval
        
        if (nodeMovement == .constantSpeed) {
            duration = durationForMoveBetween(start: startCoords, end: finalCoords)
        } else /* .constantDuration */ {
            duration = nodeMoveDuration
        }
        
        let move = SCNAction.move(to: finalCoords, duration: duration)
        
        startPiece?.runAction(move)
        
        
        
        updateLocationFor(piece: startPiece!, location: to)
    }
    
    func durationForMoveBetween(start: SCNVector3, end: SCNVector3) -> TimeInterval {
        let distance = SCNVector3(end.x - start.x, end.y - start.y, end.z - start.z)
        
        //Trigonometry!
        let length = sqrtf(powf(distance.x, 2.0) + powf(distance.y, 2.0) + powf(distance.z, 2.0))
        
        return TimeInterval(length / pieceMoveSpeed)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if !rendered {
            print("rendered")
            rendered = true
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

//Pieces will either move with constant speed or with constant move duration
enum nodeMovementType {
    case constantSpeed
    case constantDuration
}
