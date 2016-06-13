//
//  DetailBottomDoneCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/26.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailBottomDoneCView.h"

@implementation DetailBottomDoneCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UIButton changeButton:_buttonGo AndFont:28 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:[UIColor orangeColor] AndBorderColor:[UIColor orangeColor] AndCornerRadius:3 AndBorderWidth:1];
    [UILabel changeLabel:_labelNew AndFont:28 AndColor:COLOR_TEXT_TITILE];
    _imageVLine.image =[UIImage imageNamed:@"line_huise"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
