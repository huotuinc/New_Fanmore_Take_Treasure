//
//  DetailNumberHeadCView.m
//  粉猫xib
//
//  Created by che on 16/1/31.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailNumberHeadCView.h"

@implementation DetailNumberHeadCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelTitle AndFont:28 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelItem AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelAttend AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    
    _viewBase.layer.borderColor=COLOR_BACK_MAIN.CGColor;
    _viewBase.layer.borderWidth=1;
    _viewBase.backgroundColor=COLOR_BACK_MAIN;
    _viewBase.layer.masksToBounds=YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
