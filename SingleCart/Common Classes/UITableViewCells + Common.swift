//
//  UITableViewCells + Common.swift
//  SingleCart
//
//  Created by apple on 18/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import Charts


class OfferTableViewCell : UITableViewCell{
    @IBOutlet weak var offerCellImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productContentLabel: UILabel!
    @IBOutlet weak var productDistanceLabel: UILabel!
    @IBOutlet weak var productPreviousPriceLabel: UILabel!
    @IBOutlet weak var productCurrentPriceLabel: UILabel!
    @IBOutlet weak var offerValidityLabel: UILabel!
    
     @IBOutlet weak var productPercentage: UIButton!
    override func awakeFromNib() {
        if let _ = offerCellImageView{
             offerCellImageView.setCornerRadius(radius: 12.0)
         }
    }
}

class shopsTableViewCell : UITableViewCell{
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    @IBOutlet weak var shopDistancePriceLabel: UILabel!
    @IBOutlet weak var shopStatusLabel: UILabel!
    @IBOutlet weak var shopFavouriteImageView: UIButton!
    override func awakeFromNib() {
        if let _ = offerImageView{
            offerImageView.setCornerRadius(radius: 12.0)
        }
    }
}

class profileTableViewCell : UITableViewCell{
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        if let _ = profileImageView{
            profileImageView.setCornerRadiusWithBorder(radius: profileImageView.frame.height / 2,borderWidth:0.5,borderColor:UIColor.black)
        }
        if let _ = profileButton{
            profileButton.setCornerRadiusWithoutBackground(radius: 6.0)
        }
    }
}


class aboutTableViewCell : UITableViewCell{
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var policyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    override func awakeFromNib(){
        
        if let _ = versionView{
            versionView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.6, shadowColor: UIColor.lightGray, shadowOffset: .zero)//)
        }
        if let _ = policyView{
            policyView.setCornerRadius(radius: 6.0, isShadow: true, isBorderColor: true, borderColor: UIColor.lightGray, isBGColor: false, B_GColor: nil, isBorderWidth: true, borderWidth: 0.2, shadowOpacity: 0.8, shadowColor: UIColor.lightGray, shadowOffset: .zero)
        }
    }
}

class accountTableViewCell : UITableViewCell{
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var myAddressButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var signOutButton: UIButton!
    
    override class func awakeFromNib() {
    }
}


class addressTableViewCell : UITableViewCell{
    @IBOutlet weak var addAddressButton: UIButton!
    
    @IBOutlet weak var DefaultButton: UIButton!
    
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var workWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var defaultWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeWidthConstraint: NSLayoutConstraint!
    
    override class func awakeFromNib() {
    }
}

class addAddressTableViewCell : UITableViewCell{
    
    @IBOutlet weak var locateOnMapButton: UIButton!
   
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var firstNametextfield: UITextField!
    @IBOutlet weak var lastNametextfield: UITextField!
    @IBOutlet weak var address1Textfield: UITextField!
    @IBOutlet weak var address2Textfield: UITextField!
    @IBOutlet weak var landmarktextfield: UITextField!
    @IBOutlet weak var areatextfield: UITextField!
    @IBOutlet weak var citytextfield: UITextField!
    @IBOutlet weak var provinceNametextfield: UITextField!
    @IBOutlet weak var countrytextfield: UITextField!
    @IBOutlet weak var remarktextfield: UITextField!
    
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var addressView: UIView!
    
    var buttonDelegate : AddAddressDelegate?
    override class func awakeFromNib() {
        
    }
    
    @IBAction func buttonOfficeTapped(_ sender: UIButton ) {
        buttonDelegate?.setRadioButtonSelected(selected: sender.tag == 0  ? homeButton :workButton, unseleted: sender.tag == 0  ? workButton : homeButton)
    }

}

class FlyerTableViewCell: UITableViewCell{
    
    @IBOutlet weak var flyerNamelabel: UILabel!
    @IBOutlet weak var flyerShopLabel: UILabel!
    @IBOutlet weak var flyerOfferlabel: UILabel!
    @IBOutlet weak var flyerView: UIView!
    @IBOutlet weak var flyerImageCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override class func awakeFromNib() {
        
    }
}


class ShopDetailTableViewCell: UITableViewCell{
    
    //    cell 1
    @IBOutlet weak var shopDetailView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopCategoryLabel: UILabel!
    @IBOutlet weak var shopDistanceLabel: UILabel!
    @IBOutlet weak var shopOpenStatusLabel: UILabel!
    @IBOutlet weak var shopCloseLabel: UILabel!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopFavouriteImageView: UIButton!
    
    //    cell 2
    @IBOutlet weak var shopAddressView: UIView!
    @IBOutlet weak var shopAddressLabel: UILabel!
    
