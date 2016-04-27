//
//  PayController.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/2/16.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "PayController.h"
#import "PayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "payRequsestHandler.h"

@interface PayController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, assign) NSInteger selectPay;

@property (nonatomic, strong) UIButton *selectedPayButton;

@property (nonatomic, strong) PayModel *payModel;

@property(nonatomic,strong) NSMutableString * debugInfo;


@end

@implementation PayController

static NSString *payIdentify = @"payIdentifty";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:payIdentify];
    self.tableView.editing = YES;
    self.tableView.scrollEnabled = NO;
    
    self.verifyPay.layer.cornerRadius = 5;
    
    self.selectPay = 100;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:payMoneySuccess object:nil];
    
    [self _initPayButtons];
    

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
//    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initPayButtons {
    
    self.pay20.layer.borderColor = [UIColor redColor].CGColor;
    self.pay20.layer.borderWidth = 1;
    [self.pay20 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.selectedPayButton = self.pay20; 
    [self.pay20 bk_whenTapped:^{
        [self.pay20 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.pay20.layer.borderColor = [UIColor redColor].CGColor;
        [self.payOther resignFirstResponder];
        self.payOther.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
        self.payOther.textColor = [UIColor colorWithWhite:0.859 alpha:1.000];
        if (self.selectedPayButton != nil) {
            self.selectedPayButton.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
            [self.selectedPayButton setTitleColor:[UIColor colorWithWhite:0.859 alpha:1] forState:UIControlStateNormal];
        }
        self.selectedPayButton = self.pay20;
    }];
    
    
    self.pay50.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
    self.pay50.layer.borderWidth = 1;
    [self.pay50 bk_whenTapped:^{
        [self.pay50 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.pay50.layer.borderColor = [UIColor redColor].CGColor;
        [self.payOther resignFirstResponder];
        self.payOther.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
        self.payOther.textColor = [UIColor colorWithWhite:0.859 alpha:1.000];
        if (self.selectedPayButton != nil) {
            self.selectedPayButton.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
            [self.selectedPayButton setTitleColor:[UIColor colorWithWhite:0.859 alpha:1] forState:UIControlStateNormal];
        }
        self.selectedPayButton = self.pay50;
    }];
    
    self.pay100.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
    self.pay100.layer.borderWidth = 1;
    [self.pay100 bk_whenTapped:^{
        [self.pay100 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.pay100.layer.borderColor = [UIColor redColor].CGColor;
        [self.payOther resignFirstResponder];
        self.payOther.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
        self.payOther.textColor = [UIColor colorWithWhite:0.859 alpha:1.000];
        if (self.selectedPayButton != nil) {
            self.selectedPayButton.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
            [self.selectedPayButton setTitleColor:[UIColor colorWithWhite:0.859 alpha:1] forState:UIControlStateNormal];
        }
        self.selectedPayButton = self.pay100;
    }];
    
    self.pay200.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
    self.pay200.layer.borderWidth = 1;
    [self.pay200 bk_whenTapped:^{
        [self.pay200 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.pay200.layer.borderColor = [UIColor redColor].CGColor;
        [self.payOther resignFirstResponder];
        self.payOther.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
        self.payOther.textColor = [UIColor colorWithWhite:0.859 alpha:1.000];
        if (self.selectedPayButton != nil) {
            self.selectedPayButton.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
            [self.selectedPayButton setTitleColor:[UIColor colorWithWhite:0.859 alpha:1] forState:UIControlStateNormal];
        }
        self.selectedPayButton = self.pay200;
    }];
    
    self.pay500.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
    self.pay500.layer.borderWidth = 1;
    [self.pay500 bk_whenTapped:^{
        [self.pay500 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.pay500.layer.borderColor = [UIColor redColor].CGColor;
        [self.payOther resignFirstResponder];
        self.payOther.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
        self.payOther.textColor = [UIColor colorWithWhite:0.859 alpha:1.000];
        if (self.selectedPayButton != nil) {
            self.selectedPayButton.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
            [self.selectedPayButton setTitleColor:[UIColor colorWithWhite:0.859 alpha:1] forState:UIControlStateNormal];
        }
        self.selectedPayButton = self.pay500;
    }];
    
    self.payOther.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
    self.payOther.layer.borderWidth = 1;
    self.payOther.delegate = self;
    
    
}

#pragma mark textField 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.payOther.layer.borderColor = [UIColor redColor].CGColor;
    self.payOther.textColor = [UIColor redColor];
    self.selectedPayButton.layer.borderColor = [UIColor colorWithWhite:0.859 alpha:1.000].CGColor;
    [self.selectedPayButton setTitleColor:[UIColor colorWithWhite:0.859 alpha:1] forState:UIControlStateNormal];
    self.selectedPayButton = nil;
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.payOther resignFirstResponder];
}


#pragma mark tabViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO];
        self.selectPay = indexPath.row;
    }else {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
        self.selectPay = indexPath.row;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectPay) {
        self.selectPay = 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payIdentify forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"微信支付";
    }else {
        cell.textLabel.text = @"支付宝";
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (IBAction)verifyPayAction:(id)sender {
    
    
    if (self.selectPay != 100) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (self.selectedPayButton) {
            dic[@"money"] = self.selectedPayButton.titleLabel.text;
        }else {
            if ([self.payOther.text intValue] > 0) {
                dic[@"money"] = self.payOther.text;
            }else {
                [SVProgressHUD showErrorWithStatus:@"输入金额必须为大于0"];
                return;
            }
            
        }
        dic[@"payType"] = @(self.selectPay);
        
        [UserLoginTool loginRequestGet:@"putMoney" parame:dic success:^(id json) {
//            LWLog(@"%@",json);
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
                self.payModel = [PayModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
                
                if (self.selectPay == 0) {
                    /**
                     *  微信
                     */
                    
                    [self WeiChatPay];
                }
                
                if (self.selectPay == 1) {
                    /**
                     *  支付宝
                     */
                    [self PayByAlipay];
                }
                
            }
        } failure:^(NSError *error) {
//            LWLog(@"%@",error);
        }];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
    }
    
    
    
}


/**
 *  action sheet
 *
 *  @param actionSheet
 *  @param buttonInde
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self PayByAlipay]; // 支付宝
    }
    if (buttonIndex == 1) {
        [self WeiChatPay]; // 微信支付
    }
}

/**
 *  支付宝
 */
- (void)PayByAlipay{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = AliPayPid;
    NSString *seller = AliPayPid;
    //私营
    NSString *privateKey = AliPayKey;
    //公钥
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.payModel.orderNo; //订单ID（由商家自行制定）
    order.productName = @"粉猫夺宝充值"; //商品标题
    order.productDescription = self.payModel.detail; //商品描述
    order.amount = self.payModel.alipayFee ; //商品价格
    order.notifyURL =  self.payModel.alipayCallbackUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"qibinTreasure2016";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    LWLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            LWLog(@"reslut = %@",resultDic);
           if([resultDic[@"resultStatus"] intValue] == 9000){
               [self updateUserInfo];
           }
        }];
    }
    
}






