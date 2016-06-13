//
//  DetailTimeCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/26.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailTimeCView.h"
#import "AppGoodsDetailModel.h"
@implementation DetailTimeCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewBase.backgroundColor=COLOR_BUTTON_ORANGE;
//    [UIButton changeButton:_buttonDetail AndFont:17 AndTitleColor:[UIColor whiteColor] AndBackgroundColor:[UIColor clearColor] AndBorderColor:[UIColor whiteColor] AndCornerRadius:3 AndBorderWidth:1];
    for (int i =0; i < 4; i++) {
        UILabel *label=[self viewWithTag:100 +i];
        [UILabel changeLabel:label AndFont:26 AndColor:[UIColor whiteColor]];
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

- (void)loadData:(id)data{
    
    if ([data isMemberOfClass:[AppGoodsDetailModel class]]) {
        
        [self storeWeakValueWithData:data];
        
        AppGoodsDetailModel *model = (AppGoodsDetailModel*)data;
        
        _labelIssueA.text=[NSString stringWithFormat:@"%@",model.issueId];
        _labelEndTimeA.text = [NSString stringWithFormat:@"%@",[model currentTimeString]];
    }
    
}
- (void)storeWeakValueWithData:(id)data{
    
    self.m_data         = data;
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_COUNT_TIME
                                               object:nil];
}


- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_COUNT_TIME object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    [self loadData:self.m_data];
}

@end