    //cell 3
    @IBOutlet weak var shopAdditionalView: UIView!
    @IBOutlet weak var shopAdditionalDetailLabel: UILabel!
    @IBOutlet weak var shopAdditionLabel: UILabel!
    
//    cell4
    @IBOutlet weak var userFavourite: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var ratingStatusLabel: UILabel!
    @IBOutlet weak var ratingReviewCountLabel: UILabel!
    @IBOutlet weak var priceView: CircularProgressView!
    @IBOutlet weak var qualityView: CircularProgressView!
    @IBOutlet weak var deliveryView: CircularProgressView!
    @IBOutlet weak var serviceView: CircularProgressView!
    @IBOutlet weak var chartView: HorizontalBarChartView!
    
    //cell 5
    @IBOutlet weak var flyerOfferlabel: UILabel!
    @IBOutlet weak var flyerView: UIView!
    @IBOutlet weak var flyerImageCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //cell 6
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productFlowLayout: UICollectionViewFlowLayout!
    
    override class func awakeFromNib() {
    }
}

class productDetailTableViewCell : UITableViewCell{
    //cell 1
    @IBOutlet weak var poductpageControl: UIPageControl!
    @IBOutlet weak var productImagEVIEW: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPricelabel: UILabel!
    
    //cell 2
    @IBOutlet weak var shareButton: LoadingButton!
    @IBOutlet weak var wishListButton: LoadingButton!
    
    //cell 3
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopDistanceLabel: UILabel!
    @IBOutlet weak var shopDetailsLabel: UILabel!
    @IBOutlet weak var shopImageLabel: UIImageView!
    
//    cell 4
    @IBOutlet weak var productCategoryCollectionView: UICollectionView!
    
    //cell 5
    @IBOutlet weak var productDetailsLabel: UILabel!
       @IBOutlet weak var productFlowLayout: UICollectionViewFlowLayout!
    
    
    override class func awakeFromNib() {
        
    }
}


class wishListTableViewCell : UITableViewCell{
    @IBOutlet weak var wishListView: UIView!
    @IBOutlet weak var wishListNameLabel: UILabel!
    @IBOutlet weak var wishListCategoryLabel: UILabel!
    @IBOutlet weak var wishListPlaceLabel: UILabel!
    @IBOutlet weak var wishListDistanceLabel: UILabel!
    @IBOutlet weak var wishListPriceLabel: UILabel!
    @IBOutlet weak var wishListOfferPriceLabel: UILabel!
    @IBOutlet weak var wishListOfferValidityLabel: UILabel!
    
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
     @IBOutlet weak var wishListImageView: UIImageView!
    var indexPathValue :IndexPath!
    override class func awakeFromNib() {
    }
}



class cartTableViewCell : UITableViewCell{
    //cell 0
    @IBOutlet weak var cartAddressLabel : UILabel!
    @IBOutlet weak var cartAddressButton : UIButton!
    @IBOutlet weak var cartaddressView : UIView!
    
    //cell1
    @IBOutlet weak var cartListView: UIView!
    
    @IBOutlet weak var cartListImageView: UIImageView!
    @IBOutlet weak var cartListNameLabel: UILabel!
    @IBOutlet weak var cartListCategoryLabel: UILabel!
    @IBOutlet weak var cartListActualPriceLabel: UILabel!
    @IBOutlet weak var cartListOfferpercentageLabel: UILabel!
    @IBOutlet weak var cartListOfferPriceLabel: UILabel!
    @IBOutlet weak var cartListQuantityLabel: UILabel!
    @IBOutlet weak var cartListStepper: UIStepper!
    
    @IBOutlet weak var cartListTickOnelabel: UILabel!
    @IBOutlet weak var cartListTickOneButton: UIButton!
    
    @IBOutlet weak var cartListTickTwolabel: UILabel!
    @IBOutlet weak var cartListTickTwoButton: UIButton!
    
    @IBOutlet weak var cartListFinalPricelabel: UILabel!
    
    @IBOutlet weak var cartCheckOutButton: UIButton!
    
    var tempValue : [Double] = []
    var indexPathValue :IndexPath!
    
    var cartDelegate : CartViewControllerDelegate!
    
    override class func awakeFromNib() {
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender.value != 0{
            if let _ = self.cartListFinalPricelabel{
                self.cartListFinalPricelabel.text = " AED \(tempValue[sender.tag] + ((self.cartListOfferPriceLabel.text) as! NSString).doubleValue )"
            }
           self.cartListQuantityLabel.text = "Quantity : \(Int(sender.value))"
            cartDelegate.setQuantity(_quantity: Int(sender.value), _indexPath: indexPathValue)
            //cartDelegate.getData(_price: "\(tempValue[sender.tag] + ((self.cartListOfferPriceLabel.text)! as NSString).doubleValue )", _indexPath: self.indexPathValue)
        }
     }
    
