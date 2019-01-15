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
    
    var game: Game
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
        
        game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        
        game.delegate = self
    }
    
    func movePiece(from: String, to: String) {
        
    }
    
    func gameDidChangeCurrentPlayer(game: Game) {
        
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
        print("gameMovedPiece")
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
