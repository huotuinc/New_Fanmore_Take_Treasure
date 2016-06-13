//
//  RecordCell.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/2/23.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RecordCell.h"
#import <UIImageView+WebCache.h>

@implementation RecordCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RaiderModel *)model {
    _model = model;
    [self.picture sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:nil];
    self.name.text = model.title;
    self.issueLabel.text = [NSString stringWithFormat:@"期号：%@", model.issueId];
    self.toAmountLabel.text = [NSString stringWithFormat:@"总需：%@人次", model.toAmount];
    self.attendLabel.text = [NSString stringWithFormat:@"%@", model.attendAmount];
    self.winnerName.text = model.winner;
    self.winnerAmount.text = [NSString stringWithFormat:@"%@", model.winnerAttendAmount];
    self.lucky.text = [NSString stringWithFormat:@"%@", model.lunkyNumber];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.awardingDate doubleValue]];
//    NSString *temp = [formatter stringFromDate:date];
//    self.time.text = temp;
    self.time.text = [self changeTheTimeStamps:model.awardingDate];
}

/**
 *  13位时间戳转为正常时间(可设置样式)
 *
 *  @param time 时间戳
 *
 *  @return
 */
-(NSString *)changeTheTimeStamps:(NSNumber *)time{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将13位时间戳转为正常时间格式
    NSString * str = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000]];
    return str;
}

@end
