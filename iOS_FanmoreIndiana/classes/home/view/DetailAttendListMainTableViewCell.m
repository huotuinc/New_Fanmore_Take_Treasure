//
//  DetailiAttendListTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/1/22.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailAttendListMainTableViewCell.h"

@implementation DetailAttendListMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVHead.image=[UIImage imageNamed:@"tou"];
    _imageVLine.image=[UIImage imageNamed:@"line_huise"];
    [UILabel changeLabel:_labelName AndFont:24 AndColor:COLOR_SHINE_BLUE];
    [UILabel changeLabel:_labelCity AndFont:22 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelDate AndFont:22 AndColor:COLOR_TEXT_DATE];
    _viewBase.backgroundColor=COLOR_BACK_MAIN;

}

-(void)drawRect:(CGRect)rect{
    _imageVHead.layer.cornerRadius=_imageVHead.frame.size.height/2;
    _imageVHead.clipsToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
