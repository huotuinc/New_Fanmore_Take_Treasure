//
//  ListNumberMainTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/3.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ListNumberMainTableViewCell.h"

@implementation ListNumberMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLA.image = [UIImage imageNamed:@"line_huise"];
    _imageVLB.image = [UIImage imageNamed:@"line_huise"];
    for (int i =0; i<104; i++) {
        UILabel *label = [self viewWithTag:100+i];
        [UILabel changeLabel:label AndFont:26 AndColor:COLOR_TEXT_DATE];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
