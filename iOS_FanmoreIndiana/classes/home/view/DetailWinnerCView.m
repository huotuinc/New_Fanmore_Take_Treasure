//
//  DetailWinnerCView.m
//  粉猫xib
//
//  Created by che on 16/1/21.
//  Copyright © 2016年 车. All rights reserved.
//

#import "DetailWinnerCView.h"
#import "UIButton+FMButtonStyle.h"
@implementation DetailWinnerCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageVState.image=[UIImage imageNamed:@"huojiang"];
    _imageVLuck.image=[UIImage imageNamed:@"di"];
    _imageVHead.image=[UIImage imageNamed:@"error"];
    _viewMain.backgroundColor=[UIColor cyanColor];
    _viewBase.layer.borderWidth=1;
    _viewBase.layer.borderColor=COLOR_BACK_MAIN.CGColor;
    _viewBase.layer.masksToBounds=YES;
    for ( int i= 0; i<8; i++) {
        UILabel *label=[self viewWithTag:100+i];
        label.backgroundColor=[UIColor clearColor];
        [UILabel changeLabel:label AndFont:24 AndColor:COLOR_TEXT_DATE];
    }
    [UILabel changeLabel:_labelWinner AndFont:30 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelWinnerA AndFont:30 AndColor:COLOR_BUTTON_ORANGE];
    [UILabel changeLabel:_labelAttendA AndFont:24 AndColor:COLOR_BUTTON_ORANGE];
    [UILabel changeLabel:_labelNumber AndFont:24 AndColor:[UIColor whiteColor]];
    [UILabel changeLabel:_labelNumberA AndFont:30 AndColor:[UIColor whiteColor]];
    [UIButton changeButton:_buttonContent AndFont:30 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:[UIColor clearColor] AndBorderColor:[UIColor whiteColor] AndCornerRadius:3 AndBorderWidth:1];
    _viewMain.backgroundColor = COLOR_BACK_WINNER;

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
