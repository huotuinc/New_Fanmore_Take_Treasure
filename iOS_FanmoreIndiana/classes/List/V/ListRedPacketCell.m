//
//  RedPacketCell.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/2/2.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ListRedPacketCell.h"
@implementation ListRedPacketCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [_buttonSelect setBackgroundImage:[UIImage imageNamed:@"recharge_icon_choose_none"] forState:UIControlStateNormal];
    
    [_buttonSelect setBackgroundImage:[UIImage imageNamed:@"recharge_icon_choose"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RedPacketsModel *)model {
    _model = model;
    self.minus.text = [NSString stringWithFormat:@"%@",model.minusMoney];
    self.full.text = [NSString stringWithFormat:@"满%@元使用", model.fullMoney];
    self.titleName.text = model.title;
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
//    NSDate *start = [NSDate dateWithTimeIntervalSince1970:[model.startTime doubleValue]];
    NSString *str1 = [self changeTheTimeStamps:model.startTime];
    self.start.text =[NSString stringWithFormat:@"生效期：%@",str1];
    NSString *str2 = [self changeTheTimeStamps:model.endTime];
    self.end.text = [NSString stringWithFormat:@"有效期：%@",str2];
    
    self.remark.text = model.remark;
}

- (void)setSelectMark:(NSInteger)selectMark {
//    _selectMark = selectMark;
//    if (selectMark == 0) {
//        self.endImage.hidden = YES;
//    }else {
//        self.redPacket.image = [UIImage imageNamed:@"hb_gray"];
//        self.endImage.hidden = NO;
//    }
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
