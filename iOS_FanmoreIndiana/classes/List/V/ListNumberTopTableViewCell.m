//
//  ListNumberTopTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/3.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ListNumberTopTableViewCell.h"

@implementation ListNumberTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLineA.image = [UIImage imageNamed:@"line_huise"];
    _imageVLineB.image = [UIImage imageNamed:@"line_huise"];
    _imageVLineC.image = [UIImage imageNamed:@"line_huise"];
    [UILabel changeLabel:_labelA AndFont:26 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelGoods AndFont:26 AndColor:COLOR_SHINE_BLUE];
    [UILabel changeLabel:_labelIssued AndFont:26 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelCount AndFont:26 AndColor:COLOR_TEXT_CONTENT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
