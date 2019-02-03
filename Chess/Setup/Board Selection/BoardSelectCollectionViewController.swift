//
//  BoardSelectCollectionViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 1/31/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "boardCell"

class BoardSelectCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImage = UIImage(named: "brightstripeBG")!.cgImage
            
            self.collectionView.backgroundColor = UIColor(patternImage:
                UIImage(cgImage: bgImage!, scale: 4, orientation: .up))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Chess.boardChoices.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardCollectionViewCell
        
        cell.boardIndex = indexPath.row
        cell.imageName = Chess.boardChoices[cell.boardIndex!]
        cell.imageView.image = UIImage(named: cell.imageName!)
        
        if (cell.boardIndex == Chess.sharedInstance.boardSelection) {
            cell.selectedView.backgroundColor = UIColor.green
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
        scene?.changeBoardTo(index: indexPath.row)
        //Chess.sharedInstance.demoScene.changeBoardTo(index: indexPath.row)
        
        let cell = collectionView.cellForItem(at: indexPath) as! BoardCollectionViewCell
        
        for currentCell in collectionView.visibleCells as! [BoardCollectionViewCell] {
            currentCell.selectedView.backgroundColor = UIColor.black
        }
        
        cell.selectedView.backgroundColor = UIColor.green
    }

}
