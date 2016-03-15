//
//  RedViewController.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/3/2.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "RedViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RedCountCView.h"
#import "RedGetCView.h"
#import "RedWaitCView.h"
#import "RedDisGetCView.h"
#import "RedHopeCView.h"
#import "AppRedPactketsDistributeSourceModel.h"
#import "AppWinningInfoModel.h"
#import "RedHopeCView.h"
#import "GCDTimerManager.h"
#import "PlistManager.h"
#import "LoginController.h"
@interface RedViewController ()<logVCdelegate>{
    CALayer *_layer;
    CAAnimationGroup *_animaTionGroup;
    CADisplayLink *_disPlayLink;
    AVPlayer* myplayer;
    NSInteger _statusNumber; //用于判断当前活动的状态0 已经开始 1还没开始 2没有活动
    NSInteger _redRequestNumber;//点击多少次请求一次服务器
    NSInteger _RedItemId; //活动期号
    

    
}
//@property (nonatomic,retain) UIView *imgView;

@property (nonatomic, strong) UIImageView * backImageV;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) NSInteger count;//点击次数
@property (nonatomic, assign) NSInteger redRestNumber;//红包个数

@property (nonatomic, strong) UIImageView *imageVReturn;
@property (nonatomic, strong) UIImageView *imageVXiu;
@property (nonatomic, strong) UIImageView *imageVTop;
@property (nonatomic, strong) UIImageView *imageVBack;
@property (nonatomic, strong) UIImageView *imageVBottom;
@property (nonatomic, strong) RedHopeCView *imageVHope;//无活动图片
@property (nonatomic, strong) UIImageView *imageVError;//网络问题
@property (nonatomic, strong) RedCountCView *countView;//剩余时间与红包个数
@property (nonatomic, strong) RedWaitCView *waitView;//活动未开始
@property (nonatomic, strong) RedDisGetCView *disGetView;//没有咻中
@property (nonatomic, strong) RedGetCView *getView;//咻中红包
@property (nonatomic, strong) RedHopeCView *hopeView;//咻中红包

@property (nonatomic, strong) AppRedPactketsDistributeSourceModel *distributeModel;
@property (nonatomic, strong) AppWinningInfoModel *winningModel;


@property (nonatomic, strong) NSTimer * timerWait;
@property (nonatomic, strong) NSTimer * timerEnd;
//@property (nonatomic, strong) NSTimer * timerRedNumber;//刷新剩余红包个数
@property (nonatomic, strong) NSTimer * timerPopToHome;//5秒后返回首页


@property (nonatomic, strong) NSMutableArray *redList;//用于接收当前xiuxiu红包
@property (nonatomic, strong) NSMutableArray *redPastList;//用于存放上次xiuxiu红包


@end

@implementation RedViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _count = 0;
//    self.view.backgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:105/225.0 alpha:1];
    _redList = [NSMutableArray array];
    _redPastList = [NSMutableArray array];
    
    
    
    [self getDistuributeModel];


    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivityStart) name:NOTIFICATION_ACTIVITY_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivityEnd) name:NOTIFICATION_ACTIVITY_END object:nil];

    

    
}



- (void)createTimer {
    //开始
//    __block RedViewController *weakSelf = self;
    if (_statusNumber == 0) {
        [GCDTimerManager scheduledDispatchTimerWithName:@"timerEnd" timeInterval:1.f queue:dispatch_get_main_queue() repeats:YES actionOption:LastJobManagerDisabled action:^{
//            [weakSelf EndTimeEvent];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RED_END object:nil];
            [_distributeModel EndCountDown];
            [_countView loadCountData:_distributeModel];
            
        }];
    
        
//        self.timerEnd = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(EndTimeEvent) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timerEnd forMode:NSRunLoopCommonModes];
    }
    //等待
    if (_statusNumber == 1) {
//        [GCDTimerManager scheduledDispatchTimerWithName:@"timerWait" timeInterval:1.f queue:nil repeats:YES actionOption:LastJobManagerDisabled action:^{
//            [weakSelf WaitTimerEvent];
//        }];
        self.timerWait = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(WaitTimerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timerWait forMode:NSRunLoopCommonModes];

    }
}
- (void)WaitTimerEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RED_WAIT object:nil];
    [_distributeModel WaitCountDown];
}
- (void)EndTimeEvent {

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RED_END object:nil];
    [_distributeModel EndCountDown];
}


