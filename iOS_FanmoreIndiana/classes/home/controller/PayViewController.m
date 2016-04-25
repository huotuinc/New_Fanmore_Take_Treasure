//
//  PayViewController.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/24.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "PayViewController.h"
#import "PayATableViewCell.h"
#import "PayBTableViewCell.h"
#import "PayButtonTableViewCell.h"
#import "AppPayModel.h"
#import "UserModel.h"
#import "TabBarController.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import "TabBarController.h"
#import "AppPayResultModel.h"
#import "PayWebViewController.h"

static NSString *cellPA=@"cellPA";
static NSString *cellPB=@"cellPB";
static NSInteger _whichPay ;  //支付类型 0微信 1支付宝 2用户余额
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) PayButtonTableViewCell *payView;

@property (nonatomic,strong) UserModel *userInfo;

@property (nonatomic,strong) AppPayModel *payBackModel;

@property(nonatomic,strong) NSMutableString * debugInfo;

@property (nonatomic,strong) UIAlertView *payAlertView;

@property (nonatomic,strong) AppPayResultModel *payResulModel;


@property(nonatomic) BOOL AliPayDone;
@property(nonatomic) BOOL WeiPayDone;



@end

@implementation PayViewController{
    NSMutableArray *_titleArray;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.hidden = YES;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationItem changeNavgationBarTitle:@"支付订单"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * appExamineString = [[NSUserDefaults standardUserDefaults] stringForKey:AppExamine];
    if ([appExamineString isEqualToString:@"1"]) {
        _whichPay = 1;
    } else {
        _whichPay = 2;
    }

    _AliPayDone = NO;
    _WeiPayDone = NO;
    
    
    if ([appExamineString isEqualToString:@"1"]) {
        if ([WXApi isWXAppInstalled]) {
            _titleArray = [NSMutableArray arrayWithArray:@[@"红包折扣",@"余额支付",@"其他支付方式",@"微信支付",@"支付宝支付"]];
        }else {
            _titleArray = [NSMutableArray arrayWithArray:@[@"红包折扣",@"余额支付",@"其他支付方式",@"支付宝支付"]];
        }
    } else {
        if ([WXApi isWXAppInstalled]) {
            _titleArray = [NSMutableArray arrayWithArray:@[@"红包折扣",@"余额支付",@"其他支付方式",@"微信支付",@"支付宝支付",@"余额支付"]];
        }else {
            _titleArray = [NSMutableArray arrayWithArray:@[@"红包折扣",@"余额支付",@"其他支付方式",@"支付宝支付",@"余额支付"]];
        }
    }

    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payUpdateUserInfo) name:payMoneySuccess object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessNotice) name:payMoneySuccessView object:nil];

    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:UserInfo];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    [self createBarButtonItem];
    [self createPayView];
    [self createTableView];
}
#pragma mark  网络支付

-(void)paySuccessOrFail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"payType"] = [NSString stringWithFormat:@"%ld",(long)_whichPay];
    dic[@"redPacketsId"] = _payModel.redPacketsId;
    dic[@"carts"] = self.cartString;
    dic[@"allPay"] = @0;
