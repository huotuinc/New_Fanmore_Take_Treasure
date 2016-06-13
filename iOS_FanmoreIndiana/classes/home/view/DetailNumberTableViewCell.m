//
//  DetailNumberTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/1/31.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailNumberTableViewCell.h"

@implementation DetailNumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    for (int i =0 ; i<5; i++) {
        UILabel *label=[self viewWithTag:100+i];
        [UILabel changeLabel:label AndFont:22 AndColor:COLOR_TEXT_TITILE];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
