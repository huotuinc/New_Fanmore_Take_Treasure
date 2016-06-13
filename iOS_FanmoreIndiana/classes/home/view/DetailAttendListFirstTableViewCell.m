//
//  DeatilAttendListFirstTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/1/22.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailAttendListFirstTableViewCell.h"

@implementation DetailAttendListFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVLine.image=[UIImage imageNamed:@"line_huise"];
    _viewBase.backgroundColor=COLOR_BACK_MAIN;
    [UILabel changeLabel:_labelDate AndFont:24 AndColor:COLOR_TEXT_CONTENT];
}
-(void)drawRect:(CGRect)rect{
    _labelDate.layer.cornerRadius=_labelDate.frame.size.height/2;
    _labelDate.layer.borderColor=[UIColor colorWithRed:200/255.0f green:199/255.0f blue:204/255.0f alpha:1].CGColor;
    _labelDate.layer.borderWidth=1;
    _labelDate.layer.masksToBounds=YES;


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
