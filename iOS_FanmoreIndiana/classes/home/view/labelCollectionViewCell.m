//
//  MyCollectionViewCell.m
//  UICollection---BASE
//
//  Created by che on 16/1/19.
//  Copyright © 2016年 LHF. All rights reserved.
//

#import "labelCollectionViewCell.h"

@implementation labelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [UILabel changeLabel:_labelMain AndFont:26 AndColor:[UIColor grayColor]];
    _labelMain.backgroundColor=[UIColor whiteColor];
}

@end
