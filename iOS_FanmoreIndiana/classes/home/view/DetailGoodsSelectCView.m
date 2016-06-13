//
//  DetailGoodsSelectCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/2.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailGoodsSelectCView.h"

@implementation DetailGoodsSelectCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelPerson AndFont:28 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelAttend AndFont:28 AndColor:COLOR_TEXT_CONTENT];
    
    _viewChange.layer.cornerRadius = 3;
    _viewChange.layer.borderColor = COLOR_TEXT_CONTENT.CGColor;
    _viewChange.layer.borderWidth = 1;
    _viewChange.layer.masksToBounds =YES;
    [UIButton changeButton:_buttonGo AndFont:28 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:COLOR_TEN_RED AndBorderColor:COLOR_TEN_RED AndCornerRadius:3 AndBorderWidth:1];
    [UIButton changeButton:_buttonClose AndFont:28 AndTitleColor:COLOR_SHINE_BLUE AndBackgroundColor:nil AndBorderColor:nil AndCornerRadius:0 AndBorderWidth:0];
    _viewPerson.backgroundColor =COLOR_BACK_MAIN;
    _textFNumber.layer.borderColor = COLOR_BACK_MAIN.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
