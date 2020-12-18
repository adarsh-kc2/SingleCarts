//
//  UICollectionViewCell + Common.swift
//  SingleCart
//
//  Created by PromptTech on 12/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class flyerCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var flyerImageLabel: UILabel!
    @IBOutlet weak var flyerDownloadButton: UIButton!
    @IBOutlet weak var flyerShareButton: UIButton!
    override func awakeFromNib() {
        
    }
}


class ShopDetailProductCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    override func awakeFromNib() {
        
    }
}

class productCategoryCollectionViewCell : UICollectionViewCell{
    //productCategoryCollectionViewCell
        @IBOutlet weak var productCategoryLabel: UILabel!
    override func awakeFromNib() {
        
    }
}

class ShopCategoryCollectionViewCell : UICollectionViewCell{
    //productCategoryCollectionViewCell
        @IBOutlet weak var shopCategoryLabel: UILabel!
     @IBOutlet weak var shopCategoryImageView: UIImageView!
    override func awakeFromNib() {
        
    }
}
