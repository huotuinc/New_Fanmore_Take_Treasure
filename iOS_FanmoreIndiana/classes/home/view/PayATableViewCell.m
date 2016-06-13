//
//  PayATableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "PayATableViewCell.h"

@implementation PayATableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLine.image = [UIImage imageNamed:@"line_huise"];
    _imageVTop.image = [UIImage imageNamed:@"line_huise"];
    [UILabel changeLabel:_labelA AndFont:26 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelB AndFont:26 AndColor:COLOR_SHINE_RED];
    [UILabel changeLabel:_labelCount AndFont:26 AndColor:[UIColor whiteColor]];
    _labelCount.layer.cornerRadius = 3;
    _labelCount.layer.borderColor = COLOR_TEN_RED.CGColor;
    _labelCount.layer.borderWidth = 1;
    _labelCount.layer.masksToBounds =YES;
    _labelCount.backgroundColor = COLOR_TEN_RED;
    [UILabel changeLabel:_labelMoney AndFont:24 AndColor:COLOR_TEXT_DATE];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
