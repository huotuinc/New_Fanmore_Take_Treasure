//
//  DetailAttendCountCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/25.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailAttendCountCView.h"

@implementation DetailAttendCountCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewBack.backgroundColor=COLOR_BACK_MAIN;
    _viewBack.layer.cornerRadius=3;
    _viewBack.layer.masksToBounds=YES;
    [UILabel changeLabel:_labelA AndFont:24 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelB AndFont:24 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelCount AndFont:28 AndColor:COLOR_TEXT_DATE];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
