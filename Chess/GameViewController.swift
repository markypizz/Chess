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

class GameViewController: UIViewController, SCNSceneRendererDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var sceneView: SCNView!
    
    //Outlets for camera control
    @IBOutlet var dPadButtons: [UIButton]!
    @IBOutlet var zoomButtons: [UIButton]!
    
    @IBOutlet weak var turnIndicatorLabel: UILabel!
    @IBOutlet weak var freeRoamLabel: UILabel!
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var cameraYaw : SCNNode!
    var cameraPitch : SCNNode!
    var cameraZoom: SCNNode!
    
    var recognizer : UITapGestureRecognizer!
    
    var loadingView : UIView?
    var activityIndicatorView : UIActivityIndicatorView?
    
    struct CameraParameters {
        var position : SCNVector3 = SCNVector3.init()
        var rotation : SCNVector4 = SCNVector4.init()
        var orientation : SCNQuaternion = SCNQuaternion.init()
        var fieldOfView : CGFloat = CGFloat(0)
    }
    
    fileprivate var cameraSaveParams = CameraParameters()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
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
        print(Chess.sharedInstance.game.gameInstance.board.printFenRepresentation())
        
        //Background for camera controls
        let controlsBG = UIImage(named: "brightstripeBG")!.cgImage
        
        self.controlsView.backgroundColor = UIColor(patternImage:
            UIImage(cgImage: controlsBG!, scale: 4, orientation: .up))
        
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

//        guard !sceneView.allowsCameraControl else {
//            exitFreeRoam()
//            return
//        }
        
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
                self.initializeCameraReferences()
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
    
    func initializeCameraReferences() {
        
        self.cameraYaw = sceneView.scene!.rootNode.childNode(withName: "cameraYaw", recursively: false)
        
        self.cameraPitch = self.cameraYaw.childNode(withName: "cameraPitch", recursively: false)
        
        self.cameraZoom = self.cameraPitch.childNode(withName: "cameraZoom", recursively: false)
    }
    
    @IBAction func yawRightButtonPressed(_ sender: UIButton) {
        performCameraYaw(degrees: 45.0/2)
    }
    
    @IBAction func zoomOutButtonPressed(_ sender: UIButton) {
        performCameraZoom(amount: -2.0)
    }
    
    @IBAction func pitchUpButtonPressed(_ sender: UIButton) {
        performCameraPitch(degrees: 15)
    }
    
    @IBAction func pitchDownButtonPressed(_ sender: UIButton) {
        performCameraPitch(degrees: -15)
    }
    
    @IBAction func zoomInButtonPressed(_ sender: UIButton) {
        performCameraZoom(amount: 2.0)
    }
    
    @IBAction func yawLeftButtonPressed(_ sender: UIButton) {
        performCameraYaw(degrees: -45.0/2)
    }
    
    func performCameraYaw(degrees: Float) {
        let rotation = SCNAction.rotate(
            by: CGFloat(GLKMathDegreesToRadians(degrees)),
            around: SCNVector3(0,1,0),
            duration: TimeInterval(abs(degrees) / 90.0))
        
        rotation.timingMode = .easeInEaseOut
        
        cameraYaw?.runAction(rotation)
    }
    
    func performCameraPitch(degrees: CGFloat) {
        let rotation = SCNAction.rotate(
            by: (-1) * CGFloat(GLKMathDegreesToRadians(Float(degrees))),
            around: SCNVector3(1,0,0),
            duration: TimeInterval(abs(degrees) / 90.0))
        
        rotation.timingMode = .easeInEaseOut
        
        cameraPitch?.runAction(rotation)
    }
    
    func performCameraZoom(amount: CGFloat) {
        let zoom = SCNAction.move(by: SCNVector3(0,0,(-1) * amount), duration: 0.2)
        zoom.timingMode = .easeInEaseOut
        
        cameraZoom?.runAction(zoom)
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
    
    @IBAction func unlockButtonPressed(_ sender: UIButton) {
        sceneView.allowsCameraControl ? exitFreeRoam() : enterFreeRoam()
    }
    
    fileprivate func enterFreeRoam() {
        freeRoamLabel.isHidden = false
        sceneView.allowsCameraControl = true
        
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = false
        
        self.cameraSaveParams.position = cameraZoom.position
        self.cameraSaveParams.rotation = cameraZoom.rotation
        self.cameraSaveParams.orientation = cameraZoom.orientation
        self.cameraSaveParams.fieldOfView = cameraZoom.camera!.fieldOfView
        
        for button in dPadButtons {
            button.isEnabled = false
        }
        
        for button in zoomButtons {
            button.isEnabled = false
        }
    }
    
    fileprivate func exitFreeRoam() {
        sceneView.defaultCameraController.stopInertia()
        sceneView.allowsCameraControl = false
        
        // Recall the parameters (TODO: animate these later ?)
        cameraZoom.position = cameraSaveParams.position
        cameraZoom.rotation = cameraSaveParams.rotation
        cameraZoom.orientation = cameraSaveParams.orientation
        cameraZoom.camera!.fieldOfView = cameraSaveParams.fieldOfView
        
        for button in dPadButtons {
            button.isEnabled = true
        }
        
        for button in zoomButtons {
            button.isEnabled = true
        }
        
        freeRoamLabel.isHidden = true
    }
}