/**
 *  微信pay
 */
- (void)WeiChatPay{
    
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [self PayByWeiXinParame];
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }else{
//                        LWLog(@"提示信息%@",[dict objectForKey:@"retmsg"]);
        }
        
    }else{
//                LWLog(@"提示信息返回错误");
        
    }
    
    
}
/**
 *  微信支付预zhifu
 */
- (NSMutableDictionary *)PayByWeiXinParame{
    
    payRequsestHandler * payManager = [[payRequsestHandler alloc] init];
    [payManager setKey:wxpayKey];
    BOOL isOk = [payManager init:WeiXinPayId mch_id:WeiXinPayMerchantId];
    if (isOk) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        params[@"appid"] = WeiXinPayId;
        params[@"mch_id"] = WeiXinPayMerchantId;     //微信支付分配的商户号
        
        //商品价格
        
//        NSString * a  = [NSString stringWithFormat:@"%d", [self.payModel.fee intValue] * 100];
//        NSString *a = [self.payModel.fee stringValue];
        //商品价格
        
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = self.payModel.detail; //商品或支付单简要描述
        
        params[@"notify_url"] = self.payModel.wxCallbackUrl;  //接收微信支付异步通知回调地址
        
        params[@"out_trade_no"] = [NSString stringWithFormat:@"%@", self.payModel.orderNo]; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        
        
        
        
        params[@"total_fee"] = self.payModel.wxFee;  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = DeviceNo;
        
        
        
        //        params[@"sign"] = [payManager createMd5Sign:params];
        
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
        
//        LWLog(@"xcaccasc%@",[payManager getDebugifo]);
        if ( prePayid != nil) {
            //获取到prepayid后进行第二次签名
            
            NSString    *package, *time_stamp, *nonce_str;
            //设置支付参数
            time_t now;
            time(&now);
            time_stamp  = [NSString stringWithFormat:@"%ld", now];
            nonce_str	= [WXUtil md5:time_stamp];
            //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
            //package       = [NSString stringWithFormat:@"Sign=%@",package];
            package         = @"Sign=WXPay";
            //第二次签名参数列表
            NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
            [signParams setObject: WeiXinPayId  forKey:@"appid"];
            [signParams setObject: nonce_str    forKey:@"noncestr"];
            [signParams setObject: package      forKey:@"package"];
            [signParams setObject: WeiXinPayMerchantId   forKey:@"partnerid"];
            [signParams setObject: time_stamp   forKey:@"timestamp"];
            [signParams setObject: prePayid     forKey:@"prepayid"];
            //[signParams setObject: @"MD5"       forKey:@"signType"];
            //生成签名
            NSString *sign  = [payManager createMd5Sign:signParams];
            
            //添加签名
            [signParams setObject: sign         forKey:@"sign"];
            
            [_debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
            
            //返回参数列表
            return signParams;
            
        }else{
            [_debugInfo appendFormat:@"获取prepayid失败！\n"];
        }
        
    }
    return nil;
}


#pragma mark 支付成功刷新用户数据
- (void)updateUserInfo {
    
    [SVProgressHUD showSuccessWithStatus:@"充值成功，积分将在10分钟左右到账，可去积分商城兑换"];
    
    [UserLoginTool loginRequestPostWithFile:@"updateUserInformation" parame:nil success:^(id json) {
//        LWLog(@"%@", json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
            [self loginSuccessWith:json[@"resultData"]];
        }else {
            [SVProgressHUD showErrorWithStatus:json[@"resultDescription"]];
        }
    } failure:^(NSError *error) {
        
    } withFileKey:nil];
    
}



//刷新用户数据
- (void)loginSuccessWith:(NSDictionary *) dic {
    
    UserModel *user = [UserModel mj_objectWithKeyValues:dic[@"user"]];
//    LWLog(@"userModel: %@",user);
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:UserInfo];
    [NSKeyedArchiver archiveRootObject:user toFile:fileName];
    [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
    //保存新的token
    [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:AppToken];
    
    AdressModel *address = [AdressModel mj_objectWithKeyValues:dic[@"user"][@"appMyAddressListModel"]];
    NSString *fileNameAdd = [path stringByAppendingPathComponent:DefaultAddress];
    [NSKeyedArchiver archiveRootObject:address toFile:fileNameAdd];
}




@end
