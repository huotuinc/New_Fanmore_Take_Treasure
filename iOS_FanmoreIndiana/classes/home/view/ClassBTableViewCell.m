//
//  ClassBTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/25.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ClassBTableViewCell.h"

@implementation ClassBTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLine.image=[UIImage imageNamed:@"line_huise"];
    [UILabel changeLabel:_labelClassB AndFont:24 AndColor:COLOR_TEXT_DATE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
