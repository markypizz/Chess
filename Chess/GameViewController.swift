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
    
    let chessScene = ChessScene()
    var recognizer : UITapGestureRecognizer!
    var slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.antialiasingMode = .multisampling4X
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(rec:)))
        
        //sceneView.scene = chessScene
        sceneView.addGestureRecognizer(recognizer)
        sceneView.addSubview(slider)
        slider.maximumValue = 180
        slider.minimumValue = 0
        slider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
    }
    
    override func viewDidLayoutSubviews() {
        slider.center.y = sceneView.center.y
        slider.center.x = sceneView.bounds.maxX - 10
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
            chessScene.tapped(node: tappedNode!)
        }
    }
}
