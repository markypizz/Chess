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
    
    let bgScale : CGFloat = 6.0
    
    //View needed for background parameters
    init(view : UIView) {
        let planeMaterial = SCNMaterial()
        
        //Set chessboard image on plane
        planeMaterial.diffuse.contents = UIImage(named: "woodchessboard")
        
        scene?.rootNode.childNode(withName: "plane", recursively: true)?.geometry?.materials = [planeMaterial]
        
        scene?.background.contents = UIImage(named: "triBG")
        
        let scaleX = Float(bgScale * view.frame.width / view.frame.height)
        let scaleY = Float(bgScale)
        scene?.background.contentsTransform = SCNMatrix4MakeScale(scaleX, scaleY, 0)
        scene?.background.wrapS = .repeat
        scene?.background.wrapT = .repeat
        
        let rotation = SCNAction.rotate(by: 2.5, around: SCNVector3(0.0, 1.0, 0.0), duration: 15)
        
        let repeater = SCNAction.repeatForever(rotation)
        scene?.rootNode.childNode(withName: "board", recursively: false)!.runAction(repeater)
        
        let boardMaterial = SCNMaterial()
        boardMaterial.diffuse.contents = UIImage(named: "woodtile")
        
        let board =
        scene?.rootNode.childNode(withName: "board", recursively: false)!
        
        board!.geometry?.materials = [boardMaterial]
    }
}
