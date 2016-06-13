//
//  DetailShareNextImageVTableViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailShareNextImageVTableViewCell.h"

@implementation DetailShareNextImageVTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    for (int i =0; i<3; i++) {
        UIImageView *imageV = [self viewWithTag:200+i];
        imageV.image =[UIImage imageNamed:@"line_huise"];
    }
    _imageVGoods.image = [UIImage imageNamed:@"home_content_zhuanqu"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
