//
//  PopoverDifficultyViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 1/26/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit

protocol WhiteDifficultyDelegate {
    func setWhiteDifficulty(level: Int)
}

protocol BlackDifficultyDelegate {
    func setBlackDifficulty(level: Int)
}

class PopoverDifficultyViewController: UIViewController {
    var whiteDelegate : WhiteDifficultyDelegate?
    var blackDelegate : BlackDifficultyDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        
        if (whiteDelegate != nil) {
            whiteDelegate?.setWhiteDifficulty(level: sender.selectedSegmentIndex)
        } else if (blackDelegate != nil) {
            blackDelegate?.setBlackDifficulty(level: sender.selectedSegmentIndex)
        } else {
            print("No delegate set")
        }
        
        //A cardinal sin, dismissing a view controller from itself. However, I haven't been able to figure out how to dismiss it from SetupViewController using the delegate protocols. Something unique about UIPopoverViewControllers that I have not figured out
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
