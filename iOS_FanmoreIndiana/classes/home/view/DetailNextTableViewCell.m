//
//  DetailNextTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/1/22.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailNextTableViewCell.h"

@implementation DetailNextTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVNext.image=[UIImage imageNamed:@"jinru"];
    [UILabel changeLabel:_labelTitle AndFont:30 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelAdvice AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    _imageVLine.image=[UIImage imageNamed:@"line_huise"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