//    dic[@"redPacketsId"] = nil;
    CGFloat payMoney = [_payModel.totalMoney floatValue] - [_payModel.redPacketsMinusMoney floatValue];
    dic[@"money"] = [NSNumber numberWithFloat:payMoney];
    [UserLoginTool loginRequestPostWithFile:@"pay" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            LWLog(@"%@",json[@"resultDescription"]);
            //支付类型 0微信 1支付宝 2用户余额
            if (_whichPay == 2) {
                
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                _payView.buttonPay.userInteractionEnabled = YES;
                [self payUpdateUserInfo];
//                [self paySuccessNotice];

                
            }
            if (_whichPay == 1) {
                _payBackModel = [AppPayModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
                NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
                if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
                    //没有安装支付宝 需要跳到网页完成支付
                    [self PayByAliWebview];
                } else {
                    //用户已安装支付宝 调用app完成支付
                    [self PayByAlipay];

                }
                [self createPayAlertView];


            }
            if (_whichPay == 0) {
                _WeiPayDone = YES;
                _payBackModel = [AppPayModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
                [self WeiChatPay];
                [self createPayAlertView];

            }

        }else {
            LWLog(@"%@",json[@"resultDescription"]);
            [SVProgressHUD showErrorWithStatus:json[@"resultDescription"]];
            _payView.buttonPay.userInteractionEnabled = YES;
        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
        _payView.buttonPay.userInteractionEnabled = YES;

        
        
    } withFileKey:nil];
    
    
}
//- (void)remainPay {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"orderNo"] = _payBackModel.orderNo;
//    dic[@"money"] = self.payBackModel.alipayFee;
//    [UserLoginTool loginRequestPostWithFile:@"remainPay" parame:dic success:^(id json) {
//        LWLog(@"%@",json);
//        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
//            LWLog(@"%@",json[@"resultDescription"]);
//            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
//            _payView.buttonPay.userInteractionEnabled = YES;
//            [self payUpdateUserInfo];
////            [self paySuccessNotice];
//            
//        }else {
//            LWLog(@"%@",json[@"resultDescription"]);
//            _payView.buttonPay.userInteractionEnabled = YES;
//            [SVProgressHUD showErrorWithStatus:@"支付失败"];
//
//        }
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(paySuccessed) userInfo:nil repeats:NO];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//        
//        
//        
//    } failure:^(NSError *error) {
//        LWLog(@"%@",error);
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
//        _payView.buttonPay.userInteractionEnabled = YES;
//        
//    } withFileKey:nil];
//
//
//}
- (void)paySuccessed{
    [[NSNotificationCenter defaultCenter]postNotificationName:CannelLoginFailure object:nil userInfo:nil];
//    if (_AliPayDone || _WeiPayDone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:canSendRedPocketOrNot object:nil];
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];


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
            LWLog(@"提示信息%@",[dict objectForKey:@"retmsg"]);
        }
        
    }else{
        LWLog(@"提示信息返回错误");
        
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
        
        NSString * a  = self.payBackModel.wxFee;
        //        NSString *a = [self.payModel.fee stringValue];
        //商品价格
        
        params[@"nonce_str"] = noncestr; //随机字符串，不长于32位。推荐随机数生成算法
        params[@"trade_type"] = @"APP";   //取值如下：JSAPI，NATIVE，APP，WAP,详细说明见参数规定
        params[@"body"] = self.payBackModel.detail; //商品或支付单简要描述
        
        params[@"notify_url"] = self.payBackModel.wxCallbackUrl;  //接收微信支付异步通知回调地址
        
        params[@"out_trade_no"] = self.payBackModel.orderNo; //订单号
        params[@"spbill_create_ip"] = @"192.168.1.1"; //APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
        
        
        
        
        params[@"total_fee"] = a;  //订单总金额，只能为整数，详见支付金额
        params[@"device_info"] = DeviceNo;
        
        
        
        //        params[@"sign"] = [payManager createMd5Sign:params];
        
        //获取prepayId（预支付交易会话标识）
        NSString * prePayid = nil;
        prePayid  = [payManager sendPrepay:params];
        
        LWLog(@"xcaccasc%@",[payManager getDebugifo]);
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
        order.tradeNO = self.payBackModel.orderNo ; //订单ID（由商家自行制定）
        order.productName = @"粉猫夺宝支付"; //商品标题
        order.productDescription = self.payBackModel.detail; //商品描述
        order.amount = [NSString stringWithFormat:@"%@" ,self.payBackModel.alipayFee ]; //商品价格
        order.notifyURL =  self.payBackModel.alipayCallbackUrl; //回调URL
    
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"qibinTreasure2016";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    LWLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            LWLog(@"reslut = %@",resultDic);
            if([resultDic[@"resultStatus"] intValue] == 9000){
//                _AliPayDone = YES;
//                [self payUpdateUserInfo];
//                [self paySuccessNotice];

                

            }
        }];
    }
    
}
- (void)PayByAliWebview {
    NSString* strIdentifier = _payBackModel.alipayWebUrl;
    BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
     if(isExsit) {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
    }

}
-(void)createPayView{
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PayButtonTableViewCell" owner:nil options:nil];
    _payView=[nib firstObject];
    _payView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_HEIGHT(130));
    [_payView.buttonPay bk_whenTapped:^{
        _payView.buttonPay.userInteractionEnabled = NO;
        [self paySuccessOrFail];
    }];
}
-(void)createBarButtonItem{
//    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [buttonL setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
//    [buttonL addTarget:self action:@selector(clickLightButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bbiL=[[UIBarButtonItem alloc]initWithCustomView:buttonL];
//    self.navigationItem.leftBarButtonItem=bbiL;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:COLOR_NAV_BACK];
}
-(void)clickLightButton{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"PayATableViewCell" bundle:nil] forCellReuseIdentifier:cellPA];
    [_tableView registerNib:[UINib nibWithNibName:@"PayBTableViewCell" bundle:nil] forCellReuseIdentifier:cellPB];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView = _payView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
}


