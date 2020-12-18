//
//  Constants.swift
//  SingleCart
//
//  Created by apple on 06/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

let REQUESTKEY : String = "d597ae36-8286-49fb-9461-229e019254e5"//"56a4c600-1c78-4be5-8129-7c23cb270883"//For every request send this
//let REQUESTKEY : String = "4a4a2f8e-e74b-43db-963d-6605ffe7a124"
//4a4a2f8e-e74b-43db-963d-6605ffe7a124

//URL CONSTANTS

let TERMS : String = "https://www.singlecartretail.com/privacy_policy/singlecart_terms_and_conditions.html"
let PRIVACY : String = "https://www.singlecartretail.com/privacy_policy/singlecart_privacy_policy.html"
let STORE_LINK : String = "https://play.google.com/store/apps/details?id=com.prompttech.singlecartmerchant&hl=en"


//MARK:- VIEWCONTROLLERS NAME - StoryBoard identifier
let STARTUPPAGEVIEWCONTROLLER : String = "StartUpViewController"
let FIRSTVIEWCONTROLLER : String = "FirstPageViewController"
let SECONDVIEWCONTROLLER : String = "SecondPageViewController"
let THIRDVIEWCONTROLLER : String = "ThirdViewController"
let LOGINVIEWCONTROLLER : String      = "ViewController"
let SIGNUPVIEWCONTROLLER : String     = "SignUpViewController"
let FORGOTPASSWORDVIEWCONTROLLER : String   = "ForgotViewController"
let SIGNUPOTPVIEWCONTROLLER : String = "SignUPOTPViewController"
let FORGOT_CHANGE_VIEWCONTROLLER : String = "ForgotPasswordChangeViewController"
let LOCATIONVIEWCONTROLLER : String = "LocationViewController"
let MAINTAB : String = "MainTabbarController"
let PRODUCT_DETAIL : String = "ProductDetailViewController"
let MY_WISHLIST : String = "MyWishListViewController"
let MY_CART : String = "MyCartViewController"
let ADDRESS_DETAIL : String = "AddressDetailsViewController"
let ORDERLIST : String = "MyOrdersViewController"
let ORDER_DETAIL_VIEWCONTROLLER : String = "OrderDetailsViewController"
let TRACKVIEWCONTROLLER : String = "TrackViewController"
let CART_CHECKOUT : String = "CartCheckOutViewController"
let FEEDBACK : String = "FeedBackViewController"
let FULLVIEW : String = "FullViewController"
let REVIEW_VIEWCONTROLLER = "ReviewViewController"
let FEEDPAGEVIEWCONTROLLER : String = "FeedPageViewController"
let PRODUCTSVIEWCONTROLLER : String = "ProductsViewController"
let OFFERPAGEVIEWCONTROLLER : String = "OffersViewController"
let SHOPPAGEVIEWCONTROLLER : String = "ShopsViewController"
let SHOPDETAILPAGEVIEWCONTROLLER : String = "ShopDetailsViewController"
let PROFILEVIEWCONTROLLER : String = "ProfileViewController"
let ABOUTVIEWCONTROLLER : String = "AboutViewController"
let URLPAGEVIEWCONTROLLER : String = "URLViewController"
let ACCOUNTVIEWCOTROLLER : String = "AccountViewController"
let ADDRESSVIEWCONTROLLER : String = "AddressViewController"
let CHANGEPASSWORDVIEWCONTROLLER : String = "ChangePasswordViewController"
let ADD_ADDRESSVIEWCONTROLLER : String = "AddAddressViewController"
let MAPVIEWCONTROLLER : String = "MapViewController"
let FLYERPAGEVIEWCONTROLLER : String = "FlyerPageViewController"
let NOINTERNET : String = "NoInternetViewController"
let PERMISSIONPAGE : String = "PermissionViewController"
let SORTINGPAGE : String = "SortViewController"
let FILTERPAGE : String = "FilterViewController"
//MARK:- StoryBoard

let StoryboardValue = UIStoryboard.init(name: "Main", bundle: nil)

