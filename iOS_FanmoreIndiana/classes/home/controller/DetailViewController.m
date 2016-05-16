//
//  DetailViewController.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/25.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailAttendListMainTableViewCell.h"
#import "DCPicScrollView.h"
#import "DetailProgressCView.h"
#import "DetailNextTableViewCell.h"
#import "DetailAttendCountCView.h"
#import "DetailBottomCView.h"
#import "DetailWinnerCView.h"
#import "DetailTimeCView.h"
#import "AppGoodsDetailModel.h"
#import "DetailWebViewController.h"
#import "DetailPastViewController.h"
#import "DetailShareViewController.h"
#import "DetailNumberViewController.h"
#import "AppBuyListModel.h"
#import "DetailAttendListFirstTableViewCell.h"
#import <MJRefresh.h>
#import "DetailBottomDoneCView.h"
#import "DetailCalculateViewController.h"
#import "DetailGoodsSelectCView.h"
#import "CartModel.h"
#import "ArchiveLocalData.h"
#import "CircleBannerView.h"
#import "ListViewController.h"

static NSString *cellDNext=@"cellDNext";
static NSString * cellDTMain=@"cellDTMain";
static NSString * cellDFirst=@"cellDFirst";
@interface DetailViewController ()<CircleBannerViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView * headView;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic)  CircleBannerView *headScrollView;//头部视图-轮播视图

@property (strong, nonatomic) UIView * titleView;//标题视图
@property (strong, nonatomic) DetailProgressCView * progressView;//进度视图
@property (strong, nonatomic) DetailAttendCountCView * countView;//参加次数视图
@property (strong, nonatomic) DetailBottomCView * bottomView;//底部选项视图
@property (strong, nonatomic) DetailBottomDoneCView * bottomDoneView;//底部选项视图
@property (strong, nonatomic) DetailWinnerCView * winnerView;//获奖者
@property (strong, nonatomic) DetailTimeCView * timeView;//揭晓倒计时

@property (nonatomic, strong) NSMutableArray *goodsDetailList;
@property (nonatomic, strong) NSMutableArray *buyList;//参与记录
@property (nonatomic, strong) NSMutableArray *cartList;

@property (nonatomic, assign) NSInteger cartCount;//购物车个数

@property (nonatomic, strong) AppGoodsDetailModel *detailModel;
@property (nonatomic, strong) AppBuyListModel *buyModel;
@property (nonatomic, strong) NSTimer *countTimer;//倒计时状态定时器

@property (nonatomic, strong) UIView * backView;//背景灰色视图
@property (nonatomic, strong) DetailGoodsSelectCView * selectView;//背景灰色视图

@property (nonatomic, assign) BOOL isExist;//用于判断归档时有无该对象 默认没归档
@property (nonatomic, assign) BOOL goImmediately;//用于判断是否立刻去购物车


@end

@implementation DetailViewController{
    NSMutableArray * _arrURLString;//轮播图片数组
    NSMutableArray *_titleArray;
    UILabel *_titleStateLabel;//标题状态
    UILabel *_titleLabel;//商品标题
    NSString *_titleString;//标题内容
    CGFloat _titleStrHeight;//标题高度
    NSInteger _titleLineCount;//标题行数
    NSMutableString * _API;
    NSDate *resignBackgroundDate;//

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationItem changeNavgationBarTitle:@"奖品详情"];
    _goImmediately = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self createBarButtonItem];
    _goodsDetailList=[NSMutableArray array];
    _buyList=[NSMutableArray array];
    _isExist = NO;
    self.lastId = [NSNumber numberWithInteger:0];
    self.view.backgroundColor=[UIColor whiteColor];