#pragma mark 判断活动是否开始
- (void)getDistuributeModel {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [UserLoginTool loginRequestGet:@"whetherToStartDrawing" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            _distributeModel = [AppRedPactketsDistributeSourceModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
            _statusNumber = [json[@"resultData"][@"flag"] integerValue];
            _RedItemId = [json[@"resultData"][@"sourceId"] integerValue];
            

//            if (_statusNumber == 1) {
//                _distributeModel.endTime = _distributeModel.endTime - _distributeModel.startTime;
//
//            }
            
            [self createMainXiuView];


            //开始
            if (_statusNumber == 0) {
                [self createTimerRedNumber];

            }
            //等待
            if (_statusNumber == 1) {
                [self createWaitView];

            }
            //无活动
            if (_statusNumber == 2) {
                [self createHopeView];
                
            }
            [self creatImageVReturn];
            [self createTimer];
            
        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        NSLog(@"*************网络连接失败************");
        [self createImageVError];

    }];
    
}
#pragma mark 剩余红包个数
- (void)getRedPocketRestNumber {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [UserLoginTool loginRequestGet:@"whetherToStartDrawing" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            _distributeModel = [AppRedPactketsDistributeSourceModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
            _redRestNumber = _distributeModel.amount;
            [self refreshRestRedPocketNumber];
        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        
    }];
    
}
#pragma mark xiuxiu请求
- (void)getXiuXiuXiu {
    LWLog(@"发送了xiuxiuxixuixu");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [UserLoginTool loginRequestGet:@"xiuxiuxiu" parame:dic success:^(id json) {
        LWLog(@"%@",json);
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            NSArray *temp = [AppWinningInfoModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            [self.redList removeAllObjects];
            self.redList = [NSMutableArray arrayWithArray:temp];
            
            [PlistManager createPlist];
            //获取plistManager存放的活动期号 不同存放新的数据  相同获取_redPastList
//            NSInteger redPastItemId = [PlistManager readDataWithKey:@"redItemId"];
//            if (redPastItemId != _RedItemId) {
//                [PlistManager writeToPlistWithKey:@"data" value:self.redList];
//            } else {
//                _redPastList = [PlistManager readDataWithKey:@"data"];
//            }
            //正在中奖或者已中奖
            if (_redList.count != 0) {
                //第一次
                if (_redPastList.count == 0) {
                    [self.redPastList removeAllObjects];
                    self.redPastList = [NSMutableArray arrayWithArray:temp];
                    _winningModel = _redList[0];
                }else {
                    _winningModel = [self getNewRedPocket];
//                    [PlistManager writeToPlistWithKey:@"data" value:self.redList];
//                    self.redPastList = [NSMutableArray arrayWithArray:self.redList];
                }
                //如果未中奖
                if (_winningModel.rid == nil) {
                    [self createDisGetView];
                } else {
                    [self createGetView];
                }
            
            }else {
                [self createDisGetView];
            }

            
            
            

        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        
    }];
    
}
#pragma mark 活动开始切换界面
- (void)ActivityStart {
    if (_waitView) {
        [_waitView removeFromSuperview];
//        [GCDTimerManager cancelTimerWithName:@"timerWait"];
        [self.timerWait invalidate];
        self.timerWait = nil;
        [_countView defaultConfig];
        
        [GCDTimerManager scheduledDispatchTimerWithName:@"timerEnd" timeInterval:1.f queue:dispatch_get_main_queue() repeats:YES actionOption:LastJobManagerDisabled action:^{
//            [weakSelf EndTimeEvent];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RED_END object:nil];
            [_distributeModel EndCountDown];
            [_countView loadCountData:_distributeModel];

            
        }];
//        self.timerEnd = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(EndTimeEvent) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timerEnd forMode:NSRunLoopCommonModes];
//        [self createTimerRedNumber];
    }
}
#pragma mark 活动结束切换界面
- (void)ActivityEnd {
//    __block RedViewController * weakSelf = self;
//    [GCDTimerManager scheduledDispatchTimerWithName:@"timerPopToHome" timeInterval:5.f queue:nil repeats:YES actionOption:LastJobManagerDisabled action:^{
//        [weakSelf popToHimeView];
//    }];
    [GCDTimerManager cancelAllTimer];
    _timerPopToHome = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(popToHimeView) userInfo:nil repeats:NO];
    

}
- (void)popToHimeView {
    [self.navigationController popViewControllerAnimated:YES];
}
//刷新红包剩余个数
- (void)createTimerRedNumber {
    __block RedViewController * weakSelf = self;
    [GCDTimerManager scheduledDispatchTimerWithName:@"timerRedNumber" timeInterval:5.f queue:dispatch_get_main_queue() repeats:YES actionOption:LastJobManagerDisabled action:^{
        [weakSelf getRedPocketRestNumber];
    }];

//    self.timerRedNumber = [NSTimer timerWithTimeInterval:10.f target:self selector:@selector(getRedPocketRestNumber) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timerRedNumber forMode:NSRunLoopCommonModes];


}
//刷新剩余红包个数
- (void)refreshRestRedPocketNumber {
    NSInteger A = _redRestNumber / 100000;
    NSInteger B = _redRestNumber / 10000 % 10;
    NSInteger C = _redRestNumber / 1000  % 10;
    NSInteger D = _redRestNumber / 100   % 10;
    NSInteger E = _redRestNumber / 10    % 10;
    NSInteger F = _redRestNumber / 1     % 10;
    
    _countView.labelA.text = [NSString stringWithFormat:@"%ld",A];
    _countView.labelB.text = [NSString stringWithFormat:@"%ld",B];
    _countView.labelC.text = [NSString stringWithFormat:@"%ld",C];
    _countView.labelD.text = [NSString stringWithFormat:@"%ld",D];
    _countView.labelE.text = [NSString stringWithFormat:@"%ld",E];
    _countView.labelF.text = [NSString stringWithFormat:@"%ld",F];

}
//遍历找出是否获得新的红包
- (AppWinningInfoModel *)getNewRedPocket {
    for (NSInteger i = _redPastList.count - 1; i >= 0; i--) {
        AppWinningInfoModel *redPastM = _redPastList[i];
        for (NSInteger j = _redList.count - 1; j >= 0; j--) {
            AppWinningInfoModel * redM = _redList[j];
            if ([redM.rid integerValue] == [redPastM.rid integerValue]) {
                [_redList removeObjectAtIndex:j];
            }
        }
    }
    if (_redList.count == 0) {
        return nil;
    }else {
        AppWinningInfoModel * newM = _redList[0];
        return newM;
    }
    
}
- (void) createImageVNone {
    NSArray * nib =[[NSBundle mainBundle] loadNibNamed:@"RedHopeCView" owner:nil options:nil];
    _imageVHope = [nib firstObject];
    _imageVHope.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_imageVHope];
    [self createImageVBack];
}
- (void) createImageVError {
    _imageVError = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageVError.image = [UIImage imageNamed:@"wuhuodong"];
    [self.view addSubview:_imageVError];
    [self createImageVBack];
}
- (void)createGetView {
    [_getView removeFromSuperview];
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"RedGetCView" owner:nil options:nil];
    _getView = [nib firstObject];
    _getView.frame = CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
    [_getView.viewClear bk_whenTapped:^{
        LWLog(@"点击了clearV");
        [_getView removeFromSuperview];
    }];
    _getView.labelMoney.text = _winningModel.winningInfo;
    [self.view addSubview:_getView];
}
- (void)createDisGetView {
    [_disGetView removeFromSuperview];
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"RedDisGetCView" owner:nil options:nil];
    _disGetView = [nib firstObject];
    _disGetView.frame = CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
    [_disGetView.viewClear bk_whenTapped:^{
        LWLog(@"点击了clearV");
        [_disGetView removeFromSuperview];
    }];
    [self.view addSubview:_disGetView];
}
- (void)createHopeView {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"RedHopeCView" owner:nil options:nil];
    _hopeView = [nib firstObject];
    _hopeView.frame = CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_hopeView];
}
- (void)createMainXiuView {
    [self createImageVBack];
    [self createImageVTop];
    [self createImageVBottom];
    [self createImageVXiu];
    [self createCountView];
}



