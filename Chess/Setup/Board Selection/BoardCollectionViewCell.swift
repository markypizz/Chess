//
//  BoardCollectionViewCell.swift
//  Chess
//
//  Created by Mark Pizzutillo on 1/31/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectedView: UIView!
    
    var imageName : String?
    var boardIndex : Int?
}
