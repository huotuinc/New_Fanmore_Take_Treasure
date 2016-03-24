//
//  RedPacketCell.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/2/2.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RedPacketCell.h"

@implementation RedPacketCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RedPacketsModel *)model {
    _model = model;
    self.minus.text = [NSString stringWithFormat:@"%@",model.minusMoney];
    self.full.text = [NSString stringWithFormat:@"满%@元使用", model.fullMoney];
    if (model.redPacketType != 1) {
        self.full.hidden = YES;
    }else {
        self.full.hidden = NO;
    }
    self.titleName.text = model.title;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *start = [NSDate dateWithTimeIntervalSince1970:[model.startTime doubleValue] / 1000];
    self.start.text =[NSString stringWithFormat:@"生效期：%@",[formatter stringFromDate:start]];
    
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[model.endTime doubleValue] / 1000];
    self.end.text = [NSString stringWithFormat:@"有效期：%@", [formatter stringFromDate:endTime]];
    
    self.remark.text = model.remark;
}

- (void)setSelectMark:(NSInteger)selectMark {
    _selectMark = selectMark;
    if (selectMark == 0) {
        self.endImage.hidden = YES;
        self.redPacket.image = [UIImage imageNamed:@"hb_red"];
    }else {
        self.redPacket.image = [UIImage imageNamed:@"hb_gray"];
        self.endImage.hidden = NO;
    }
}

@end
