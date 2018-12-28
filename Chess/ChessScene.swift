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
    let scene = SCNScene(named: "ChessScene.scn")
    
    init() {
    }
    
    
    func tapped(node: SCNNode) {
        print(node.name!)
    }
}
