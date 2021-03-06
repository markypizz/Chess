//
//  ChessGame.swift
//  Chess
//
//  Created by Mark Pizzutillo on 1/2/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import Foundation
import SwiftChess

class ChessGame : GameDelegate {
    var gameInstance : Game
    var whitePlayer : Player
    var blackPlayer : Player
    
    struct pendingMove {
        var moveStart : BoardLocation?
        var moveEnd : BoardLocation?
    }
    
    var pendingMoves = [pendingMove]()

    var removeLocation : BoardLocation?
    
    // A little weird, is there a better way to do this?
    
    //TODO: yes, a delegate
    var gameViewController : GameViewController!
    
    init(white: PlayerType, whiteDifficulty : AIConfiguration.Difficulty, black: PlayerType, blackDifficulty : AIConfiguration.Difficulty) {
        if (white == .ai) {
            whitePlayer = AIPlayer(color: .white, configuration: AIConfiguration(difficulty: whiteDifficulty))
        } else {
            whitePlayer = Human(color: .white)
        }
        
        if (black == .ai) {
            blackPlayer = AIPlayer(color: .black, configuration: AIConfiguration(difficulty: blackDifficulty))
        } else {
            blackPlayer = Human(color: .black)
        }
        
        // One use at a time
        gameInstance = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        
        gameInstance.delegate = self
    }
    
    func movePiece(start: BoardLocation, end: BoardLocation) throws {
        if let player = Chess.sharedInstance.game.gameInstance.currentPlayer as? Human {
            do {
                try player.movePiece(from: start, to: end)
            } catch {
                throw error
            }
            
        } else {
            throw ChessError.humanMoveRequestedOnNonHumanTurn
        }
    }
    
    func gameDidChangeCurrentPlayer(game: Game) {
        gameViewController.gameChangedPlayerTo(color: game.currentPlayer.color.string)
        //AI will make move on its turn
        
        if let player = game.currentPlayer as? AIPlayer {
            player.makeMoveAsync()
        }
        
        /* ---Uncomment to force kingside castle---
         else {
            if let player = game.currentPlayer as? Human {
                if game.board.canColorCastle(color: game.currentPlayer.color, side: .kingSide) {
                    
                    
                    //print("castling kingside")
                    //player.performCastleMove(side: .kingSide)
                }
                
            }
        } */
    }
    
    func gameWonByPlayer(game: Game, player: Player) {
        trySceneUpdates()
        print("gameWonByPlayer \(player)")
        
        if player is Human {
            // End Game
            Chess.sharedInstance.scene.gameWonByPlayer()
        } else {
            Chess.sharedInstance.scene.gameWonByAI()
        }
    }
    
    func gameEndedInStaleMate(game: Game) {
        trySceneUpdates()
        
        Chess.sharedInstance.scene.gameEndedInStaleMate()
    }
    
    func gameWillBeginUpdates(game: Game) {
        print("gameWillBeginUpdates")
    }
    
    func gameDidAddPiece(game: Game) {
        print("gameAddedPiece")
    }
    
    func gameDidRemovePiece(game: Game, piece: Piece, location: BoardLocation) {
        //This function is called after the piece has been physically replaced on the board, so trying to remove the SCNNode with the provided location does not work. As a result, the code to remove the nodes has been placed in ChessScene.moveNode(...)
        
        //I would go and reverse this in SwiftChess (make removals BEFORE movement), but I don't wish to edit an existing API in the case that someone who uses my code in the future attempts to build the project with the original SwiftChess pod, thus breaking my node removal/movement functionality.
        
        //So, this function only handles a case of en passant capture:
        
        //Hindsight 20/20: it may have been better off to map SCNNodes to Piece objects rather than just locations. May look into this going forward if the change is not substantial.
        
//        if (piece.canBeTakenByEnPassant && piece.color != Chess.sharedInstance.game.gameInstance.board.getPiece(at: location)?.color) {
//
//            if (location != piece.location) {
//                Chess.sharedInstance.scene.removePieceFromBoard(Chess.sharedInstance.scene.pieceAtLocation(location)!)
//            }
//        }
        
        removeLocation = location
        print("gameremovedPiece")
    }
    
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation) {
        
        pendingMoves.append(pendingMove(moveStart: piece.location, moveEnd: toLocation))
        
        //Chess.sharedInstance.scene.moveNode(from: piece.location, to: toLocation)
    }
    
    func gameDidTransformPiece(game: Game, piece: Piece, location: BoardLocation) {
        print("gametransformedPiece")
    }
    
    func gameDidEndUpdates(game: Game) {
        trySceneUpdates()
    }
    
    func promotedTypeForPawn(location: BoardLocation, player: Human, possiblePromotions: [Piece.PieceType], callback: @escaping (Piece.PieceType) -> Void) {
        gameViewController.choosePawnPromotion(callback: callback)
    }
    
    func deInitGame() {
        // Let turn finish if in progress, then block move and deinit game
        
        gameInstance.lock.lock()
        gameInstance.state = .aborted
        
        gameInstance.delegate = nil
        Chess.sharedInstance.game = nil
        
        gameInstance.lock.unlock()
        Chess.sharedInstance.deInitCond.signal()
    }
    
    func trySceneUpdates() {
        do {
            try performSceneUpdates()
        } catch let error{
            print(error)
        }
    }
    
    func performSceneUpdates() throws {
        //Remove a node
        
        if (removeLocation != nil) {
            //Remove the piece
            
            if let endPiece = Chess.sharedInstance.scene.pieceAtLocation(removeLocation!) {
                Chess.sharedInstance.scene.removePieceFromBoard(endPiece)
                removeLocation = nil
            }
            
        }
        
        //Move nodes
        for nextMove in pendingMoves {
            Chess.sharedInstance.scene.moveNode(from: nextMove.moveStart!, to: nextMove.moveEnd!)
        }
        pendingMoves.removeAll()
    }
}