//选择接口
    if ([self.whichAPI isEqualToNumber:[NSNumber numberWithInteger:1]]) {
        _API=[[NSMutableString alloc]initWithString:@"getGoodsDetailByGoodsId"];
    }else{
        _API=[[NSMutableString alloc]initWithString:@"getGoodsDetailByIssueId"];
    }
    [self registerBackgoundNotification];
    [self createDataArray];
    [self getGoodsDetailList];
    [self createBottomView];

}
//针对 锁屏唤醒app 定时器停止
- (void)registerBackgoundNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActiveToRecordState)
                                                 name:NOTIFICATION_RESIGN_ACTIVE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiveToRecordState)
                                                 name:NOTIFICATION_BECOME_ACTIVE
                                               object:nil];
}
- (void)resignActiveToRecordState
{
    //程序开始"休眠"的时间
    resignBackgroundDate = [NSDate date];
}
- (void)becomeActiveToRecordState
{
    //timeHasGone是程序进入后台与后台进入程序的时间差。
    NSTimeInterval timeHasGone = [[NSDate date] timeIntervalSinceDate:resignBackgroundDate];
//    NSLog(@"%f",timeHasGone);
    _detailModel.remainSecond = _detailModel.remainSecond - timeHasGone * 100 ;

}

- (void)createTimer {
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(createTimerEventA) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
}
//用于商品倒计时状态 倒计时
- (void)createTimerEventA {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COUNT_TIME object:nil];
    [_detailModel countDown];
}
-(void)createBarButtonItem{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:COLOR_NAV_BACK];
}
-(void)clickLightButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupRefresh
{
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getGoodsDetailList)];
    _tableView.mj_header = headRe;

    MJRefreshAutoFooter * Footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreGoodsDetailList)];
    _tableView.mj_footer = Footer;
}

#pragma mark  网络加入购物车
-(void)joinShoppingCart {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"issueId"] = self.issueId;
    
    [UserLoginTool loginRequestPostWithFile:@"joinShoppingCart" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            LWLog(@"%@",json[@"resultDescription"]);
        }else {
            LWLog(@"%@",json[@"resultDescription"]);
        }
        if (_goImmediately) {
            _goImmediately = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
            //先回首页然后 呈现列表 (无push效果)
            [[NSNotificationCenter defaultCenter] postNotificationName:GOTOLISTIMMEDIATELY object:nil];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"加入清单成功"];
        }
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        [SVProgressHUD showSuccessWithStatus:@"加入清单失败"];
    } withFileKey:nil];
}
#pragma mark 网络请求详情列表
/**
 *  下拉刷新
 */
- (void)getGoodsDetailList {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([_whichAPI isEqualToNumber:[NSNumber numberWithInteger:1]]) {
        dic[@"goodsId"] = self.goodsId;
    }else{
        dic[@"issueId"] = self.issueId;
    }
    [UserLoginTool loginRequestGet:_API parame:dic success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            LWLog(@"%@",json[@"resultDescription"]);
            _detailModel = [AppGoodsDetailModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
            _detailModel.remainSecond = _detailModel.remainSecond*100;
            [self createHeadView];
            [self createTimer];
            _arrURLString = [NSMutableArray arrayWithArray:_detailModel.pictureUrl];
            [self getShoppingCount];
            if (_tableView) {
                [_tableView reloadData];
            } else {
                [self createTableView];
            }
        }else{
            LWLog(@"%@",json[@"resultDescription"]);
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
    }];
}

/**
 *  上拉加载更多   加载所有参与记录
 */
