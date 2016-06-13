//
//  DetailPastingTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/2/1.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailPastingTableViewCell.h"

@implementation DetailPastingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelItem AndFont:24 AndColor:COLOR_TEXT_DATE];
    _viewItem.backgroundColor=COLOR_BACK_MAIN;
    _viewItem.layer.borderColor=COLOR_BACK_MAIN.CGColor;
    _viewItem.layer.borderWidth=1;
    _viewItem.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
