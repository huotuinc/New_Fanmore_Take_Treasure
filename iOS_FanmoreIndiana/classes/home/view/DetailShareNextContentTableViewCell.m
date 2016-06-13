//
//  DetailShareNextContentTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailShareNextContentTableViewCell.h"

@implementation DetailShareNextContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelContent AndFont:22 AndColor:COLOR_TEXT_DATE];
    for (int i =0; i<2; i++) {
        UIImageView *imageV = [self viewWithTag:200+i];
        imageV.image =[UIImage imageNamed:@"line_huise"];
    }
    _labelContent.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
