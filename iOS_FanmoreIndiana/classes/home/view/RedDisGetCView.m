//
//  RedGetCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/9.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RedDisGetCView.h"

@implementation RedDisGetCView

- (void)awakeFromNib {
    // Initialization code
    [UILabel changeLabel:_labelCount AndFont:30 AndColor:COLOR_SHINE_RED];
    [UILabel changeLabel:_labelMoney AndFont:30 AndColor:COLOR_SHINE_RED];
    _imageVBack.image = [UIImage imageNamed:@"hbbb"];
    [UIButton changeButton:_buttonGo AndFont:44 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:COLOR_SHINE_RED AndBorderColor:COLOR_SHINE_RED AndCornerRadius:3 AndBorderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end