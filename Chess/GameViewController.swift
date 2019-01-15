//
//  GameViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 12/24/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var cameraLockSwitch: UISwitch!
    
    let chessScene = ChessScene()
    var recognizer : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.antialiasingMode = .multisampling4X
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(rec:)))
        
        //sceneView.scene = chessScene
        sceneView.addGestureRecognizer(recognizer)
        
        //disableFreeRoam()
        
        sceneView.allowsCameraControl = false
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func tapped(rec: UITapGestureRecognizer) {
        let location : CGPoint = rec.location(in: sceneView)
        let hits = self.sceneView.hitTest(location, options: nil)
        if !hits.isEmpty{
            let tappedNode = hits.first?.node
            
            switch (tappedNode?.name) {
            case "board":
                break
            case "plane":
                chessScene.tapped(boardLocation: (hits.first?.worldCoordinates)!)
            default: //chesspiece
                chessScene.tapped(node: tappedNode!)
            }
        }
    }
    
    func enableFreeRoam() {
        recognizer.isEnabled = false
        //sceneView.allowsCameraControl = true
    }
    
    func disableFreeRoam() {
        recognizer.isEnabled = true
        sceneView.allowsCameraControl = false
        
        
        //sceneView.allowsCameraControl = false
        //sceneView.pointOfView = chessScene.scene?.rootNode.childNode(withName: "camera", recursively: false)
        
        
        //sceneView.defaultCameraController.pointOfView = chessScene.scene?.rootNode.childNode(withName: "camera", recursively: false)
        
        //chessScene.scene?.rootNode.camera.
    }
    
    @IBAction func cameraLockSwitched(_ sender: UISwitch) {
        
        if (sender.isOn) {
            disableFreeRoam()
        } else {
            enableFreeRoam()
        }
    }
    
}