let StarUpPage = StoryboardValue.instantiateViewController(withIdentifier: STARTUPPAGEVIEWCONTROLLER) as! StartUpViewController
let Page1 = StoryboardValue.instantiateViewController(withIdentifier: FIRSTVIEWCONTROLLER) as! FirstPageViewController
let Page2 = StoryboardValue.instantiateViewController(withIdentifier: SECONDVIEWCONTROLLER) as! SecondPageViewController
let Page3 = StoryboardValue.instantiateViewController(withIdentifier: THIRDVIEWCONTROLLER) as! ThirdViewController
let Login =   StoryboardValue.instantiateViewController(withIdentifier: LOGINVIEWCONTROLLER) as! ViewController

let SignUP =  StoryboardValue.instantiateViewController(withIdentifier: SIGNUPVIEWCONTROLLER) as! SignUpViewController
let forgot =  StoryboardValue.instantiateViewController(withIdentifier: FORGOTPASSWORDVIEWCONTROLLER) as! ForgotViewController
let signUpOtp = StoryboardValue.instantiateViewController(withIdentifier: SIGNUPOTPVIEWCONTROLLER) as! SignUPOTPViewController
let forgotChange = StoryboardValue.instantiateViewController(withIdentifier: FORGOT_CHANGE_VIEWCONTROLLER) as! ForgotPasswordChangeViewController
let feed_Back = StoryboardValue.instantiateViewController(withIdentifier: FEEDBACK) as! FeedBackViewController//FeedBackViewController
let full = StoryboardValue.instantiateViewController(withIdentifier: FULLVIEW) as! FullViewController
let location = StoryboardValue.instantiateViewController(withIdentifier: LOCATIONVIEWCONTROLLER) as! LocationViewController
let review = StoryboardValue.instantiateViewController(withIdentifier: REVIEW_VIEWCONTROLLER) as! ReviewViewController
let MAINTABBARPAGE = StoryboardValue.instantiateViewController(withIdentifier: MAINTAB) as! MainTabbarController
let productDetail = StoryboardValue.instantiateViewController(withIdentifier: PRODUCT_DETAIL) as! ProductDetailViewController
let mywishList = StoryboardValue.instantiateViewController(withIdentifier: MY_WISHLIST) as! MyWishListViewController
let myCart = StoryboardValue.instantiateViewController(withIdentifier: MY_CART) as! MyCartViewController
let addressDetail = StoryboardValue.instantiateViewController(withIdentifier: ADDRESS_DETAIL) as! AddressDetailsViewController //
let order = StoryboardValue.instantiateViewController(withIdentifier: ORDERLIST) as! MyOrdersViewController
let orderDetail = StoryboardValue.instantiateViewController(withIdentifier: ORDER_DETAIL_VIEWCONTROLLER) as! OrderDetailsViewController
let checkOut = StoryboardValue.instantiateViewController(withIdentifier: CART_CHECKOUT) as! CartCheckOutViewController
let track = StoryboardValue.instantiateViewController(withIdentifier: TRACKVIEWCONTROLLER) as! TrackViewController
let Feed = StoryboardValue.instantiateViewController(withIdentifier: FEEDPAGEVIEWCONTROLLER) as! FeedPageViewController
let products = StoryboardValue.instantiateViewController(withIdentifier: PRODUCTSVIEWCONTROLLER) as! ProductsViewController
let Offers = StoryboardValue.instantiateViewController(withIdentifier: OFFERPAGEVIEWCONTROLLER) as! OffersViewController
let shops = StoryboardValue.instantiateViewController(withIdentifier: SHOPPAGEVIEWCONTROLLER) as! ShopsViewController
let shop_Detail  = StoryboardValue.instantiateViewController(withIdentifier: SHOPDETAILPAGEVIEWCONTROLLER) as! ShopDetailsViewController
let profile = StoryboardValue.instantiateViewController(withIdentifier: PROFILEVIEWCONTROLLER) as! ProfileViewController
let about = StoryboardValue.instantiateViewController(withIdentifier: ABOUTVIEWCONTROLLER) as! AboutViewController
let urlpage = StoryboardValue.instantiateViewController(withIdentifier: URLPAGEVIEWCONTROLLER) as! URLViewController
let account = StoryboardValue.instantiateViewController(withIdentifier: ACCOUNTVIEWCOTROLLER) as! AccountViewController
let address = StoryboardValue.instantiateViewController(withIdentifier: ADDRESSVIEWCONTROLLER) as! AddressViewController//AddressViewController
let changePass = StoryboardValue.instantiateViewController(withIdentifier: CHANGEPASSWORDVIEWCONTROLLER) as! ChangePasswordViewController
let add_Address = StoryboardValue.instantiateViewController(withIdentifier: ADD_ADDRESSVIEWCONTROLLER) as! AddAddressViewController
let map_view = StoryboardValue.instantiateViewController(withIdentifier: MAPVIEWCONTROLLER) as! MapViewController
let flyer = StoryboardValue.instantiateViewController(withIdentifier: FLYERPAGEVIEWCONTROLLER) as! FlyerPageViewController
let noWifi = StoryboardValue.instantiateViewController(withIdentifier: NOINTERNET) as! NoInternetViewController
let Permission = StoryboardValue.instantiateViewController(withIdentifier: PERMISSIONPAGE) as! PermissionViewController
let sort = StoryboardValue.instantiateViewController(withIdentifier: SORTINGPAGE) as! SortViewController
let filter = StoryboardValue.instantiateViewController(withIdentifier: FILTERPAGE) as! FilterViewController