- (void)getMoreGoodsDetailList {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_buyList.count > 0) {
        AppBuyListModel *model = [_buyList lastObject];
        self.lastId = model.date;
    }
    dic[@"issueId"] = _detailModel.issueId;
    dic[@"lastId"] = self.lastId;
    [UserLoginTool loginRequestGet:@"getBuyList" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            NSArray *temp = [AppBuyListModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            LWLog(@"resultDescription");
            [self.buyList addObjectsFromArray:temp];
            [_tableView reloadData];
        }
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        LWLog (@"%@",error);
        [_tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 网络请求购物车商品个数 已登陆请求清单的接口 未登录本地解归档计算
- (void)getShoppingCount{
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    //已登陆
    if ([login isEqualToString:Success]) {
        [UserLoginTool loginRequestGet:@"getShoppingList" parame:nil success:^(id json) {
            LWLog(@"%@",json);
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
                LWLog(@"%@",json[@"resultDescription"]);
                _cartList = [NSMutableArray array];
                NSArray *temp = [CartModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
                [_cartList removeAllObjects];
                [_cartList addObjectsFromArray:temp];
                //遍历 查看是否已添加本商品
                for (CartModel *cartM in _cartList) {
                    if (cartM.issueId == _detailModel.issueId) {
                        _isExist = YES;
                    }
                }
                self.cartCount = temp.count;
            }else{
                LWLog(@"%@",json[@"resultDescription"]);
            }
        } failure:^(NSError *error) {
            LWLog(@"%@",error);
        }];
    }
    //未登录
    else{
        NSMutableArray *cartArray =[[NSMutableArray alloc] initWithArray:[ArchiveLocalData unarchiveLocalDataArray]];
        _cartCount = cartArray.count;
        for (CartModel *item in cartArray) {
            if (item.issueId == _detailModel.issueId) {
                _isExist = YES;
            }
        }
    }
    if (_bottomView) {
        _bottomView.labelCount.text = [NSString stringWithFormat:@"%d",self.cartCount];
    } else {
        [self createBottomView];
    }
}


-(void)createDataArray{
    _titleArray=[NSMutableArray arrayWithArray:@[@"图文详情",@"往期揭晓",@"晒单分享"]];
}
#pragma mark 构建头部视图 有空整体优化下代码 代码繁琐
-(void)createHeadView{
    //num =0 正常状态, =1 正在抽奖, =2 本期商品已结束
    NSInteger num =[_detailModel.status integerValue];
    //计算标题+描述性文字的高度
    _titleStrHeight=[self boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) font:[UIFont systemFontOfSize:FONT_SIZE(26)] string:[NSString stringWithFormat:@"                %@ %@",_detailModel.title,_detailModel.character]].height;
//已经结束
    if (num == 2) {
        //总需高度
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_WIDTH(840)+_titleStrHeight +3)];
        //轮播视图
        _headScrollView = [[CircleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_HEIGHT(390)) urlArray:_detailModel.pictureUrl];
        _headScrollView.interval = 0.f;
        _headScrollView.delegate =self;
        //状态 +标题+描述性文字 (整体可优化为富文本)
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(10, ADAPT_HEIGHT(390)+3, SCREEN_WIDTH-20, _titleStrHeight)];
        _titleView.backgroundColor=[UIColor whiteColor];
        [self createTitleLabel];
        //状态文字 (优化为图片)
        [self createStateLabel];
        //获奖者视图
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DetailWinnerCView" owner:nil options:nil];
        _winnerView= [nib firstObject];
        _winnerView.frame = CGRectMake(0, ADAPT_HEIGHT(390) + 3 + _titleStrHeight, SCREEN_WIDTH, ADAPT_HEIGHT(360));
        _winnerView.labelWinnerA.text=_detailModel.awardingUserName;
        _winnerView.labelCity.text=[NSString stringWithFormat:@"( %@ IP%@ )",_detailModel.awardingUserCityName,_detailModel.awardingUserIp];
        _winnerView.labelIDA.text=[NSString stringWithFormat:@"%@",_detailModel.awardingUserId];
        _winnerView.labelTermA.text=[NSString stringWithFormat:@"%@",_detailModel.issueId];
        _winnerView.labelAttendA.text=[NSString stringWithFormat:@"%@",_detailModel.awardingUserBuyCount];
        _winnerView.labelTimeA.text=[self changeTheTimeStamps:_detailModel.awardingDate andTheDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _winnerView.labelNumberA.text=[NSString stringWithFormat:@"%@",_detailModel.luckyNumber];
        [_winnerView.imageVHead sd_setImageWithURL:[NSURL URLWithString:_detailModel.awardingUserHead] placeholderImage:[UIImage imageNamed:@"mrtx"]];
        //计算详情点击
        [_winnerView.buttonContent addTarget:self action:@selector(clickButtonConcent:) forControlEvents:UIControlEventTouchUpInside];
//        [_winnerView.buttonContent bk_whenTapped:^{
//            DetailCalculateViewController *calculate = [[DetailCalculateViewController alloc] init];
//            calculate.issueId = _detailModel.issueId;
//            [self.navigationController pushViewController:calculate animated:YES];
//        }];
        //参与视图 向上偏移了ADAPT_HEIGHT(20)后期调整
        NSArray *nibA = [[NSBundle mainBundle]loadNibNamed:@"DetailAttendCountCView" owner:nil options:nil];
        _countView= [nibA firstObject];
        _countView.frame = CGRectMake(0, ADAPT_HEIGHT(730) + _titleStrHeight+3, SCREEN_WIDTH, ADAPT_HEIGHT(110));
        //根据numbers判断用户是否参与本期夺宝 count=0未参与
        if (_detailModel.numbers.count > 0) {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您参与了%ld人次",(unsigned long)_detailModel.numbers.count]];
            [attString addAttribute:NSForegroundColorAttributeName value:COLOR_SHINE_RED range:NSMakeRange(4, [NSString stringWithFormat:@"%ld",(unsigned long)_detailModel.numbers.count].length)];
            _countView.labelA.attributedText=attString;
            _countView.labelB.text=@"点击查看号码";
            _countView.labelCount.hidden=YES;
            _countView.labelA.hidden=NO;
            _countView.labelB.hidden=NO;
            _countView.viewNext.hidden=NO;
            //参与号码点击
            _countView.viewNext.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewNext)];
            [_countView.viewNext addGestureRecognizer:tapC];
