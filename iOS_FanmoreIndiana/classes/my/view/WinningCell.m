//
//  WinningCell.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/1/29.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "WinningCell.h"
#import <UIImageView+WebCache.h>

@implementation WinningCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.confirm.layer.cornerRadius = 5; 
}

- (void)setModel:(WinningModel *)model {
    _model = model;
    [self.Image sd_setImageWithURL:[NSURL URLWithString:model.defaultPictureUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:nil];
    self.name.text = model.title;
    self.joinId.text = [NSString stringWithFormat:@"参与期号：%@", model.issueId];
    self.person.text = [NSString stringWithFormat:@"总需：%@", model.toAmount];
    self.luckyNum.text = [NSString stringWithFormat:@"幸运号码：%@", model.luckyNumber];
    self.joinCount.text = [NSString stringWithFormat:@"本期参与：%@人次", model.amount];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.awardingDate longLongValue] / 1000];
    self.time.text = [NSString stringWithFormat:@"揭晓时间：%@",[formatter stringFromDate:date]];
}


@end
