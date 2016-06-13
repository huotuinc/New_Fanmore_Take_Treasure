//
//  DetailProgressCView.m
//  粉猫xib
//
//  Created by che on 16/1/22.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailProgressCView.h"

@implementation DetailProgressCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewProgress.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
    _viewProgress.clipsToBounds=YES;
    //设置进度条颜色
    _viewProgress.trackTintColor=COLOR_PROGRESS_B;
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    _viewProgress.progress=0.7;
    //设置进度条上进度的颜色
    _viewProgress.progressTintColor=COLOR_PROGRESS_A;
    
    [UILabel changeLabel:_labelRest AndFont:24 AndColor:COLOR_SHINE_BLUE];
    [UILabel changeLabel:_labelTerm AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelTotal AndFont:24 AndColor:COLOR_TEXT_CONTENT];
}

- (void)drawRect:(CGRect)rect {
    _viewProgress.layer.cornerRadius=_viewProgress.frame.size.height/2;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
