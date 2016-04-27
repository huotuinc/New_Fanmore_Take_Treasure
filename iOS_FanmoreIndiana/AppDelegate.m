//
//  AppDelegate.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/1/11.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalModel.h"
#import "NSData+NSDataDeal.h"
#import "UIViewController+MonitorNetWork.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <AlipaySDK/AlipaySDK.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self _initShare];
    
    [UserLoginTool loginRequestGet:@"init" parame:nil success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
            GlobalModel *global = [GlobalModel mj_objectWithKeyValues:json[@"resultData"][@"global"]];
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [path stringByAppendingPathComponent:GlobalInfo];
            [NSKeyedArchiver archiveRootObject:global toFile:fileName];
            
            if (![json[@"resultData"][@"user"] isKindOfClass:[NSNull class]]) {
                
                UserModel *user = [UserModel mj_objectWithKeyValues:json[@"resultData"][@"user"]];
//                NSLog(@"userModel: %@",user);
                
                NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *fileName = [path stringByAppendingPathComponent:UserInfo];
                [NSKeyedArchiver archiveRootObject:user toFile:fileName];
                //保存新的token
                [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:AppToken];
                
                AdressModel *address = [AdressModel mj_objectWithKeyValues:json[@"resultData"][@"user"][@"addressModel"]];
                NSString *fileNameAdd = [path stringByAppendingPathComponent:DefaultAddress];
                [NSKeyedArchiver archiveRootObject:address toFile:fileNameAdd];
                
                
            }else {
                [UIViewController ToRemoveSandBoxDate];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [self registRemoteNotification:application];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveReadNewMessage) name:HaveNotReadMessage object:nil];
    
    
    if (launchOptions != nil) {
        
        NSDictionary *dicRemote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dicRemote) {
            
        }
    }
    
#pragma mark 处理通知
    
    if (launchOptions) {
        NSDictionary *dicRemote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dicRemote) {
            if (IsIos8) {
#warning 处理通知
            }
        }
    }
    
    [self resetUserAgent];
    
    return YES;
}

/**
 *  app后台唤醒调用的方法
 *
 *  @param application
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //从后台进入程序时调用
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BECOME_ACTIVE object:nil];
    
}


/**
 *  阅读新消息后的方法
 *
 *  @param application application description
 */
- (void)haveReadNewMessage {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)_initShare {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:ShareSDKAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:XinLangAppkey
                                           appSecret:XinLangAppSecret
                                         redirectUri:XinLangRedirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeiXinAppID
                                       appSecret:WeiXinAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQAppKey
                                      appKey:QQappSecret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

/**
 *  注册远程通知
 */
- (void)registRemoteNotification:(UIApplication *)application{
    if (IsIos8) { //iOS 8 remoteNotification
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeNewsstandContentAvailability;
        [application registerForRemoteNotificationTypes:type];
        
    }
}

/**
 *  ios8
 *
 *  @param application          <#application description#>
 *  @param notificationSettings <#notificationSettings description#>
 */
-(void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
        [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
        LWLog(@"注册推送服务时，发生以下错误： %@",error.description);
}

/**
 *  获取deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //    NSLog(@"%@",deviceToken);
    NSString * aa = [deviceToken hexadecimalString] ;
    //    NSString * urlstr = [MainUrl stringByAppendingPathComponent:@"updateDeviceToken"];
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"deviceToken"] = aa;
        LWLog(@"deviceToken===%@",aa);
    [UserLoginTool loginRequestGet:@"updateDeviceToken" parame:parame success:^(id json) {
        LWLog(@"推送通知deviceToken成功 %@", json[@"resultDescription"]);
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 *  iOS7收到推送后的处理
 *
 *  @param application <#application description#>
 *  @param userInfo    <#userInfo description#>
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}


/**
 *  app 回调
 *
 *  @param application <#application description#>
 *  @param url         <#url description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}



/**
 *  支付宝成功回调
 *
 *  @param application       application description
 *  @param url               url description
 *  @param sourceApplication sourceApplication description
 *  @param annotation        annotation description
 *
 *  @return return value description
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    LWLog(@"openURL:%@" ,url.absoluteURL);
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"resultStatus = %@",resultDic[@"resultStatus"]);
            if([resultDic[@"resultStatus"] intValue] == 9000){
                
//                NSLog(@"跳转支付宝钱包进行支付，处理支付结果跳转支付宝钱包进行支付，处理支付结果");
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:payMoneySuccess object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:payMoneySuccessView object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:canSendRedPocketOrNot object:nil];

            }
        }];
    }
    
    
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    
    LWLog(@"openURL:%@" ,url.absoluteURL);
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
            if([resultDic[@"resultStatus"] intValue] == 9000){
//                NSLog(@"跳转支/付宝钱包进行支付，处理支付结果跳转支付宝钱包进行支付，处理支付结果");

                [[NSNotificationCenter defaultCenter] postNotificationName:payMoneySuccess object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:payMoneySuccessView object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:canSendRedPocketOrNot object:nil];


            }
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

/**
 *  微信支付回调方法
 *
 *  @param resp resp description
 */
- (void)onResp:(BaseResp *)resp {

    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                
                [[NSNotificationCenter defaultCenter] postNotificationName:payMoneySuccess object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:payMoneySuccessView object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:canSendRedPocketOrNot object:nil];
                break;
            default:

                break;
        }
    }
}


- (void)pushRedPacketNotifation {
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //进入后台时调用
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESIGN_ACTIVE object:nil];
}


- (void) resetUserAgent {
    
    
    // Do any additional setup after loading the view, typically from a nib.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *Agent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    
    //add my info to the new agent
    NSString *newAgent = nil;
    
    newAgent = [Agent stringByAppendingString:@";mobile;qibing"];
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    
}


@end
