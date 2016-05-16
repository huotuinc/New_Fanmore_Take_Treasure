//
//  LoginController.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/1/19.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "LoginController.h"
#import <UIBarButtonItem+BlocksKit.h>
#import <ShareSDK/ShareSDK.h>
#import <SVProgressHUD.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "MD5Encryption.h"
#import <MJExtension.h>
#import "TabBarController.h"
#import "AppDelegate.h"
#import "ArchiveLocalData.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#import "HTUserModel.h"
@interface LoginController ()<UITextFieldDelegate>

@end

@implementation LoginController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.title = @"登录";
    
    self.weixinLogin.hidden = ![WXApi isWXAppInstalled];
    self.qqLogin.hidden = ![TencentOAuth iphoneQQInstalled];
    
    self.userName.delegate = self;
    self.password.delegate = self;

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        TabBarController *login = app.tabbar;
//        login.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:CannelLoginFailure object:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    self.login.layer.cornerRadius = 5;
    
    self.phoneRegister.layer.borderWidth = 1;
    self.phoneRegister.layer.borderColor = [UIColor redColor].CGColor;
    self.phoneRegister.layer.cornerRadius = 5;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.userName resignFirstResponder];
    
    [self.password resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userNameAndPasswordLogin:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.userName.text.length != 0 && self.password.text.length != 0) {
        
        if (self.password.text.length < 6 || self.password.text.length > 16) {
            [SVProgressHUD showErrorWithStatus:@"密码长度6-16位"];
        }else {
        
            dic[@"username"] = self.userName.text;
            
            dic[@"password"] = [MD5Encryption md5by32:self.password.text];
        
            [SVProgressHUD showWithStatus:@"登录中"];
            [UserLoginTool loginRequestGet:@"login" parame:dic success:^(id json) {
            
                LWLog(@"%@",json);
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
                    [SVProgressHUD dismiss];
                    [self loginSuccessWith:json[@"resultData"]];
                }else {
                    [SVProgressHUD showErrorWithStatus:json[@"resultDescription"]];
                }
            
            } failure:^(NSError *error) {
            
                LWLog(@"%@",error);
            
            }];
        }
    }
    
    
}

- (IBAction)loginWithWeixin:(id)sender {
    
    self.weixinLogin.userInteractionEnabled = NO;
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            LWLog(@"%@",user);
            
            NSString *unionid = [user.rawData objectForKey:@"unionid"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"username"] = user.nickname;
            dic[@"unionId"] = unionid;
            dic[@"head"] = user.icon;
            dic[@"type"] = @"1";
            
            [SVProgressHUD showWithStatus:@"登录中"];
            
            [UserLoginTool loginRequestGet:@"authLogin" parame:dic success:^(id json) {
                LWLog(@"%@",json);
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
                    [self loginSuccessWith:json[@"resultData"]];
                }
                [SVProgressHUD dismiss];
            } failure:^(NSError *error) {
                LWLog(@"%@",error);
                [SVProgressHUD dismiss];
                self.weixinLogin.userInteractionEnabled = YES;
            }];
            
        }else {
            self.weixinLogin.userInteractionEnabled = YES;
            LWLog(@"%@",error);
        }
    }];
    
    
}

- (IBAction)loginWithQQ:(id)sender {
    
    self.qqLogin.userInteractionEnabled = NO;
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            LWLog(@"%@",user);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"username"] = user.nickname;
            dic[@"unionId"] = user.uid;
            dic[@"head"] = user.icon;
            dic[@"type"] = @"2";
            
            [SVProgressHUD showWithStatus:@"登录中"];
            [UserLoginTool loginRequestGet:@"authLogin" parame:dic success:^(id json) {
                LWLog(@"%@",json);
                if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
                    [self loginSuccessWith:json[@"resultData"]];
                }
                [SVProgressHUD dismiss];
            } failure:^(NSError *error) {
                LWLog(@"%@",error);
                [SVProgressHUD dismiss];
                self.weixinLogin.userInteractionEnabled = YES;
            }];
        }else {
            self.qqLogin.userInteractionEnabled = YES;
        }
    }];
    
}

- (void)loginSuccessWith:(NSDictionary *) dic {
    
    UserModel *user = [UserModel mj_objectWithKeyValues:dic[@"user"]];
//    NSLog(@"userModel: %@",user);
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:UserInfo];
    [NSKeyedArchiver archiveRootObject:user toFile:fileName];
    [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
    //app是否在审核
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",user.forIosCheck] forKey:AppExamine];
    LWLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:AppExamine]);
    //保存新的token
    [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:AppToken];
    //购物车结算登陆时 需要提交数据
    [self postDataToServe];
    [self dismissViewControllerAnimated:YES completion:nil];
    /**
     *  //////
     */
    AdressModel *address = [AdressModel mj_objectWithKeyValues:dic[@"user"][@"appMyAddressListModel"]];
    NSString *fileNameAdd = [path stringByAppendingPathComponent:DefaultAddress];
    [NSKeyedArchiver archiveRootObject:address toFile:fileNameAdd];
    
    if (self.isFromMall) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginFromMallNot object:nil];
    }
    
    
}
#pragma mark 未登录提交购物车
- (void)postDataToServe {
    NSArray *cartArray = [NSArray arrayWithArray:[ArchiveLocalData unarchiveLocalDataArray]];
    NSMutableString *AllCartsString = [NSMutableString string];
    for ( int i =0 ; i<cartArray.count; i++) {
        CartModel *model = cartArray[i];
        if (i == cartArray.count - 1) {
            [AllCartsString appendFormat:@"{issueId:%@,amount:%@}",model.issueId,model.userBuyAmount];
        }else{
            [AllCartsString appendFormat:@"{issueId:%@,amount:%@},",model.issueId,model.userBuyAmount];
        }
    }
    [AllCartsString insertString:@"[" atIndex:0];
    [AllCartsString appendString:@"]"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      dic[@"cartsJson"] = AllCartsString;
    [UserLoginTool loginRequestPostWithFile:@"joinAllCartToServer" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            LWLog(@"*****提交数据成功******");
            LWLog(@"%@",json[@"resultDescription"]);
            if ([self.logDelegate respondsToSelector:@selector(tableViewReloadData)]) {
                [self.logDelegate tableViewReloadData];
            }
        }else {
            
            LWLog(@"%@",json[@"resultDescription"]);
        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        
        
    } withFileKey:nil];
    
}


@end
