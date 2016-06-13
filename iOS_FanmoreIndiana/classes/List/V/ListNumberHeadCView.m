//
//  DetailNumberHeadTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/3.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ListNumberHeadCView.h"

@implementation ListNumberHeadCView

- (void)awakeFromNib {
    // Initialization code.
    [super awakeFromNib];
    [UILabel changeLabel:_labelA AndFont:32 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelB AndFont:32 AndColor:COLOR_TEXT_CONTENT];
    [UIButton changeButton:_buttonGo AndFont:30 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:COLOR_BUTTON_ORANGE AndBorderColor:COLOR_BUTTON_ORANGE AndCornerRadius:3 AndBorderWidth:1];
    [UIButton changeButton:_buttonLook AndFont:30 AndTitleColor:COLOR_TEXT_CONTENT AndBackgroundColor:COLOR_BACK_MAIN AndBorderColor:COLOR_BACK_MAIN AndCornerRadius:3 AndBorderWidth:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
