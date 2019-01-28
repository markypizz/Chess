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
    var gameInstance: Game
    var whitePlayer : Player
    var blackPlayer : Player
    
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
        
        gameInstance = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        
        //Chess.sharedInstance.scene = ChessScene()
        
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
        
        //AI will make move on its turn
        if let player = game.currentPlayer as? AIPlayer {
            player.makeMoveAsync()
        }
    }
    
    func gameWonByPlayer(game: Game, player: Player) {
        print("gameWonByPlayer \(player)")
    }
    
    func gameEndedInStaleMate(game: Game) {
        print("stalemate")
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
        
        if (piece.canBeTakenByEnPassant && piece.color != Chess.sharedInstance.game.gameInstance.board.getPiece(at: location)?.color) {
            Chess.sharedInstance.scene.removePieceFromBoard(Chess.sharedInstance.scene.pieceAtLocation(location)!)
        }
        
        print("gameremovedPiece")
    }
    
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation) {
        Chess.sharedInstance.scene.moveNode(from: piece.location, to: toLocation)
    }
    
    func gameDidTransformPiece(game: Game, piece: Piece, location: BoardLocation) {
        print("gametransformedPiece")
    }
    
    func gameDidEndUpdates(game: Game) {
        print("gameEndUpdates")
    }
    
    func promotedTypeForPawn(location: BoardLocation, player: Human, possiblePromotions: [Piece.PieceType], callback: @escaping (Piece.PieceType) -> Void) {
        
        //For now always queen
        //return Piece.PieceType.queen
    }
}


