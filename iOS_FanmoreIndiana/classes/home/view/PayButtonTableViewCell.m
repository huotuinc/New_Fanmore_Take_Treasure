//
//  PayButtonTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "PayButtonTableViewCell.h"

@implementation PayButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UIButton changeButton:_buttonPay AndFont:30 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:[UIColor orangeColor] AndBorderColor:[UIColor orangeColor] AndCornerRadius:3 AndBorderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
