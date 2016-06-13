//
//  PayBTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "PayBTableViewCell.h"

@implementation PayBTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLine.image = [UIImage imageNamed:@"line_huise"];
    _imageVBottom.image = [UIImage imageNamed:@"line_huise"];
    [_buttonSelect setBackgroundImage:[UIImage imageNamed:@"choose00"] forState:UIControlStateNormal];
    [_buttonSelect setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [UILabel changeLabel:_labelPay AndFont:26 AndColor:COLOR_TEXT_CONTENT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
