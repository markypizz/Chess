//
//  BoardSelectCollectionViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 1/31/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit

// TODO: Can we template this class?
class SideSelectCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "sideCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImage = UIImage(named: "brightstripeBG")!.cgImage
        
        self.collectionView.backgroundColor = UIColor(patternImage:
            UIImage(cgImage: bgImage!, scale: 4, orientation: .up))
    }
    
    override func viewWillLayoutSubviews() {
        if let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            self.collectionView.contentInset.bottom = bottomPadding
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Chess.sideChoices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardOptionsCollectionViewCell
        
        cell.index = indexPath.row
        cell.imageName = Chess.sideChoices[cell.index!]
        cell.imageView.image = UIImage(named: cell.imageName!)
        
        
        if (cell.index == Chess.sharedInstance.sideSelection) {
            cell.selectedView.backgroundColor = UIColor.green
        } else {
            cell.selectedView.backgroundColor = UIColor.black
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scene = Chess.sharedInstance.demoScene
        scene?.changeSideTo(index: indexPath.row)
        
        collectionView.reloadData()
    }
    
}
