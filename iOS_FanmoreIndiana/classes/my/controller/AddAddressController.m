//
//  AddAddressController.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/2/18.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "AddAddressController.h"
#import <UIBarButtonItem+BlocksKit.h>
@interface AddAddressController ()

@end

@implementation AddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        [self addNewAddress];
    }];

}

- (void)addNewAddress {
    if (_personName.text == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
    }else if (_personIphone.text == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
    }else if (_detailAddress.text == nil) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
    }else {
        if ([self checkTel:_personIphone.text]) {
            
            [self postAddressToServer];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        }
    }
}

- (void)postAddressToServer {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"receiver"] = self.personName.text;
    dic[@"mobile"] = self.personIphone.text;
    dic[@"details"] = self.detailAddress.text;
    dic[@"defaultAddress"] = @(self.defaultAddress.on);
    
    [UserLoginTool loginRequestPostWithFile:@"addMyAddress" parame:dic success:^(id json) {
        LWLog(@"%@",json);
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
    } withFileKey:nil];
}


/**
 *  验证手机号的正则表达式
 */
-(BOOL) checkTel:(NSString *) phoneNumber{
    NSString *regex = @"^(1)\\d{10}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