#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PayATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPA forIndexPath:indexPath];
        cell.labelA.text = @"奖品合计";
        cell.labelB.text = [NSString stringWithFormat:@"%@",_payModel.totalMoney];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        if (indexPath.row < 3) {
            PayATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPA forIndexPath:indexPath];
            cell.labelA.text = _titleArray[indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (indexPath.row != 0) {
                cell.imageVTop.hidden = YES;
            }
            if (indexPath.row == 0) {
                cell.labelB.text = _payModel.redPacketsTitle;
                if ([_payModel.redPacketsNumber integerValue ] == 0) {
                    cell.labelCount.hidden =YES;
                }else {
                    cell.labelCount.text = [NSString stringWithFormat:@" %@个红包可用 ",_payModel.redPacketsNumber];
                }
                
            }
            if (indexPath.row == 1) {
                cell.labelMoney.text = [NSString stringWithFormat:@"(余额: %.2f元)",self.userInfo.money.floatValue];
            }
            if (indexPath.row == 2) {
                CGFloat elsePay = [_payModel.totalMoney floatValue] - [_payModel.redPacketsMinusMoney floatValue];
                cell.labelB.text = [NSString stringWithFormat:@"%.2f元",elsePay];
            }
            return cell;
        }else{
            PayBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPB forIndexPath:indexPath];
            cell.labelPay.text = _titleArray[indexPath.row];
            if (indexPath.row != _titleArray.count - 1) {
                cell.imageVBottom.hidden = YES;
            }else {
                cell.imageVLine.hidden = YES;

            }
            if (indexPath.row == _titleArray.count -1) {
                cell.buttonSelect.selected= YES;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return nil;
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _titleArray.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ADAPT_HEIGHT(100);
    }else {
        if (indexPath.row<3) {
            return ADAPT_HEIGHT(100);
        }else{
            return ADAPT_HEIGHT(90);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return ADAPT_HEIGHT(20);

    }else{
        return 0.0f;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_HEIGHT(20))];
    view.backgroundColor = COLOR_BACK_MAIN;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0 && [_payModel.redPacketsNumber integerValue] != 0) {
            RedChooseViewController *red = [[RedChooseViewController alloc] init];
            red.delegate = self;
            red.money = _payModel.totalMoney;
            [self.navigationController pushViewController:red animated:YES];
        }
        //支付类型 0微信 1支付宝 2用户余额
        if (indexPath.row != 1 && indexPath.row != 2) {
            for (int i = 3; i < _titleArray.count; i++) {
                PayBTableViewCell * aCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                aCell.buttonSelect.selected = NO;
            }
            PayBTableViewCell * theCell = [_tableView cellForRowAtIndexPath:indexPath];
            if ([WXApi isWXAppInstalled]) {
                _whichPay = indexPath.row - 3;
            } else {
                _whichPay = indexPath.row - 2;
            }
            NSString * appExamineString = [[NSUserDefaults standardUserDefaults] stringForKey:AppExamine];
            if ([appExamineString isEqualToString:@"1"]) {
                if ([WXApi isWXAppInstalled]) {
                    _whichPay = indexPath.row - 3;
                }else {
                    _whichPay = indexPath.row - 2;
                }
            } else {
                if ([WXApi isWXAppInstalled]) {
                    _whichPay = indexPath.row - 3;
                }else {
                    _whichPay = indexPath.row - 2;

                }
            }
            
            theCell.buttonSelect.selected = YES;
        }
    }
}
-(void)sendRedId:(NSNumber *)redId andTitle: (NSString *)title andDiscountMoney: (NSNumber *)discountMoeny{
    _payModel.redPacketsId = redId;
    _payModel.redPacketsTitle = title;
    _payModel.redPacketsMinusMoney = discountMoeny;
    [_tableView reloadData];
}