//MARK:- API NAMES

//let BASE_URL : String = "http://singlecartclient.prompttechsolutions.in/CustomerService.svc/"
///https://sci.singlecartretail.com/
let BASE_URL : String = "http://sc.prompttechsolutions.in/CustomerService.svc/"
//let BASE_URL : String = "https://sci.singlecartretail.com/CustomerService.svc/"
let ADD_WISH : String = "ActionWish"
let ADD_CART : String = "ActionCart"
let GET_WISHLIST : String = "WishList"
let GET_CART : String = "CartList"
let MY_ORDERS : String = "GetOrderSummaryList"
let ORDER_DETAILS : String = "GetOrderSummaryDetails"
let CART_CHECKOUT_URL : String = "CartCheckout"
let PLACE_ORDER_URL : String = "PlaceOrder"
let CHECKSIGNUP : String = "CheckCusSignUp"
let SIGNUP_URL : String = "CustomerSignUpWithOTP"//"CustomerSignUp"
//CustomerSignUpWithOTP
let LOGIN : String = "CustomerLogin"
let RESET_PASSWORD : String = "ResetPassword"
let NEW_PASSWORD : String  = "NewPassword"
let FEEDBACK_URL : String = "CustomerFeedback"
let ADDREVIEW : String = "AddReview"
let SHOPCATEGORIES : String = "GetShopCategories"
let GETDASHBOARD_DATA : String = "GetDashBoardData"
let GETSHOPS : String = "GetShops"
//let GETSHOPDETAILS : String = "GetShopDetails"
let GETSHOPDETAILS : String = "GetShopDetailsWithDistance"
let GETREVIEWDETAILS : String = "ShopReviewByUser"
let GETREVIEWSUMMARY : String = "ReviewSummary"
let GETOFFERPRODUCTS : String = "GetOfferProducts"
let GETOFFERSEARCHPRODUCTS : String = "GetProducts"
let ADDTOFAVOURITES : String = "FavoriteShop"
let GETFLYERS : String = "GetFlyers"
let GETPROFILE : String = "GetCustomerInfo"
let GETADDRESS : String = "GetCustomerAddresses"
let CHANGE_PASSWORD : String = "CustomerChangePassword"
let DELETEADDRESS : String = "CustomerAddressDelete"
let ADD_EDIT_ADDRESS : String = "CustomerAddressAdd"
let UPDATE_TOKEN : String   = "UpdateToken"

let CUSTOMER_SIGNUP_OTP : String = "CheckCusSignUpOTP"

//MARK:- String Constants

let APPLICATION_NAME : String = "SingleCart"
let OK_TEXT :String     = "OK"
let CANCEL_TEXT : String    = "CANCEL"
let SIGN_TEXT : String    = "Logout"


            // Pragma MARK:- Messages

