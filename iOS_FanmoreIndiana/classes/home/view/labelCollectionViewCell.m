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
    [super awakeFromNib];
    [UILabel changeLabel:_labelMain AndFont:26 AndColor:COLOR_TEXT_DATE];
    _labelMain.backgroundColor=[UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
}

@end
