//
//  DetailShareTableViewCell.m
//  粉猫xib
//
//  Created by che on 16/1/29.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailShareTableViewCell.h"
#define COLOR_BACK_MAIN [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1]

@implementation DetailShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVPoint.image=[UIImage imageNamed:@"wuyu"];
//    _imageVHead.image=[UIImage imageNamed:@"home_content_shaidan"];
//    _imageVA.image=[UIImage imageNamed:@"weixin"];
//    _imageVB.image=[UIImage imageNamed:@"weixin"];
//    _imageVC.image=[UIImage imageNamed:@"weixin"];
//    _imageVD.image=[UIImage imageNamed:@"weixin"];
    [UILabel changeLabel:_labelName AndFont:24 AndColor:COLOR_BUTTON_ORANGE];
    [UILabel changeLabel:_labelTitle AndFont:30 AndColor:COLOR_TEXT_TITILE];
    [UILabel changeLabel:_labelGoods AndFont:24 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelItem AndFont:24 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelContent AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelDate AndFont:22 AndColor:COLOR_TEXT_CONTENT];
    
    _viewMain.backgroundColor=COLOR_BACK_MAIN;

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
