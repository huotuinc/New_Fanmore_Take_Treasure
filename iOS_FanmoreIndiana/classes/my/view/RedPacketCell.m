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
    [super awakeFromNib];
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

    self.start.text =[self changeTheTimeStamps:model.startTime];
    
    self.end.text = [self changeTheTimeStamps:model.endTime];
    
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
