//
//  DetailShareNextHeadTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailShareNextHeadTableViewCell.h"

@implementation DetailShareNextHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    for (int i =0; i<3; i++) {
        UIImageView *imageV = [self viewWithTag:200+i];
        imageV.image =[UIImage imageNamed:@"line_huise"];
    }
    [UILabel changeLabel:_labelTitle AndFont:26 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelName AndFont:22 AndColor:COLOR_SHINE_BLUE];
    [UILabel changeLabel:_labelDate AndFont:22 AndColor:COLOR_TEXT_DATE];
    
    for (int i =0; i <10; i++) {
        UILabel *label= [self viewWithTag:100+i];
        [UILabel changeLabel:label AndFont:22 AndColor:COLOR_TEXT_DATE];
    }
    _labelNumber.textColor = COLOR_TEN_RED;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
