//
//  DetailCalculateATableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/1.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailCalculateATableViewCell.h"

@implementation DetailCalculateATableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    for (int i =0; i<6; i++) {
        UILabel *label = [self viewWithTag:100+i];
        [UILabel changeLabel:label AndFont:24 AndColor:COLOR_TEXT_DATE];
        label.backgroundColor = [UIColor clearColor];
    }
    [UILabel changeLabel:_labelNumber AndFont:24 AndColor:COLOR_SHINE_RED];
    _viewBase.backgroundColor = COLOR_BACK_MAIN;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
