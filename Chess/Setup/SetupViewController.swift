//
//  SetupViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 12/28/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftChess

enum LoadError : Error {
    case runtimeError(String)
}

class SetupViewController: UIViewController, SCNSceneRendererDelegate, UIPopoverPresentationControllerDelegate, BlackDifficultyDelegate, WhiteDifficultyDelegate, GameplayDelegate {
    
    func returnToMenu(presentedGameView: UIViewController) {
        // Return to menu
        presentedGameView.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var playerConfigView: UIView!
    @IBOutlet weak var whiteSegmentedControl: UISegmentedControl!
    @IBOutlet weak var blackSegmentedControl: UISegmentedControl!
    @IBOutlet weak var demoSceneView: SCNView!
    @IBOutlet weak var optionsView: UIView!
    
    var loadingView : UIView?
    var whiteDiff : Int = 0
    var blackDiff : Int = 0
    
    var tapRecognizer : UITapGestureRecognizer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerConfigView.layer.cornerRadius = 8.0
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchedScreen(sender:)))
        demoSceneView.addGestureRecognizer(tapRecognizer)
        
        #if !targetEnvironment(simulator)
            demoSceneView.antialiasingMode = .multisampling4X
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Remove a previous loading view
        if loadingView != nil {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
        
        loadingView = UIView()
        loadingView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.demoSceneView.addSubview(loadingView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Chess.sharedInstance.demoScene = DemoScene(view: self.view)
        demoSceneView.showsStatistics = true
        demoSceneView.scene = Chess.sharedInstance.demoScene?.scene
        
        demoSceneView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        demoSceneView.scene = nil
        demoSceneView.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        if (loadingView != nil) {
            loadingView?.frame = demoSceneView.frame
        }
        
        if optionsView.isHidden {
           
            //Keep offscreen
            optionsView.frame.origin.y = self.view.bounds.height
        } else {
            optionsView.frame.origin.y = self.view.bounds.height - optionsView.bounds.height
        }
    }
    
    @IBAction func beginButtonPressed(_ sender: Any) {
        let gameView = storyboard?.instantiateViewController(withIdentifier: "chessView") as! GameViewController
        gameView.gameplayDelegate = self
        
        Chess.sharedInstance = Chess()
        Chess.sharedInstance.game = ChessGame(
            white: PlayerType(rawValue: whiteSegmentedControl!.selectedSegmentIndex)!,
            whiteDifficulty: AIConfiguration.Difficulty(rawValue: whiteDiff)!,
            black: PlayerType(rawValue: blackSegmentedControl!.selectedSegmentIndex)!,
            blackDifficulty: AIConfiguration.Difficulty(rawValue: blackDiff)!)
        
        Chess.sharedInstance.scene = ChessScene()
        Chess.sharedInstance.demoScene = nil
        
        gameView.modalTransitionStyle = .flipHorizontal
        
        //gameView.scene = Chess.sharedInstance.scene.scene!
        
        self.present(gameView, animated: true, completion: {
            gameView.sceneView.scene = Chess.sharedInstance.scene.scene
        })
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "whiteDiffSegue" || segue.identifier == "blackDiffSegue") {
            
            let popoverViewController = segue.destination as! PopoverDifficultyViewController
            popoverViewController.popoverPresentationController?.backgroundColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController?.sourceRect = whiteSegmentedControl.bounds
            popoverViewController.popoverPresentationController!.delegate = self
            
            if (segue.identifier == "whiteDiffSegue") {
                popoverViewController.whiteDelegate = self
            } else {
                popoverViewController.blackDelegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if self.loadingView != nil {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 3, animations: {
                    self.loadingView!.alpha = 0
                }) { (completed) in
                    self.loadingView = nil
                }
                self.demoSceneView.delegate = nil
            }
        }
    }
    
    @IBAction func selectedWhitePlayer(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            whiteDiff = 0
            self.performSegue(withIdentifier: "whiteDiffSegue", sender: self)
        }
    }
    
    @IBAction func selectedBlackPlayer(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            blackDiff = 0
            self.performSegue(withIdentifier: "blackDiffSegue", sender: self)
        }
    }
    
    fileprivate func dismissDifficultyPopover() {
        //Ensure presented VC is popover
        if let popover = self.presentedViewController as? PopoverDifficultyViewController {
            popover.dismiss(animated: true, completion: nil)
        }
    }
    
    func setBlackDifficulty(level: Int) {
        blackDiff = level
        dismissDifficultyPopover()
    }
    
    func setWhiteDifficulty(level: Int) {
        whiteDiff = level
        dismissDifficultyPopover()
        
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        openBoardSelectionWindow()
    }
    
    //Not super efficient, acting on every touch.
    @objc func touchedScreen(sender: UITapGestureRecognizer) {
        if !optionsView.isHidden {
            closeBoardSelectionWindow()
        }
    }
    
    fileprivate func openBoardSelectionWindow() {
        optionsView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.optionsView.frame.origin.y = self.view.bounds.height - self.optionsView.bounds.height
        }
    }
    
    fileprivate func closeBoardSelectionWindow() {
        UIView.animate(withDuration: 0.25, animations: {
            self.optionsView.frame.origin.y = self.view.bounds.height
        }) { (completed) in
            self.optionsView.isHidden = true
        }
    }
}