- (void) creatImageVReturn {
    _imageVReturn = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 25, 25)];
    _imageVReturn.image = [UIImage imageNamed:@"back"];
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    backV.userInteractionEnabled = YES;
    [backV bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:_imageVReturn];
    [self.view addSubview:backV];
    [self.view bringSubviewToFront:backV];
}
- (void) createCountView {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RedCountCView" owner:nil options:nil];
    _countView = [nib firstObject];
    _countView.frame = CGRectMake(0, ADAPT_HEIGHT(480), SCREEN_WIDTH, ADAPT_HEIGHT(100));
    [_countView defaultConfig];
    [_countView loadCountData:_distributeModel];
    [self.view addSubview:_countView];
}
- (void)createWaitView {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"RedWaitCView" owner:nil options:nil];
    _waitView = [nib firstObject];
    _waitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_waitView defaultConfig];
    [_waitView loadData:_distributeModel];
    [self.view addSubview:_waitView];
    
}
- (void) createImageVXiu {
    self.imageVXiu = [[UIImageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH/2 - ADAPT_HEIGHT(103), ADAPT_HEIGHT(705), ADAPT_HEIGHT(206), ADAPT_HEIGHT(206))];
    _imageVXiu.image = [UIImage imageNamed:@"hb_d"];
    [self.view addSubview:_imageVXiu];
}