//            [_countView.viewNext bk_whenTapped:^{
//                DetailNumberViewController *number=[[DetailNumberViewController alloc]init];
//                number.numberArray = _detailModel.numbers;
//                number.goodsName=_detailModel.title;
//                number.issueId=[NSString stringWithFormat:@"%@",_detailModel.issueId];
//                [self.navigationController pushViewController:number animated:YES];
//            }];
        }else{
            //未参与本期夺宝
            _countView.labelCount.hidden=NO;
            _countView.labelA.hidden=YES;
            _countView.labelB.hidden=YES;
            _countView.viewNext.hidden=YES;
        }
        [_headView addSubview:_headScrollView];
        [_headView addSubview:_titleView];
        [_headView addSubview:_winnerView];
        [_headView addSubview:_countView];
        
    }
//正在抽奖
    if (num == 1) {
        //总需高度
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_WIDTH(610)+_titleStrHeight+6)];
        //轮播视图
        _headScrollView = [[CircleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_HEIGHT(390)) urlArray:_detailModel.pictureUrl];
        _headScrollView.interval = 0.f;
        _headScrollView.delegate =self;
        //状态 +标题+描述性文字 (整体可优化为富文本)
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(10, ADAPT_HEIGHT(390) + 3, SCREEN_WIDTH-20, _titleStrHeight)];
        _titleView.backgroundColor=[UIColor whiteColor];
        //标题+描述性文字
        [self createTitleLabel];
        //状态文字 (优化为图片)
        [self createStateLabel];
        //倒计时视图
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DetailTimeCView" owner:nil options:nil];
        _timeView= [nib firstObject];
        [_timeView defaultConfig];
        [_timeView loadData:_detailModel];
        _timeView.frame = CGRectMake(0, ADAPT_HEIGHT(390) + _titleStrHeight+6, SCREEN_WIDTH, ADAPT_HEIGHT(110));
        //参与视图
        NSArray *nibA = [[NSBundle mainBundle]loadNibNamed:@"DetailAttendCountCView" owner:nil options:nil];
        _countView= [nibA firstObject];
        _countView.frame = CGRectMake(0, ADAPT_HEIGHT(500) + _titleStrHeight+6, SCREEN_WIDTH, ADAPT_HEIGHT(110));
        //根据numbers判断用户是否参与本期夺宝 count=0未参与
        if (_detailModel.numbers.count > 0) {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您参与了%ld人次",(unsigned long)_detailModel.numbers.count]];
            [attString addAttribute:NSForegroundColorAttributeName value:COLOR_SHINE_RED range:NSMakeRange(4, [NSString stringWithFormat:@"%ld",(unsigned long)_detailModel.numbers.count].length)];
            _countView.labelA.attributedText=attString;
            _countView.labelB.text=@"点击查看号码";
            _countView.labelCount.hidden=YES;
            _countView.labelA.hidden=NO;
            _countView.labelB.hidden=NO;
            _countView.viewNext.hidden=NO;
            //参与号码点击
            _countView.viewNext.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewNext)];
            [_countView.viewNext addGestureRecognizer:tapC];
