//
//  PriceCell.h
//  MercadoCostos
//
//  Created by Brian Krochik on 30/05/13.
//  Copyright (c) 2013 Brian Krochik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtType;
@property (weak, nonatomic) IBOutlet UILabel *txtPub;
@property (weak, nonatomic) IBOutlet UILabel *txtSell;
@property (weak, nonatomic) IBOutlet UILabel *txtGan;
@property (weak, nonatomic) IBOutlet UILabel *txtGanUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblCostPub;
@property (weak, nonatomic) IBOutlet UILabel *lblCostSell;
@property (weak, nonatomic) IBOutlet UILabel *lblGanUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblGan;
@property (weak, nonatomic) IBOutlet UIImageView *imgList;


@end