- (void)createPayAlertView {
    _payAlertView  = [[UIAlertView alloc]initWithTitle:@"支付中" message:nil delegate: self cancelButtonTitle:@"支付遇到问题" otherButtonTitles: @"支付成功",nil];
    [_payAlertView show];
}
//点击方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            LWLog(@"支付遇到问题");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            LWLog(@"支付成功");
            [self getAppPayResultModel];

        }
            break;
        default:
            break;
    }
}

#pragma mark  网络请求alterView支付结果
-(void)getAppPayResultModel {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"orderNo"] = _payBackModel.orderNo;
    [UserLoginTool loginRequestPostWithFile:@"getPayResult" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            LWLog(@"%@",json[@"resultDescription"]);
            _payResulModel = [AppPayResultModel mj_objectWithKeyValues:json[@"resultData"][@"result"]];
            //支付成功
            if ([_payResulModel.payResult isEqualToNumber:@1]) {
//                _AliPayDone = YES;
                [self payUpdateUserInfo];
            } else {
                PayWebViewController *web = [[PayWebViewController alloc] init];
                web.webURL = _payResulModel.helpUrl;
                [self.navigationController pushViewController:web animated:YES];
                
            }
        }else {
            LWLog(@"%@",json[@"resultDescription"]);
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
    } withFileKey:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 支付成功刷新用户数据
- (void)payUpdateUserInfo {
    [SVProgressHUD showSuccessWithStatus:@"支付成功，积分将在10分钟左右到账，可去积分商城兑换"];

    [UserLoginTool loginRequestPostWithFile:@"updateUserInformation" parame:nil success:^(id json) {
        LWLog(@"%@", json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {
            [self loginSuccessWith:json[@"resultData"]];

        }else {
            [SVProgressHUD showErrorWithStatus:json[@"resultDescription"]];
        }
    } failure:^(NSError *error) {
        
    } withFileKey:nil];
    
    [self paySuccessNotice];
    
}





//刷新用户数据
- (void)loginSuccessWith:(NSDictionary *) dic {
    UserModel *user = [UserModel mj_objectWithKeyValues:dic[@"user"]];
    LWLog(@"userModel: %@",user);
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:UserInfo];
    [NSKeyedArchiver archiveRootObject:user toFile:fileName];
    [[NSUserDefaults standardUserDefaults] setObject:Success forKey:LoginStatus];
    //保存新的token
    [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:AppToken];
    //购物车结算登陆时 需要提交数据
    
    AdressModel *address = [AdressModel mj_objectWithKeyValues:dic[@"user"][@"addressModel"]];
    NSString *fileNameAdd = [path stringByAppendingPathComponent:DefaultAddress];
    [NSKeyedArchiver archiveRootObject:address toFile:fileNameAdd];
}

- (void)paySuccessNotice {
//    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(paySuccessed) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
