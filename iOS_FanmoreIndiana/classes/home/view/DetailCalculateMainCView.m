//
//  DetailCalculateMainCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/1.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailCalculateMainCView.h"

@implementation DetailCalculateMainCView

- (void)awakeFromNib {
    // Initialization code
    [UILabel changeLabel:_labelA AndFont:26 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelB AndFont:24 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelC AndFont:24 AndColor:COLOR_SHINE_RED];
    _imageVLine.image = [UIImage imageNamed:@"line_huise"];
    _buttonShow.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end