//            [_countView.viewNext bk_whenTapped:^{
//                DetailNumberViewController *number=[[DetailNumberViewController alloc]init];
//                number.numberArray = _detailModel.numbers;
//                number.goodsName=_detailModel.title;
//                number.issueId=[NSString stringWithFormat:@"%@",_detailModel.issueId];
//                [self.navigationController pushViewController:number animated:YES];
//            }];
        }else{
            _countView.labelCount.hidden=NO;
            _countView.labelA.hidden=YES;
            _countView.labelB.hidden=YES;
            _countView.viewNext.hidden=YES;
        }
        [_headView addSubview:_headScrollView];
        [_headView addSubview:_titleView];
        [_headView addSubview:_timeView];
        [_headView addSubview:_countView];
    }
//正常状态
    if (num == 0) {
        //总需高度
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_WIDTH(610)+_titleStrHeight+6)];
        //轮播视图
        _headScrollView = [[CircleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_HEIGHT(390)) urlArray:_detailModel.pictureUrl];
        _headScrollView.interval = 0.f;
        _headScrollView.delegate =self;
        //状态 +标题+描述性文字 (整体可优化为富文本)
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(10, ADAPT_HEIGHT(390)+3, SCREEN_WIDTH-20, _titleStrHeight)];
        _titleView.backgroundColor=[UIColor whiteColor];
        //标题+描述性文字
        [self createTitleLabel];
        //状态文字 (优化为图片)
        [self createStateLabel];
        //倒计时视图
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DetailProgressCView" owner:nil options:nil];
        _progressView= [nib firstObject];
        _progressView.frame = CGRectMake(0, ADAPT_HEIGHT(390) + _titleStrHeight+6, SCREEN_WIDTH, ADAPT_HEIGHT(110));
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余: %@",_detailModel.remainAmount]];
        [attString addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_CONTENT range:NSMakeRange(0, 3)];
        _progressView.labelRest.attributedText=attString;
        _progressView.labelTotal.text=[NSString stringWithFormat:@"总需: %@人次",_detailModel.toAmount];
        _progressView.labelTerm.text=[NSString stringWithFormat:@"期号: %@",_detailModel.issueId];
        self.issueId = _detailModel.issueId;
        CGFloat percent=(_detailModel.toAmount.floatValue -_detailModel.remainAmount.floatValue)/(_detailModel.toAmount.floatValue);
        _progressView.viewProgress.progress=percent;
        //参与视图
        NSArray *nibA = [[NSBundle mainBundle]loadNibNamed:@"DetailAttendCountCView" owner:nil options:nil];
        _countView= [nibA firstObject];
        _countView.frame = CGRectMake(0, ADAPT_HEIGHT(500) + _titleStrHeight+6, SCREEN_WIDTH, ADAPT_HEIGHT(110));
        //根据numbers判断用户是否参与本期夺宝 count=0未参与
        if (_detailModel.numbers.count > 0) {
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您参与了%ld人次",(unsigned long)_detailModel.numbers.count]];
            [attString addAttribute:NSForegroundColorAttributeName value:COLOR_SHINE_RED range:NSMakeRange(4, [NSString stringWithFormat:@"%ld",(unsigned long)_detailModel.numbers.count].length)];
            _countView.labelA.attributedText=attString;
            _countView.labelB.text=@"点击查看号码";
            _countView.labelCount.hidden=YES;
            _countView.labelA.hidden=NO;
            _countView.labelB.hidden=NO;
            _countView.viewNext.hidden=NO;
            //参与号码点击
            _countView.viewNext.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewNext)];
            [_countView.viewNext addGestureRecognizer:tapC];
