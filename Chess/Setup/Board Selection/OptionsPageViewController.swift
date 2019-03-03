//
//  OptionsPageViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 3/2/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit

class OptionsPageViewController: UIPageViewController {
    var pageIndex : Int = 0
    var viewControllerPages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for identifier in Chess.optionsPages {
            viewControllerPages.append(storyboard!.instantiateViewController(withIdentifier: identifier))
        }
        
        self.setViewControllers([viewControllerPages[0]], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    func incrementPage() {
       pageIndex += 1
        self.setViewControllers([viewControllerPages[pageIndex]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
    func decrementPage() {
        pageIndex -= 1
        self.setViewControllers([viewControllerPages[pageIndex]], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
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
