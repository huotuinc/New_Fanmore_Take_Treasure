//
//  HomeGetRedPocketCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/14.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "HomeGetRedPocketCView.h"

@implementation HomeGetRedPocketCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVBack.image = [UIImage imageNamed:@"fahongbao"];
    _imageVClose.image = [UIImage imageNamed:@"cha"];
    _imageVMoney.image = [UIImage imageNamed:@"jingbi"];
    _imageVLine.image = [UIImage imageNamed:@"line_red"];
    [UIButton changeButton:_buttonGet AndFont:44 AndTitleColor:COLOR_TEXT_TITILE AndBackgroundColor:[UIColor colorWithRed:255/255.0f green:221/255.0f blue:34/255.0f alpha:1] AndBorderColor:[UIColor colorWithRed:255/255.0f green:221/255.0f blue:34/255.0f alpha:1] AndCornerRadius:3 AndBorderWidth:1];
    [UILabel changeLabel:_labelC AndFont:36 AndColor:[UIColor whiteColor]];
    [UILabel changeLabel:_labelA AndFont:50 AndColor:nil];
    [UILabel changeLabel:_labelB AndFont:108 AndColor:nil];
//    _viewBase.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
    _viewBase.backgroundColor = [UIColor clearColor];
    _labelA.textColor = [UIColor colorWithRed:255/255.0f green:190/255.0f blue:50/255.0f alpha:1];
    _labelB.textColor = [UIColor colorWithRed:255/255.0f green:190/255.0f blue:50/255.0f alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
