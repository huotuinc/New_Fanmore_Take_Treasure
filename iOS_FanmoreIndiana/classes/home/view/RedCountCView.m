//
//  RedCountCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/8.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RedCountCView.h"
#import "AppRedPactketsDistributeSourceModel.h"
@implementation RedCountCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [UILabel changeLabel:_labelAA AndFont:30 AndColor:COLOR_PROGRESS_A];[UILabel changeLabel:_labelAA AndFont:30 AndColor:COLOR_PROGRESS_A];
    [UILabel changeLabel:_labelBB AndFont:30 AndColor:COLOR_PROGRESS_A];
    [UILabel changeLabel:_labelTimeA AndFont:30 AndColor:COLOR_PROGRESS_A];
    
    for (int i = 0 ; i<6; i++) {
        UILabel *label = [self viewWithTag:100 +i];
        [UILabel changeLabel:label AndFont:30 AndColor:COLOR_TEN_RED];
        label.layer.cornerRadius = 3;
        label.backgroundColor = COLOR_PROGRESS_A;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)defaultConfig {
    
    [self registerNSNotificationCenter];
    
}

- (void)buildViews{
    
}

- (void)loadCountData:(id)data {
    if ([data isMemberOfClass:[AppRedPactketsDistributeSourceModel class]]) {
        
        [self storeWeakValueWithData:data];
        
        AppRedPactketsDistributeSourceModel *model = (AppRedPactketsDistributeSourceModel*)data;
        NSInteger A = model.amount / 100000;
        NSInteger B = model.amount / 10000 % 10;
        NSInteger C = model.amount / 1000  % 10;
        NSInteger D = model.amount / 100   % 10;
        NSInteger E = model.amount / 10    % 10;
        NSInteger F = model.amount / 1     % 10;
        
        _labelA.text = [NSString stringWithFormat:@"%ld",A];
        _labelB.text = [NSString stringWithFormat:@"%ld",B];
        _labelC.text = [NSString stringWithFormat:@"%ld",C];
        _labelD.text = [NSString stringWithFormat:@"%ld",D];
        _labelE.text = [NSString stringWithFormat:@"%ld",E];
        _labelF.text = [NSString stringWithFormat:@"%ld",F];

        _labelTimeA.text = [model EndCurrentTimeString];
        if ([_labelTimeA.text isEqualToString:@"本期活动已结束"]) {
            LWLog(@"结束啦啦啦啦啦啦啦啦啦啦");
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACTIVITY_END object:nil];
        }
    }
    
}
- (void)storeWeakValueWithData:(id)data{
    
    self.m_dataA         = data;
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(EndAnotificationCenterEvent:)
                                                 name:NOTIFICATION_RED_END
                                               object:nil];
}


- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RED_END object:nil];
}

- (void)EndAnotificationCenterEvent:(id)sender {
    
    [self loadCountData:self.m_dataA];
}

@end
