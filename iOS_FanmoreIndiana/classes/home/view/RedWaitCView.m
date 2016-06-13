//
//  RedWaitCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/10.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RedWaitCView.h"
#import "AppRedPactketsDistributeSourceModel.h"
@implementation RedWaitCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewBase.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
    [UILabel changeLabel:_labelRest AndFont:30 AndColor:[UIColor whiteColor]];
    [UILabel changeLabel:_labelTime AndFont:30 AndColor:[UIColor whiteColor]];
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

- (void)loadData:(id)data{
    
    if ([data isMemberOfClass:[AppRedPactketsDistributeSourceModel class]]) {
        
        [self storeWeakValueWithData:data];
        
        AppRedPactketsDistributeSourceModel *model = (AppRedPactketsDistributeSourceModel*)data;
        
        _labelTime.attributedText = [[NSAttributedString alloc] initWithAttributedString:[model WaitCurrentTimeString]];
        if ([_labelTime.text isEqualToString:@"本期活动已开始"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACTIVITY_START object:nil];
        }
//        NSLog(@"%@",_labelTime.text);
    }
    
}
- (void)storeWeakValueWithData:(id)data{
    
    self.m_data         = data;
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AnotificationCenterEvent:)
                                                 name:NOTIFICATION_RED_WAIT
                                               object:nil];
}


- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_RED_WAIT object:nil];
}

- (void)AnotificationCenterEvent:(id)sender {
    
    [self loadData:self.m_data];
}

@end
