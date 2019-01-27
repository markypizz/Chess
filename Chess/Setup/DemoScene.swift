//
//  DemoScene.swift
//  Chess
//
//  Created by Mark Pizzutillo on 12/25/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import SceneKit

class DemoScene {
    
    //Generate Chess Scene
    let scene = SCNScene(named: "DemoScene.scn")
    
    init() {
        let planeMaterial = SCNMaterial()
        
        //Set chessboard image on plane
        planeMaterial.diffuse.contents = UIImage(named: "chessboard")
        
        scene?.rootNode.childNode(withName: "plane", recursively: true)?.geometry?.materials = [planeMaterial]
        
        let rotation = SCNAction.rotate(by: 2.5, around: SCNVector3(0.0, 1.0, 0.0), duration: 15)
        
        let repeater = SCNAction.repeatForever(rotation)
        scene?.rootNode.childNode(withName: "board", recursively: false)!.runAction(repeater)
        
        //Not Working!--------------------------
        let boardMaterial = SCNMaterial()
        boardMaterial.diffuse.contents = UIImage(named: "woodtexture")
        let board = scene?.rootNode.childNode(withName: "board", recursively: false)!
        
        board!.geometry?.materials = [boardMaterial]
        //--------------------------------------
    }
}
