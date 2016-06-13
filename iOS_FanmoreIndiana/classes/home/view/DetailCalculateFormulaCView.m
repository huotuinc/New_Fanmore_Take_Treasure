//
//  DetailCalculateFormulaCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/1.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailCalculateFormulaCView.h"

@implementation DetailCalculateFormulaCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelA AndFont:26 AndColor:[UIColor whiteColor]];
    [UILabel changeLabel:_labelB AndFont:24 AndColor:[UIColor whiteColor]];
    _viewBase.backgroundColor = COLOR_BUTTON_ORANGE;
    _viewBase.layer.borderWidth = 1;
    _viewBase.layer.cornerRadius = 3;
    _viewBase.layer.borderColor = COLOR_BUTTON_ORANGE.CGColor;
    _viewBase.layer.masksToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
