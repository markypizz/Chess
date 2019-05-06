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
import SwiftChess

protocol GameplayDelegate {
    func returnToMenu(presentedGameView: UIViewController)
}

class GameViewController: UIViewController, SCNSceneRendererDelegate, UIPopoverPresentationControllerDelegate, CameraControlDelegate {
    
    var gameplayDelegate : GameplayDelegate!
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var turnIndicatorLabel: UILabel!
    @IBOutlet weak var freeRoamLabel: UILabel!
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var ingameOptionsButton: UIButton!
    
    var recognizer : UITapGestureRecognizer!
    
    var loadingView : UIView?
    var activityIndicatorView : UIActivityIndicatorView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        Chess.sharedInstance.game.gameViewController = self
        
        #if !targetEnvironment(simulator)
            sceneView.antialiasingMode = .multisampling4X
        #endif
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(rec:)))
        
        sceneView.addGestureRecognizer(recognizer)
        
        loadingView = UIView()
        loadingView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(loadingView!)
        self.view.bringSubviewToFront(loadingView!)
        
        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView?.startAnimating()
        loadingView?.addSubview(activityIndicatorView!)
        print(Chess.sharedInstance.game.gameInstance.board.printFenRepresentation())
        
        let headerBG = UIImage(named: "graytriangles")!.cgImage
        
        self.headerView.backgroundColor = UIColor(patternImage:
            UIImage(cgImage: headerBG!, scale: 4, orientation: .up))
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
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
    
    @IBAction func cameraControlsButtonPressed(_ sender: UIButton) {
        // Raise or lower view
        if controlsView.isHidden {
            raiseControls()
        } else {
            lowerControls()
        }
    }
    
    func raiseControls() {
        self.controlsView.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            //Accounts for safe area
            self.controlsView.frame.origin.y = self.view.bounds.height - self.controlsView.bounds.height
        }
    }
    
    func lowerControls() {
        UIView.animate(withDuration: 0.2, animations: {
            self.controlsView.frame.origin.y = self.view.bounds.height
        }) { (completed) in
            self.controlsView.isHidden = true
        }
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ingameOptionsSegue", sender: self)
    }
    
    func gameChangedPlayerTo(color : String) {
        if (color == "white") {
            turnIndicatorLabel.text = "White's Turn"
            turnIndicatorLabel.textColor = UIColor.white
        } else if (color == "black") {
            turnIndicatorLabel.text = "Black's Turn"
            turnIndicatorLabel.textColor = UIColor.black
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ingameOptionsSegue" {
            let popoverViewController = segue.destination as! InGameOptionsTableViewController
            popoverViewController.popoverPresentationController?.backgroundColor = UIColor.white
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController?.sourceRect = ingameOptionsButton.bounds
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.gameViewController = self
        } else if let vc = segue.destination as? CameraControlsViewController {
            vc.cameraControlDelegate = self
            vc.initCameraController(scene: Chess.sharedInstance.scene.scene!)
        }
    }
    
    func choosePawnPromotion(callback: @escaping (Piece.PieceType) -> Void) {
        
    }
    
    func cameraControlWasEnabled() {
        freeRoamLabel.isHidden = false
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = false
    }
    
    func cameraControlWasDisabled() {
        sceneView.defaultCameraController.stopInertia()
        sceneView.allowsCameraControl = false
        freeRoamLabel.isHidden = true
    }
    
    func dismissGame() {
        
        // Dismiss popover
        if presentedViewController is InGameOptionsTableViewController {
            presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
        loadingView = UIView(frame: self.view.bounds)
        
        loadingView?.backgroundColor = UIColor.black
        loadingView?.alpha = 0
        self.view.addSubview(self.loadingView!)
        self.view.bringSubviewToFront(self.loadingView!)
        
        // There needs to be a bit of time before we set the scene to nil
        // in case of pending moves that are still in progress.
        // In a perfect world, we would mutex this, but a full half second
        // should be more than enough time to finish all on-screen scene moves
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView?.alpha = 1
        }) { (completed) in
            self.sceneView.scene = nil
        }
        
        // De init game
        DispatchQueue.global(qos: .background).async {
            Chess.sharedInstance.game.deInitGame()
        }
        
        gameplayDelegate.returnToMenu(presentedGameView: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        gameplayDelegate = nil
    }
}
