//
//  HomeCollectionTopCView.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/29.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "HomeCollectionTopCView.h"

@implementation HomeCollectionTopCView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSArray *arrTitle=@[@"分类",@"专区商品",@"红包专区",@"晒单",@"常见问题"];
    for (int i=0 ; i<5 ; i++) {
        UILabel *label=[self viewWithTag:100+i];
        label.text=arrTitle[i];
        [UILabel changeLabel:label AndFont:24 AndColor:COLOR_TEXT_TITILE];
    }
    NSArray *arrImage=@[@"home_content_fenlei",@"home_content_zhuanqu",@"home_content_hongbao",@"home_content_shaidan",@"home_content_wenti"];
    for (int i=0; i<5; i++) {
        UIImageView *imageV=[self viewWithTag:200+i];
        imageV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",arrImage[i]]];
    }
    
    
    
}

@end
