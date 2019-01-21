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
    
    init(white: PlayerType, black: PlayerType) {
        if (white == .ai) {
            whitePlayer = AIPlayer(color: .white, configuration: AIConfiguration(difficulty: .medium))
        } else {
            whitePlayer = Human(color: .white)
        }
        
        if (black == .ai) {
            blackPlayer = AIPlayer(color: .black, configuration: AIConfiguration(difficulty: .medium))
        } else {
            blackPlayer = Human(color: .black)
        }
        
        gameInstance = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        
        //Chess.sharedInstance.scene = ChessScene()
        
        gameInstance.delegate = self
        
        //Call delegate function to start game with white player
        gameDidChangeCurrentPlayer(game: gameInstance)
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
        print("gameremovedPiece")
    }
    
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation) {
        Chess.sharedInstance.scene.movePiece(from: piece.location, to: toLocation)
    }
    
    func gameDidTransformPiece(game: Game, piece: Piece, location: BoardLocation) {
        print("gametransformedPiece")
    }
    
    func gameDidEndUpdates(game: Game) {
        print("gameEndUpdates")
    }
    
    func promotedTypeForPawn(location: BoardLocation, player: Human, possiblePromotions: [Piece.PieceType], callback: @escaping (Piece.PieceType) -> Void) {
        //
    }
}