//MARK:- Error String Constants
let FAILED_MESSAGE : String    = "Failed to load.Try again..."

//MARK:- Success String Constants

let SUCCESS_MESSAGE : String    = "Success"
let LOGIN_SUCCESS : String = "Successfully Logged"
let ERROR : String = "Please login to continue"


//MARK:- Number Constants
let DEFAULT_OTP = "123456"
let DEFAULT_V_CODE = "123456"
let default_pageNo = 1
let default_pageSize = 30

//MARK:- Color constant

let HOME_NAVIGATION_BGCOLOR :UIColor = UIColor(red: 0 / 255 , green: 173 / 255, blue: 96 / 255, alpha: 1.0)
let BGCOLOR_1 :UIColor = UIColor(red: 127 / 255 , green: 0 / 255, blue: 0 / 255, alpha: 1.0)
let track1 :UIColor = UIColor(red: 127 / 255 , green: 0 / 255, blue: 0 / 255, alpha: 0.25)
let BGCOLOR_2 :UIColor = UIColor(red:255 / 255 , green: 140 / 255, blue:0 / 255, alpha: 1.0)
let track2 :UIColor = UIColor(red:255 / 255 , green: 140 / 255, blue:0 / 255, alpha: 0.5)
let BGCOLOR_3 :UIColor = UIColor(red: 253 / 255 , green: 206 / 255, blue: 0 / 255, alpha: 1.0)
let track3 :UIColor = UIColor(red: 253 / 255 , green: 206 / 255, blue: 0 / 255, alpha: 0.50)
let BGCOLOR_4 :UIColor = UIColor(red: 0 / 255 , green: 100 / 255, blue: 0 / 255, alpha: 1.0)
let track4 :UIColor = UIColor(red: 0 / 255 , green: 100 / 255, blue: 0 / 255, alpha: 0.5)
 let White :UIColor = UIColor(red: 255 / 255 , green: 255 / 255, blue: 255 / 255, alpha: 1)
let SELECTED_TRACK : UIColor = UIColor(red: 1 / 255 , green: 164 / 255, blue: 101 / 255, alpha: 1.0)//
let DEFAULT_BORDER_COLOR : UIColor =  UIColor(red: 211 / 255 , green: 211 / 255, blue: 211 / 255, alpha: 1.0)//#D3D3D3    rgb(211,211,211)
//#00ad60
//EDFDE3


//MARK:- UserDefault values identifier
let DEVICETOKEN : String = "Device_Token"
let FIREBASETOKEN : String = "Firebase_Token"
let AUTHTOKEN : String = "AuthToken"
let USERID : String = "UserID"
let FIRSTTIME : String = "firstTime"
let LOGGED : String = "Logged"
let USERAVAILABLE : String = "useravailable"
let LATITUDE : String = "latitude"
let LONGITUDE : String = "longitude"
let ADD_LATITUDE : String = "add_latitude"
let ADD_LONGITUDE : String = "add_longitude"
let CART_VALUE : String = "CART"
let WISH_VALUE : String = "WISH"
let PARENTVIEWCONTROLLER : String = "PARENT"
let AUTHORISED : String = "Authorised"


//MARK:- TABLEVIEWCELL IDENTIFIER
let PRODUCT_TABLEVIEWCELL : String = "productTableViewCell"
let PRODUCTDETAILTABLEVIEWCELL : String = "productDetailTableViewCell"
let WISHLIST_TABLEVIEWCELL : String = "wishListTableViewCell"
let CARTLIST_TABLEVIEWCELL : String = "cartTableViewCell"
let CART_CHECKOUT_TABLEVIEWCELL : String = "cartCheckOutTableViewCell"
let ADDRESS_DETAIL_TABLEVIEWCELL : String = "addressDetailTableViewCell"
let MY_ORDER_TABLEVIEWCELL : String = "MyOrderTableViewCell"
let ORDER_DETAIL_TABLEVIEWCELL : String = "OrderDetailTableViewCell"
let CHECKOUT_TABLEVIEWCELL : String = "CheckOutTableViewCell"
let OFFERTABLEVIEWCELL : String = "OffertableViewCell"
let SHOPSTABLEVIEWCELL : String = "shopsTableViewCell"
let SHOPDETAILTABLEVIEWCELL : String = "ShopDetailTableViewCell"
let FLYERTABLEVIEWCELL : String = "FlyerTableViewCell"
let PROFILETABLEVIEWCELL : String = "ProfileTableViewCell"
let ABOUTTABLEVIEWCELL : String = "aboutTableViewCell"
let ACCOUNTTABLEVIEWCELL : String = "accountTableViewCell"
let ADDRESSTABLEVIEWCELL : String = "addressTableViewCell"
let ADD_ADDRESSTABLEVIEWCELL : String = "addAddressTableViewCell"
let FEEDTABLEVIEWCELL : String = "FeedTableViewCell"

