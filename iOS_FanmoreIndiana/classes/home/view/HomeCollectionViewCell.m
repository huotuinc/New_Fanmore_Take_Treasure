//
//  HomeCollectionViewCell.m
//  home
//
//  Created by 刘琛 on 16/1/15.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [UILabel changeLabel:_labelName AndFont:28 AndColor:COLOR_TEXT_TITILE];
    [UILabel changeLabel:_labelProgress AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    [UIButton changeButton:_joinList AndFont:24 AndTitleColor:COLOR_SHINE_RED AndBackgroundColor:[UIColor whiteColor] AndBorderColor:COLOR_SHINE_RED AndCornerRadius:3 AndBorderWidth:1];
    
    _viewProgress.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
    _viewProgress.clipsToBounds=YES;
    //设置进度条颜色
    _viewProgress.trackTintColor=COLOR_PROGRESS_B;
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    _viewProgress.progress=0.7;
    //设置进度条上进度的颜色
    _viewProgress.progressTintColor=COLOR_PROGRESS_A;
}
-(void)drawRect:(CGRect)rect{
    _viewProgress.layer.cornerRadius=_viewProgress.frame.size.height/2;


}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.joinList.layer.borderColor = [UIColor redColor].CGColor;
    self.joinList.layer.borderWidth = 0.5;
    self.joinList.tintColor = [UIColor redColor];
    self.joinList.layer.cornerRadius = 5;
    
    
    
}

- (void)setModel:(AppGoodsListModel *)model {
    _model = model;
    
    if ([model.areaAmount integerValue] > 0) {
        _imageVState.hidden = NO;
        _imageVState.image=[UIImage imageNamed:@"zhuanqu_a"];
    }else {
        _imageVState.hidden = YES;
    }
    _labelName.text=model.title;
    CGFloat percent=(model.toAmount.floatValue -model.remainAmount.floatValue)/(model.toAmount.floatValue);
    _viewProgress.progress=percent;
    NSString *percentString = [NSString stringWithFormat:@"%.0f%%",percent*100];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"开奖进度 %@",percentString]];
    [attString addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_TITILE range:NSMakeRange(0,4)];
    [attString addAttribute:NSForegroundColorAttributeName value:COLOR_SHINE_BLUE range:NSMakeRange(5,percentString.length)];
    _labelProgress.attributedText = attString;
    [_imageVGoods sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
    
    [_joinList addTarget:self action:@selector(joinListAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)joinListAction {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.model.issueId  forKey:@"issueId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:homeJoinListAction object:nil userInfo:dic];

}


@end
