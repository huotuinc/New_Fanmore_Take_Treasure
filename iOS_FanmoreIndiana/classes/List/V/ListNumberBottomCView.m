//
//  ListNumberBottomCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/3.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ListNumberBottomCView.h"

@implementation ListNumberBottomCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewBase.backgroundColor = COLOR_BACK_MAIN;
    _imageVLA.image = [UIImage imageNamed:@"line_huise"];
    _imageVLB.image = [UIImage imageNamed:@"line_huise"];
    _imageVLC.image = [UIImage imageNamed:@"line_huise"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
