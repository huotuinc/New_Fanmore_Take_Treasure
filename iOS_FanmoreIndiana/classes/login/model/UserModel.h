//
//  UserModel.h
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/1/22.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdressModel.h"

@interface UserModel : NSObject

@property (nonatomic, assign) BOOL buyAndShare;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL getFromShare;
@property (nonatomic, assign) BOOL hasPassword;
@property (nonatomic, assign) BOOL hasShareRed;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) BOOL mobileBanded;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, assign) BOOL putMoney;
@property (nonatomic, assign) BOOL qqBanded;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, assign) BOOL regSendRed;
@property (nonatomic, strong) NSString *token;
//用户登陆模式 0手机（帐号） 1,2 微信或者QQ
@property (nonatomic, strong) NSNumber *userFormType;
@property (nonatomic, strong) NSString *userHead;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL wexinBanded;
@property (nonatomic, assign) BOOL xiuxiuxiu;
@property (nonatomic, assign) BOOL forIosCheck;




@end
