//
//  AnnouncedCollectionViewCell.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/1.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "AnnouncedBCollectionViewCell.h"
#import "AppNewOpenListModel.h"



@implementation AnnouncedBCollectionViewCell


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
    // Initialization code
    [super awakeFromNib];
    _imageVKind.image=[UIImage imageNamed:@"zhuanqu_a"];
    _imageVGoods.image=[UIImage imageNamed:@"imga"];
    for (int i =0; i <10; i++) {
        UILabel *label= [self viewWithTag:100+i];
        [UILabel changeLabel:label AndFont:22 AndColor:COLOR_TEXT_DATE];
    }
    _labelName.textColor = COLOR_SHINE_BLUE;
    _labelNumber.textColor = COLOR_SHINE_BLUE;
    [self buildViews];
    
}


- (void)defaultConfig {
    
    
}

- (void)buildViews{

}

//@property (nonatomic, strong) NSNumber *attendAmount;
//@property (nonatomic, strong) NSNumber *issueId;
//@property (nonatomic, strong) NSNumber *luckyNumber;
//@property (nonatomic, copy) NSString *	nickName;
//@property (nonatomic, copy) NSString *pictureUrl;
//@property (nonatomic, strong) NSNumber *pid;
//@property (nonatomic, strong) NSNumber *status;
//@property (nonatomic, strong) NSNumber *time;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic) int toAwardingTime;
- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    if ([data isMemberOfClass:[AppNewOpenListModel class]]) {
        
        [self storeWeakValueWithData:data indexPath:indexPath];
        
        AppNewOpenListModel *model = (AppNewOpenListModel*)data;
        [_imageVGoods sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
        _labelItem.text = [NSString stringWithFormat:@"%@",model.issueId];
        _labelName.text = model.nickName;
        _labelName.lineBreakMode = NSLineBreakByTruncatingTail;
        _labelAttend.text = [NSString stringWithFormat:@"%@",model.attendAmount];
        _labelTime.text = [self changeTheTimeStamps:model.time];
        _labelNumber.text = [NSString stringWithFormat:@"%@",model.luckyNumber];
        _labelTitle.text = model.title;
        if ([model.areaAmount isEqualToNumber:@0]) {
            _imageVKind.hidden = YES;
        } else {
            _imageVKind.hidden = NO;
        }
    }
    
}

- (void)drawRect:(CGRect)rect {

}

- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
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
