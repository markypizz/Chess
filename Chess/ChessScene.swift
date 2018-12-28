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
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "chessboard")
        scene?.rootNode.childNode(withName: "plane", recursively: false)?.geometry?.materials = [material]
    }
    
    func tapped(node: SCNNode) {
        print(node.name!)
    }
}
