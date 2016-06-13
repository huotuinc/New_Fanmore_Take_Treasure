//
//  HomeSendRedPocketCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/14.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "HomeSendRedPocketCView.h"

@implementation HomeSendRedPocketCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVBack.image = [UIImage imageNamed:@"fahongbao"];
    _imageVClose.image = [UIImage imageNamed:@"cha"];
//    _imageVMoney.image = [UIImage imageNamed:@"jingbi"];
    _imageVLine.image = [UIImage imageNamed:@"line_red"];
    UIColor *orangeColor = [UIColor colorWithRed:255/255.0f green:221/255.0f blue:34/255.0f alpha:1];
    [UIButton changeButton:_buttonSend AndFont:44 AndTitleColor:COLOR_TEXT_TITILE AndBackgroundColor:[UIColor colorWithRed:255/255.0f green:221/255.0f blue:34/255.0f alpha:1] AndBorderColor:[UIColor colorWithRed:255/255.0f green:221/255.0f blue:34/255.0f alpha:1] AndCornerRadius:3 AndBorderWidth:1];
    [UILabel changeLabel:_labelA AndFont:50 AndColor:orangeColor];
    [UILabel changeLabel:_labelNumber AndFont:108 AndColor:orangeColor];
//    [UILabel changeLabel:_labelYou AndFont:40 AndColor:[UIColor whiteColor]];
//    [UILabel changeLabel:_labelYao AndFont:36 AndColor:[UIColor whiteColor]];
    [UILabel changeLabel:_labelMain AndFont:36 AndColor:[UIColor whiteColor]];
//    _viewBase.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
    _viewBase.backgroundColor = [UIColor clearColor];

    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