     @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.tag == 0{
            if sender.currentImage != UIImage(named: "round_select.png"){
            sender.setImage(UIImage(named: "round_select.png"), for: .normal)
                self.cartListTickTwoButton.setImage(UIImage(named: "round_unselect.png"), for: .normal)
            }
        }else{
            if sender.currentImage != UIImage(named: "round_select.png"){
            sender.setImage(UIImage(named: "round_select.png"), for: .normal)
                self.cartListTickOneButton.setImage(UIImage(named: "round_unselect.png"), for: .normal)
            }
        }
     }
}

class addressDetailTableViewCell : UITableViewCell{
    @IBOutlet weak var addAddressButton: UIButton!
    
    @IBOutlet weak var DefaultButton: UIButton!
    
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var workWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var defaultWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeWidthConstraint: NSLayoutConstraint!
    
    override class func awakeFromNib() {
    }
}

class MyOrderTableViewCell : UITableViewCell{
    @IBOutlet weak var orderTrackButton: UIButton!
    @IBOutlet weak var orderPriceButton: UIButton!
    @IBOutlet weak var orderShopNameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderItemsLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var orderView: UIView!
    override class func awakeFromNib() {
        
    }
}

class CheckOutTableViewCell : UITableViewCell{
    //cell0
    @IBOutlet weak var serviceProviderView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopTypeLabel: UILabel!
    @IBOutlet weak var shopStatusLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    
    //cell1
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var datetextField: UITextField!
    @IBOutlet weak var shopVisitProviderView: UIView!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var sceduleButton: UIButton!
    //cell2
    @IBOutlet weak var numberLabel: UILabel!
     @IBOutlet weak var helpView: UIView!
    //cell3
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var itemsNumberLabel: UILabel!
    @IBOutlet weak var grossAmountLabel: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var payableAmountLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    override class func awakeFromNib() {
        
    }
}

class OrderDetailTableViewCell : UITableViewCell{
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderAddressNameLabel: UILabel!
    @IBOutlet weak var orderAddressLabel: UILabel!
    @IBOutlet weak var orderAddressView: UIView!
    
    //cell 1
    @IBOutlet weak var orderCompanyNameLabel: UILabel!
    @IBOutlet weak var orderCompanyCategoryLabel: UILabel!
    @IBOutlet weak var orderCompanyStatusLabel: UILabel!
    @IBOutlet weak var orderCompanyNumberLabel: UILabel!
    @IBOutlet weak var orderCompanyView: UIView!
    @IBOutlet weak var orderCompanyNumberCallButton: UIButton!
    
    // cell2
    //My comments :
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var deliveryCommentLabel: UILabel!
    @IBOutlet weak var deliveryView: UIView!
    
    // cell3
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var itemsNumberLabel: UILabel!
    @IBOutlet weak var grossAmountLabel: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var payableAmountLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    //cell4
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productOriginalLabel: UILabel!
    @IBOutlet weak var productOfferLabel: UILabel!
    @IBOutlet weak var productOfferPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
//    cell 5
    @IBOutlet weak var orderStatusImageView: UIImageView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderStatusBottomView: DottedVertical!
    @IBOutlet weak var orderStatusTopView: DottedVertical!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        
    }
}
//trackTableViewCell


class TrackTableViewCell : UITableViewCell {
    
    @IBOutlet weak var orderStatusImageView: UIImageView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderStatusBottomView: DottedVertical!
    @IBOutlet weak var orderStatusTopView: DottedVertical!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        
    }
}


class FeedTableViewCell : UITableViewCell{
    @IBOutlet weak var feedTypeCollectionView : UICollectionView!
        @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    
    
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var productTableView: UITableView!
    
    override class func awakeFromNib() {
        
    }
}


class FeedProductTableViewCell : UITableViewCell{
    @IBOutlet weak var productView: UIView!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var offerNotesLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var shopDistancLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var newPriceWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var offerHeightConstraint: NSLayoutConstraint!
    override class func awakeFromNib() {
        
    }
}



class productTableViewCell : UITableViewCell{
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productContentLabel: UILabel!
    @IBOutlet weak var productDistanceLabel: UILabel!
    @IBOutlet weak var productPreviousPriceLabel: UILabel!
    @IBOutlet weak var productCurrentPriceLabel: UILabel!
    @IBOutlet weak var productOfferValidityLabel: UILabel!
    
     @IBOutlet weak var productPercentage: UIButton!
    override func awakeFromNib() {
        if let _ = productImageView{
             productImageView.setCornerRadius(radius: 12.0)
         }
    }
}
