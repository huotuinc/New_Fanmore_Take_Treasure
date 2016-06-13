//
//  ListBottomCView.m
//  粉猫xib
//
//  Created by che on 16/2/15.
//  Copyright © 2016年 车. All rights reserved.
//

#import "ListBottomCView.h"
#import "UILabel+FMLableStyle.h"
#import "UIButton+FMButtonStyle.h"
@implementation ListBottomCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelNotice AndFont:22 AndColor:nil];
    [UILabel changeLabel:_labelMoney AndFont:22 AndColor:nil];
    [UILabel changeLabel:_labelAll AndFont:22 AndColor:nil];
    
    [UIButton changeButton:_buttonGo AndFont:28 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:COLOR_BUTTON_ORANGE AndBorderColor:COLOR_BUTTON_ORANGE AndCornerRadius:3 AndBorderWidth:1];


    [_buttonAll setBackgroundImage:[UIImage imageNamed:@"recharge_icon_choose_none"] forState:UIControlStateNormal];
    [_buttonAll setBackgroundImage:[UIImage imageNamed:@"recharge_icon_choose"] forState:UIControlStateSelected];
}

-(void)drawRect:(CGRect)rect{
    _buttonGo.clipsToBounds=YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
