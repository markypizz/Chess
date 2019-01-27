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

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var cameraLockSwitch: UISwitch!
    var recognizer : UITapGestureRecognizer!
    
    var loadingView : UIView?
    var activityIndicatorView : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        #if !targetEnvironment(simulator)
            sceneView.antialiasingMode = .multisampling4X
        #endif
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(rec:)))
        
        sceneView.addGestureRecognizer(recognizer)
        
        loadingView = UIView()
        loadingView?.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.view.addSubview(loadingView!)
        self.view.bringSubviewToFront(loadingView!)
        
        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView?.startAnimating()
        loadingView?.addSubview(activityIndicatorView!)
    }
    
    override func viewDidLayoutSubviews() {
        if (loadingView != nil) {
            loadingView?.frame = self.view.frame
            activityIndicatorView?.frame = loadingView!.frame
        }
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
                Chess.sharedInstance.scene.tapped(location: (hits.first?.worldCoordinates)!)
            default: //chesspiece
                Chess.sharedInstance.scene.tapped(node: tappedNode!)
            }
        }
    }
    
    func enableFreeRoam() {
        recognizer.isEnabled = false
        //sceneView.allowsCameraControl = true
    }
    
    func disableFreeRoam() {
        recognizer.isEnabled = true
        //sceneView.allowsCameraControl = false
        
        
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
    
    // Upon successful scene render, remove the loading screen and start the game
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            if self.loadingView != nil {
                self.activityIndicatorView?.stopAnimating()
                UIView.animate(withDuration: 1, animations: {
                    self.loadingView?.alpha = 0
                }) { (completed) in
                    self.loadingView = nil
                    self.activityIndicatorView = nil
                    
                    //Start game by forcing update to current player
                    Chess.sharedInstance.game.gameDidChangeCurrentPlayer(game: Chess.sharedInstance.game.gameInstance)
                }
                self.sceneView.delegate = nil
            }
        }
    }
}
