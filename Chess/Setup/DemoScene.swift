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
        let material = SCNMaterial()
        
        //Set chessboard image on plane
        material.diffuse.contents = UIImage(named: "chessboard")
        
        scene?.rootNode.childNode(withName: "plane", recursively: false)?.geometry?.materials = [material]
        
        //No BG Image
    }
}
