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

class SetupViewController: UIViewController, SCNSceneRendererDelegate, UIPopoverPresentationControllerDelegate, BlackDifficultyDelegate, WhiteDifficultyDelegate {
    
    var gameView : GameViewController!
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var whiteSegmentedControl: UISegmentedControl!
    @IBOutlet weak var blackSegmentedControl: UISegmentedControl!
    @IBOutlet weak var demoSceneView: SCNView!
    
    var loadingView : UIView?
    var whiteDiff : Int = 0
    var blackDiff : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginButton.layer.cornerRadius = 8.0
        optionsView.layer.cornerRadius = 8.0
        
        Chess.sharedInstance.demoScene = DemoScene()
        demoSceneView.scene = Chess.sharedInstance.demoScene?.scene
        
        demoSceneView.delegate = self
        
        loadingView = UIView()
        loadingView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.demoSceneView.addSubview(loadingView!)
        
        //AI popover color to match segmented control
        
    }
    
    override func viewDidLayoutSubviews() {
        if (loadingView != nil) {
            loadingView?.frame = demoSceneView.frame
            //print(demoSceneView.frame)
        }
    }
    
    @IBAction func beginButtonPressed(_ sender: Any) {
        gameView = storyboard?.instantiateViewController(withIdentifier: "chessView") as? GameViewController
        
        Chess.sharedInstance = Chess()
        
        Chess.sharedInstance.game = ChessGame(
            white: PlayerType(rawValue: whiteSegmentedControl!.selectedSegmentIndex)!,
            whiteDifficulty: AIConfiguration.Difficulty(rawValue: whiteDiff)!,
            black: PlayerType(rawValue: blackSegmentedControl!.selectedSegmentIndex)!,
            blackDifficulty: AIConfiguration.Difficulty(rawValue: blackDiff)!)
        
        Chess.sharedInstance.scene = ChessScene()
        
        //Looking into a more pleasing animation
        self.modalPresentationStyle = .overFullScreen
        self.present(gameView, animated: true, completion: { () in
            self.gameView.sceneView.scene = Chess.sharedInstance.scene.scene
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
            UIView.animate(withDuration: 3, animations: {
                self.loadingView!.alpha = 0
            }) { (completed) in
                self.loadingView = nil
                Chess.sharedInstance.demoScene = nil
            }
            self.demoSceneView.delegate = nil
        }
    }
    
    @IBAction func selectedWhitePlayer(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "whiteDiffSegue", sender: self)
        }
    }
    
    @IBAction func selectedBlackPlayer(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            self.performSegue(withIdentifier: "blackDiffSegue", sender: self)
        }
    }
    
    func setBlackDifficulty(level: Int) {
        blackDiff = level
    }
    
    func setWhiteDifficulty(level: Int) {
        whiteDiff = level
    }
    
}
