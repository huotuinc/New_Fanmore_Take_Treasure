//
//  RedHopeCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/12.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RedHopeCView.h"

@implementation RedHopeCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    _imageVBack.image = [UIImage imageNamed:@"wuhuodong"];
    [UILabel changeLabel:_labelTitle AndFont:70 AndColor:[UIColor whiteColor]];
    _viewBase.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
