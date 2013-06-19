//
//  ViewController.h
//  MercadoCostos
//
//  Created by Brian Krochik on 30/05/13.
//  Copyright (c) 2013 Brian Krochik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet ADBannerView *banner;
@property (weak, nonatomic) IBOutlet UITableView *priceTable;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCalc;

@property (strong, nonatomic) NSArray *averages;
@end
/Users/bkrochik/Desktop/iPhone5,2_6.1.3_10B329_Restore.ipsw