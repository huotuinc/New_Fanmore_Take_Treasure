//
//  AnnouncedCollectionViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/1.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "AnnouncedCollectionViewCell.h"
#import "AppNewOpenListModel.h"



@implementation AnnouncedCollectionViewCell


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        [self defaultConfig];
//        
//        [self buildViews];
//    }
//    
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageVKind.image=[UIImage imageNamed:@"zhuanqu_a"];
    _imageVGoods.image=[UIImage imageNamed:@"imga"];
    _imageVNotice.image=[UIImage imageNamed:@"main_jiexiao"];
    [UILabel changeLabel:_labelTitle AndFont:24 AndColor:COLOR_TEXT_CONTENT];
    [UILabel changeLabel:_labelItem AndFont:22 AndColor:COLOR_TEXT_DATE];
    [UILabel changeLabel:_labelAnnounce AndFont:24 AndColor:COLOR_BUTTON_ORANGE];
    [UILabel changeLabel:_labelTime AndFont:58 AndColor:COLOR_BUTTON_ORANGE];
    [self defaultConfig];
    
    [self buildViews];
    
}

- (void)defaultConfig {
    
    [self registerNSNotificationCenter];
    
}

- (void)buildViews{

}


- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    if ([data isMemberOfClass:[AppNewOpenListModel class]]) {
        
        [self storeWeakValueWithData:data indexPath:indexPath];
        
        AppNewOpenListModel *model = (AppNewOpenListModel*)data;
        [_imageVGoods sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
        _labelTitle.text = model.title;
        _labelItem.text  = [NSString stringWithFormat:@"期号 : %@",[model issueId]];
        _labelTime.text = [NSString stringWithFormat:@"%@",[model currentTimeString]];
        if ([model.areaAmount isEqualToNumber:@0]) {
            _imageVKind.hidden = YES;
        }
        
        
    }
    
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}
- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
}

- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
    }
}



@end