//            [_countView.viewNext bk_whenTapped:^{
//                DetailNumberViewController *number=[[DetailNumberViewController alloc]init];
//                number.numberArray = _detailModel.numbers;
//                number.goodsName=_detailModel.title;
//                number.issueId=[NSString stringWithFormat:@"%@",_detailModel.issueId];
//                [self.navigationController pushViewController:number animated:YES];
//            }];
        }else{
            _countView.labelCount.hidden=NO;
            _countView.labelA.hidden=YES;
            _countView.labelB.hidden=YES;
            _countView.viewNext.hidden=YES;
        }
        [_headView addSubview:_countView];
        [_headView addSubview:_progressView];
        [_headView addSubview:_titleView];
        [_headView addSubview:_headScrollView];
    }
}
#pragma mark 底部选项
-(void)createBottomView{
    //商品正常状态的底部选项
    if ([_whichAPI isEqualToNumber:[NSNumber numberWithInteger:1]]) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"DetailBottomCView" owner:nil options:nil];
        _bottomView=[nib firstObject];
        _bottomView.frame=CGRectMake(0, SCREEN_HEIGHT-ADAPT_HEIGHT(100)-64, SCREEN_WIDTH, ADAPT_HEIGHT(100));
        //立刻去购物车  两种情况 登陆 未登录
        [_bottomView.buttonGo bk_whenTapped:^{
        NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
        if ([login isEqualToString:Success]) {
#pragma mark 加入清单 已登陆
            _goImmediately = YES;
            self.issueId = _detailModel.issueId;
            [self joinShoppingCart];
        }else{
#pragma mark 加入清单 未登陆
            _goImmediately = YES;
            if (_joinModel == nil) {
                //归档
                [ArchiveLocalData archiveLocalDataArrayWithDetailModel:_detailModel];
            } else {
                //归档
                [ArchiveLocalData archiveLocalDataArrayWithGoodsModel:_joinModel];
            }
            if (_goImmediately) {
                _goImmediately = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:GOTOLISTIMMEDIATELY object:nil];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"加入清单成功"];
            }
        }
        }];
        //加入清单  两种情况 登陆 未登录
        [_bottomView.buttonAdd bk_whenTapped:^{
            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
            if ([login isEqualToString:Success]) {
#pragma mark 加入购物车 已登陆
                //如果购物车已有本商品 级数不加1
                self.issueId = _detailModel.issueId;
                [self joinShoppingCart];
                if (!_isExist) {
                    _bottomView.labelCount.text = [NSString stringWithFormat:@"%ld",self.cartCount + 1];
                }
            }else{
#pragma mark 加入购物车 未登陆
                if (_joinModel == nil) {
                    //归档
                    [ArchiveLocalData archiveLocalDataArrayWithDetailModel:_detailModel];
                } else {
                    //归档
                    [ArchiveLocalData archiveLocalDataArrayWithGoodsModel:_joinModel];
                }
                //列表中无本商品 计数+1
                if (!_isExist) {
                    _bottomView.labelCount.text = [NSString stringWithFormat:@"%ld",self.cartCount + 1];
                }
                [SVProgressHUD showSuccessWithStatus:@"加入清单成功"];
            }
        }];
        //购物车图标点击后 立刻进入清单
        _bottomView.imageVShop.userInteractionEnabled = YES;
        [_bottomView.imageVShop bk_whenTapped:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:GOTOLISTIMMEDIATELY object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        if (self.cartCount == 0) {
            _bottomView.labelCount.hidden = YES;
        } else {
            _bottomView.labelCount.text = [NSString stringWithFormat:@"%ld",(long)self.cartCount];

        }
        [self.view addSubview:_bottomView];
    }
    //倒计时 已揭晓 的底部选项
    else{
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"DetailBottomDoneCView" owner:nil options:nil];
        _bottomDoneView=[nib firstObject];
        _bottomDoneView.frame=CGRectMake(0, SCREEN_HEIGHT-ADAPT_HEIGHT(100)-64, SCREEN_WIDTH, ADAPT_HEIGHT(100));
        [_bottomDoneView.buttonGo bk_whenTapped:^{
            DetailViewController *detail = [[DetailViewController alloc]init];
            detail.whichAPI = [NSNumber numberWithInteger:1];
            detail.goodsId = _detailModel.pid;
            [self.navigationController pushViewController:detail animated:YES];
        }];
        [self.view addSubview:_bottomDoneView];
    }
}
//立即参与的弹框 暂无调用
- (void)createSelectView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [UIColor grayColor];
        _backView.alpha = 0.5;
    }
    if (!_selectView) {
        NSArray * nib =[[NSBundle mainBundle] loadNibNamed:@"DetailGoodsSelectCView" owner:nil options:nil];
        _selectView = [nib firstObject];
        _selectView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, ADAPT_HEIGHT(460));
        [UIView animateWithDuration:0.3f animations:^{
            _selectView.frame = CGRectMake(0, SCREEN_HEIGHT - ADAPT_HEIGHT(460) - 64, SCREEN_WIDTH, ADAPT_HEIGHT(460));
        }];
        [_selectView.buttonClose bk_whenTapped:^{
            [UIView animateWithDuration:0.3f animations:^{
                _selectView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, ADAPT_HEIGHT(460));
            } completion:^(BOOL finished) {
                [_backView removeFromSuperview];
                [_selectView removeFromSuperview];
                _selectView = nil;
                _backView = nil;
            }];
        }];
    }
    [self.view addSubview:_backView];
    [self.view addSubview:_selectView];
}
//状态label
-(void)createStateLabel{
    _titleStateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _titleStrHeight/_titleLineCount*3,_titleStrHeight/_titleLineCount)];
    if ([_detailModel.status isEqualToNumber:[NSNumber numberWithInteger:0]]) {
        _titleStateLabel.text=@"进行中";
        _titleStateLabel.backgroundColor = COLOR_BUTTON_ORANGE;
        _titleStateLabel.textColor = [UIColor whiteColor];
        _titleStateLabel.layer.borderColor=COLOR_BUTTON_ORANGE.CGColor;

    }
    if ([_detailModel.status isEqualToNumber:[NSNumber numberWithInteger:1]]) {
        _titleStateLabel.text=@"倒计时";
        _titleStateLabel.backgroundColor = [UIColor whiteColor];
        _titleStateLabel.textColor = COLOR_BUTTON_ORANGE;
        _titleStateLabel.layer.borderColor=COLOR_BUTTON_ORANGE.CGColor;
    }
    if ([_detailModel.status isEqualToNumber:[NSNumber numberWithInteger:2]]) {
        _titleStateLabel.text=@"已揭晓";
        _titleStateLabel.textColor = [UIColor whiteColor];
        _titleStateLabel.backgroundColor = [UIColor colorWithRed:31/255.0f green:202/255.0f blue:46/255.0f alpha:1];
        _titleStateLabel.layer.borderColor=[UIColor colorWithRed:31/255.0f green:202/255.0f blue:46/255.0f alpha:1].CGColor;
    }
    _titleStateLabel.textAlignment=NSTextAlignmentCenter;
    _titleStateLabel.font=[UIFont systemFontOfSize:FONT_SIZE(24)];
    _titleStateLabel.layer.borderWidth=1;
    _titleStateLabel.layer.cornerRadius=3;
    _titleStateLabel.layer.masksToBounds=YES;
    [_titleView addSubview:_titleStateLabel];
}
//标题+描述性文字 (整体可优化为富文本)
-(void)createTitleLabel{
    _titleLabel=[[UILabel alloc ]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, _titleStrHeight)];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"                %@ %@",_detailModel.title,_detailModel.character]];
    [attString addAttribute:NSForegroundColorAttributeName value:COLOR_SHINE_RED range:NSMakeRange(16+_detailModel.title.length+1,_detailModel.character.length)];
    _titleLabel.attributedText=attString;
    _titleLabel.font=[UIFont systemFontOfSize:FONT_SIZE(24)];
    _titleLabel.numberOfLines=0;
    _titleLineCount =(NSInteger)[self lineCountForLabel:_titleLabel];
