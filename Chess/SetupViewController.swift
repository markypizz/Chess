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

enum LoadError : Error {
    case runtimeError(String)
}

class SetupViewController: UIViewController, SCNSceneRendererDelegate {
    
    var gameView : GameViewController!
    
    @IBOutlet weak var optionsView: UIView!
    
    @IBOutlet weak var beginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginButton.layer.cornerRadius = 8.0
        optionsView.layer.cornerRadius = 8.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func beginButtonPressed(_ sender: Any) {

        gameView = storyboard?.instantiateViewController(withIdentifier: "chessView") as? GameViewController
        
        self.present(gameView, animated: true, completion: { () in
            self.gameView.sceneView.scene = self.gameView.chessScene.scene
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
