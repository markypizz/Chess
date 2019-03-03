//
//  OptionsViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 3/2/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    weak var optionsPageViewController : OptionsPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func updateLabel() {
        UIView.animate(withDuration: 0.25) {
            self.pageLabel.alpha = 0
            self.pageLabel.text = Chess.optionsPagesNames[self.optionsPageViewController.pageIndex]
            self.pageLabel.alpha = 1
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        optionsPageViewController.incrementPage()
        
        //Last page
        if (optionsPageViewController.pageIndex == Chess.optionsPages.count-1) {
            downButton.isEnabled = false
        }
        upButton.isEnabled = true
        
        updateLabel()
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        optionsPageViewController.decrementPage()
        
        //First page
        if (optionsPageViewController.pageIndex == 0) {
            upButton.isEnabled = false
        }
        downButton.isEnabled = true
        
        updateLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        optionsPageViewController = segue.destination as? OptionsPageViewController
    }
}