- (void) createImageVTop {
    self.imageVTop = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_HEIGHT(540))];
    _imageVTop.image = [UIImage imageNamed:@"hb_a"];
    [self.view addSubview:_imageVTop];
}
- (void) createImageVBack {
    self.imageVBack = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _imageVBack.image = [UIImage imageNamed:@"hb_c"];
    [self.view addSubview:_imageVBack];
}
- (void) createImageVBottom {
    self.imageVBottom = [[UIImageView alloc] initWithFrame: CGRectMake(0, SCREEN_HEIGHT-ADAPT_HEIGHT(250), SCREEN_WIDTH, ADAPT_HEIGHT(250))];
    _imageVBottom.image = [UIImage imageNamed:@"hb_b"];
    [self.view addSubview:_imageVBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


//点击事件的动画
-(void)click{
    
    
    if (self.isFirst) {
        
        
        CALayer *layer = [[CALayer alloc] init];
        layer.cornerRadius = ADAPT_HEIGHT(320);
        layer.frame = CGRectMake(0, 0, layer.cornerRadius*2 , layer.cornerRadius*2);
        layer.borderWidth = 5;
        layer.position = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, ADAPT_HEIGHT(705) + ADAPT_HEIGHT(103));
        UIColor *color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];

        layer.borderColor =color.CGColor;
        //点击后扇形的边
        [self.view.layer addSublayer:layer];
        
        

        
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        _animaTionGroup = [CAAnimationGroup animation];
        _animaTionGroup.delegate = self;
        _animaTionGroup.duration = 2;
        _animaTionGroup.removedOnCompletion = YES;
        _animaTionGroup.timingFunction = defaultCurve;
        
        
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        scaleAnimation.fromValue = @0.0;
        scaleAnimation.toValue = @1;
        scaleAnimation.duration = 2;
        
        
        CAKeyframeAnimation *opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opencityAnimation.duration = 2;
        opencityAnimation.values = @[@0.8,@0.4,@0.0];
        opencityAnimation.keyTimes = @[@0,@0.5,@1];
        opencityAnimation.removedOnCompletion = YES;
        
        
        NSArray *animations = @[scaleAnimation,opencityAnimation];
        
        _animaTionGroup.animations = animations;
        [layer addAnimation:_animaTionGroup forKey:@"groupAnnimation"];
        
        [self performSelector:@selector(removeLayer:) withObject:layer afterDelay:1.5f];
        
    }
    self.isFirst = NO;
    
    
    
}


- (void)removeLayer:(CALayer *)layer
{
    [layer removeFromSuperlayer];
    [layer removeAnimationForKey:@"groupAnnimation"];
    
}
#pragma mark 解归档
- (NSArray *)getLocalRedPastArray{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:REDGETPAST];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    // 2.创建反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3.解码并存到数组中
    NSArray *RedGetPastArray = [unArchiver decodeObjectForKey:REDGETPAST];
    return RedGetPastArray;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    CGFloat x = SCREEN_WIDTH/2 - ADAPT_HEIGHT(103);
    CGFloat y = ADAPT_HEIGHT(705);
    CGFloat xw =  SCREEN_WIDTH/2 + ADAPT_HEIGHT(103);
    CGFloat yh = ADAPT_HEIGHT(705) + ADAPT_HEIGHT(206);
    
    if (point.x > x && point.x < xw && point.y > y && point.y < yh) {

        //点击次数
        NSLog(@"**** %ld ****",(long)_count);
        //百分之一的概率 发送请求
//        int luckNumber = arc4random() % 10;
//        if (luckNumber == 1) {
            //
            [self getXiuXiuXiu];
//        }
        //开始xiu动画
        _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(click)];
        _disPlayLink.frameInterval = 40;
        [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.isFirst = YES;
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        //响应咻咻动画
        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
            
            
        }];
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            //播放音效
            [self soundComeOut];
            [NSThread sleepForTimeInterval:2];
        }];
        [queue addOperation:op1];
        [queue addOperation:op2];
        
    }
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
    [super touchesEnded:touches withEvent:event];
    [self cancle];
}

- (void)cancle {
    self.isFirst = NO;
    [self.view.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink = nil;
    _count++;
}
//播放音效
-(void)soundComeOut{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"xiuVoice" ofType:@"mp3"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:audioUrl];
    myplayer = [[AVPlayer alloc]initWithPlayerItem:item];
    [myplayer play];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =YES;
    [GCDTimerManager cancelAllTimer];
    
    [self.timerEnd invalidate];
    self.timerEnd = nil;
    [self.timerWait invalidate];
    self.timerWait = nil;
//    [self.timerRedNumber invalidate];
//    self.timerRedNumber = nil;
    [self.timerPopToHome invalidate];
    self.timerPopToHome = nil;
}


@end