//    NSLog(@"%ld",(long)_titleLineCount);
    [_titleView addSubview:_titleLabel];
}
#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-ADAPT_HEIGHT(100)) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"DetailAttendListMainTableViewCell" bundle:nil] forCellReuseIdentifier:cellDTMain];
    [_tableView registerNib:[UINib nibWithNibName:@"DetailNextTableViewCell" bundle:nil] forCellReuseIdentifier:cellDNext];
    [_tableView registerNib:[UINib nibWithNibName:@"DetailAttendListFirstTableViewCell" bundle:nil] forCellReuseIdentifier:cellDFirst];
    _tableView.tableHeaderView=_headView;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self setupRefresh];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }else{
        if (_buyList.count > 0) {
            return 1 + 1 +_buyList.count;
        }else{
            return 1;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DetailNextTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDNext forIndexPath:indexPath];
        cell.labelTitle.text=_titleArray[indexPath.row];
        if (indexPath.row == 0) {
                cell.labelAdvice.text=@"建议wifi下查看";
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            DetailNextTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDNext forIndexPath:indexPath];
            cell.labelTitle.text=@"所有参与记录";
            if ([_detailModel.firstBuyTime isEqualToNumber:@0]) {
                cell.labelAdvice.text = @"";
            }else {
                cell.labelAdvice.text=[NSString stringWithFormat:@"( %@开始 )",[self changeTheTimeStamps:_detailModel.firstBuyTime andTheDateFormat:@"yyyy-MM-dd HH:mm:ss"]];

            }
            cell.imageVNext.hidden = YES;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 1) {
            DetailAttendListFirstTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDFirst forIndexPath:indexPath];
            AppBuyListModel *model=_buyList[0];
            cell.labelDate.text=[self changeTheTimeStamps:model.date andTheDateFormat:@"  yyyy-MM-dd  "];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row>1 && _buyList.count>0) {
            DetailAttendListMainTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellDTMain forIndexPath:indexPath];
            AppBuyListModel *model=_buyList[indexPath.row - 2];
            cell.labelName.text=model.nickName;
            cell.labelCity.text=[NSString stringWithFormat:@"( %@ IP:%@ )",model.city,model.ip];
            
            NSString *dateString=[self changeTheTimeStamps:model.date andTheDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSMutableAttributedString *AttributedStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与了%@人次 %@",model.attendAmount,dateString]];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_CONTENT range:NSMakeRange(0, 5+[NSString stringWithFormat:@"%@",model.attendAmount].length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_BUTTON_ORANGE range:NSMakeRange(3, [NSString stringWithFormat:@"%@",model.attendAmount].length)];
            cell.labelDate.attributedText=AttributedStr;
            [cell.imageVHead sd_setImageWithURL:[NSURL URLWithString:model.userHeadUrl] placeholderImage:[UIImage imageNamed:@"mrtx"]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            DetailWebViewController *web=[[DetailWebViewController alloc]init];
            web.webURL=_detailModel.link;
            [self.navigationController pushViewController:web animated:YES];
        }
        if (indexPath.row == 1) {
            DetailPastViewController *past=[[DetailPastViewController alloc]init];
            past.goodsId = _detailModel.pid;
            past.lastId = _detailModel.issueId;
            [self.navigationController pushViewController:past animated:YES];
        }
        if (indexPath.row == 2) {
            DetailShareViewController *share=[[DetailShareViewController alloc]init];
            share.goodsId = _detailModel.pid;
            share.lastId = _detailModel.issueId;
            [self.navigationController pushViewController:share animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ADAPT_HEIGHT(25);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ADAPT_HEIGHT(100);
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  计算label高度
 *
 *  @param size <#size description#>
 *  @param font <#font description#>
 *  @param str  <#str description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)str
{
    NSDictionary *attribute = @{NSFontAttributeName : font};
    CGSize retSize = [str boundingRectWithSize:size
                                       options:
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
}
/**
 *  计算label行数
 *
 *  @param label <#label description#>
 *
 *  @return <#return value description#>
 */
- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
    
    return ceil(size.height / label.font.lineHeight);
}
/**
 *  13位时间戳转为正常时间(可设置样式)
 *
 *  @param time 时间戳
 *
 *  @return
 */
-(NSString *)changeTheTimeStamps:(NSNumber *)time andTheDateFormat:(NSString *)dateFormat{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:dateFormat];
    //将13位时间戳转为正常时间格式
    NSString * str = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[time longLongValue] / 1000]];
    return str;
}


#pragma mark 轮播
//加载图片的代理，你自己想 怎么加载 就怎么加载
- (void)imageView:(UIImageView *)imageView loadImageForUrl:(NSString *)url{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]  placeholderImage:[UIImage imageNamed:@"wtx"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;;
}
- (void)clickButtonConcent:(UIButton *)buttonConcent {
    DetailCalculateViewController *calculate = [[DetailCalculateViewController alloc] init];
    calculate.issueId = _detailModel.issueId;
    [self.navigationController pushViewController:calculate animated:YES];
}
- (void)tapViewNext {
    DetailNumberViewController *number=[[DetailNumberViewController alloc]init];
    number.numberArray = _detailModel.numbers;
    number.goodsName=_detailModel.title;
    number.issueId=[NSString stringWithFormat:@"%@",_detailModel.issueId];
    [self.navigationController pushViewController:number animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