let EMPTYTABLEVIEWCELL : String = "EmptyTableViewCell"
let OFFEREMPTYTABLEVIEWCELL : String = "OfferEmptyTableViewCell"
let SHOPDETAILEMPTYTABLEVIEWCELL : String = "ShopDetailEmptyTableViewCell"
let SHOPEMPTYTABLEVIEWCELL : String = "ShopEmptyTableViewCell"
let ACCOUNTEMPTYTABLEVIEWCELL : String = "AccountEmptyTableViewCell"
let ADDRESSEMPTYTABLEVIEWCELL : String = "addressEmptyTableViewCell"
let FLYEREMPTYRABLEVIEWCELL : String = "flyerEmptyTableViewCell"
let MY_ORDER_EMPTY_TABLEVIEWCELL : String = "MyOrderEmptyTableViewCell"

//MARK:- CollectionView Cell IDENTIFIER

let FLYERCOLLECTIONVIEWCELL : String = "flyerCollectionViewCell"
let SHOPDETAILFLYERCOLLECTIONVIEWCELL : String = "shopDetailFlyerCollectionViewCell"
let SHOPDETAILPRODUCTCOLLECTIONVIEWCELL : String = "ShopDetailProductCollectionViewCell"
//MARK:- Array costant

let PROFILEARRAY_USERID : [String] = ["My Cart","My Wishlist","My Orders" ,"Sell on SingleCart?","Feedback","Share","About","Logout"] // with userid
let PROFILEARRAY_IMAGES_USERID : [String] = ["my_cart.png","my_wishlist.png","my_orders.png","sell.png","feedback.png","share.png","about.png","Login.png"]

let PROFILEARRAY : [String] = ["My Cart","My Wishlist","My Orders" ,"Sell on SingleCart?","Feedback","Share","About"] // without userid
let PROFILEARRAY_IMAGES : [String] = ["my_cart.png","my_wishlist.png","my_orders.png","sell.png","feedback.png","share.png","about.png"]

let OfferBooleanValues : [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false]
let OfferIntValues : [Int] = [0,0,0,0,0,0]

//MARK:- Image Constant

let placeHolderImage = "logo_single_white.png"
let offerPlaceHolderImage = "default_Offer.png"
let shopsPlaceholderImage = "default_shop.png"
let favourite_true = "favourite_true.png"
let favourite_false = "favourite_false.png"
let default_No_Image = "No_Image_Available.png"
let logo = "iTunesArtwork.png"

let PRODUCT_TYPE_SHOP : Int = 1//product based
let SERVICE_TYPE_SHOP : Int = 2//(Laundry)
let SERVICE_SMALL_TYPE_SHOP : Int = 3//(Spa and Salon)

let cartList_1_First : String = "Pickup from my location"
let cartList_1_Second : String = "I will drop to shop"

let cartList_2_First : String = "Home Service - Came and service at address"
let cartList_2_Second : String = "Shop Visit - I will goto the shop"

let cartList_3_First : String = "Please Deliver to my address"
let cartList_3_Second : String = "I will come and collect"

let ERROR_MESSAGE : String = "Your active session was expired. Please re-login to continue or try again later."

var cryptionKey = "haidearhackerobs"
var iv = "0123456789abcdef"//0123456789abcdef


