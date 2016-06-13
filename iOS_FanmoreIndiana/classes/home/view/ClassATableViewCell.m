//
//  ClassATableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/25.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ClassATableViewCell.h"

@implementation ClassATableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLine.image=[UIImage imageNamed:@"line_huise"];
    _imageVClass.image=[UIImage imageNamed:@"home_content_fenlei"];
    [UILabel changeLabel:_labelClass AndFont:28 AndColor:COLOR_TEXT_TITILE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
