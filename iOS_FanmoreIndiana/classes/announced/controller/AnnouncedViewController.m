//
//  AnnouncedViewController.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/1.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "AnnouncedViewController.h"
#import "XLPlainFlowLayout.h"
#import "AnnouncedCollectionViewCell.h"
#import "AppNewOpenListModel.h"
#import "DetailViewController.h"
#import "AnnouncedBCollectionViewCell.h"
static NSString *cellAMain=@"cellAMain";
static NSString *cellABMain=@"cellABMain";

@interface AnnouncedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer        *m_timer;
@property (nonatomic, strong) NSMutableArray *openList;


@end

@implementation AnnouncedViewController{
    NSMutableArray *_timeArray;
    NSDate *resignBackgroundDate;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.view.backgroundColor=COLOR_BACK_MAIN;
    [self.navigationItem changeNavgationBarTitle:@"最新揭晓"];
    [self getOpenList ];
    [self createTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _openList=[NSMutableArray array];
    [self registerBackgoundNotification];
    [self createCollectionView];


}
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
    resignBackgroundDate = [NSDate date];
}

- (void)becomeActiveToRecordState
{
    NSTimeInterval timeHasGone = [[NSDate date] timeIntervalSinceDate:resignBackgroundDate];
//    (@"%f",timeHasGone);
    for (AppNewOpenListModel *openModel in _openList) {
        openModel.toAwardingTime =openModel.toAwardingTime - timeHasGone * 100;
    }
    //
}
- (void)setupRefresh
{
    
    
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOpenList)];
    _collectionView.mj_header = headRe;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(getNewData)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.tableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    //    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    //    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    
    MJRefreshAutoFooter * Footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreOpenList)];
    _collectionView.mj_footer = Footer;
    
    //        [_tableView addFooterWithTarget:self action:@selector(getMoreGoodList)];
    
    
}
#pragma mark 网络请求最新揭晓
/**
 *  下拉刷新
 */
- (void)getOpenList {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"lastId"] = @0;
    dic[@"curType"] = @0;
    
    [SVProgressHUD show];

    [UserLoginTool loginRequestGet:@"getNewOpenList" parame:dic success:^(id json) {
        
        LWLog(@"%@",json);
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            LWLog(@"%@",json[@"resultDescription"]);
            NSArray *temp = [AppNewOpenListModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            [self.openList removeAllObjects];
            [self.openList addObjectsFromArray:temp];
            for (int i = 0; i < _openList.count; i++) {
                AppNewOpenListModel *model = _openList[i];
                model.toAwardingTime = model.toAwardingTime * 100;
            }
            self.lastId = json[@"resultData"][@"sort"];
            self.curType = json[@"resultData"][@"type"];
            [_collectionView reloadData];
        }else{
            LWLog(@"%@",json[@"resultDescription"]);
        }
        [SVProgressHUD dismiss];
        [_collectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        LWLog(@"%@",error);
    }];
    
}

/**
 *  上拉加载更多
 */
- (void)getMoreOpenList {
//    dic[@"lastId"] = @0;
//    dic[@"curType"] = @0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"lastId"] = self.lastId;
    dic[@"curType"] = self.curType;
    
    [UserLoginTool loginRequestGet:@"getNewOpenList" parame:dic success:^(id json) {
        
        LWLog(@"%@",json);
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            NSArray *temp = [AppNewOpenListModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            for (int i = 0; i < temp.count; i++) {
                AppNewOpenListModel *model = temp[i];
                model.toAwardingTime = model.toAwardingTime * 100;
            }
            [self.openList addObjectsFromArray:temp];
            
            self.lastId = json[@"resultData"][@"sort"];
            self.curType = json[@"resultData"][@"type"];
            if (temp.count == 0) {
                
            }else {
                [_collectionView reloadData];
            }
        }
    } failure:^(NSError *error) {
        LWLog (@"%@",error);
    }];
    [_collectionView.mj_footer endRefreshing];

    
}

- (void)createTimer {
    self.m_timer = [NSTimer timerWithTimeInterval:0.01f target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    
    for (int count = 0; count < _openList.count; count++) {
        
        AppNewOpenListModel *model = _openList[count];
        [model countDown];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}



- (void)createCollectionView
{
    if (!_collectionView) {
        XLPlainFlowLayout *flowLayout = [[XLPlainFlowLayout alloc]init];
        flowLayout.naviHeight=0;
        flowLayout.minimumInteritemSpacing = 0.5;
        flowLayout.minimumLineSpacing = 1;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_BACK_MAIN;
        [_collectionView registerNib:[UINib nibWithNibName:@"AnnouncedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellAMain];
        [_collectionView registerNib:[UINib nibWithNibName:@"AnnouncedBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellABMain];
        
        [self.view addSubview:_collectionView];
        [self setupRefresh];
    }else {
        
    }
    
    
}

#pragma mark --collection 代理方法


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    LWLog(@"%ld", (long)indexPath.row);
    AppNewOpenListModel * model = _openList[indexPath.row];
    //待开奖
    if ([model.status integerValue] == 1) {
        AnnouncedCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier: cellAMain forIndexPath:indexPath];
        [cell loadData:model indexPath:indexPath];
        return cell;
    }
    //已开奖
    else{
        AnnouncedBCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier: cellABMain forIndexPath:indexPath];
        [cell loadData:model indexPath:indexPath];
        return cell;
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _openList.count;
    
}
///**
// *  cell尺寸
// */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 2 - 0.5, ADAPT_HEIGHT(520));
}
//
/////**
//// *  设置整体内边距
//// */
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

//flowLayout.minimumInteritemSpacing = 0.5;
//flowLayout.minimumLineSpacing = 1;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    
//    return 0.5;
//}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    AppNewOpenListModel * model = _openList[indexPath.item];
    if ([model.status integerValue] == 1) {
        AnnouncedCollectionViewCell *tmpCell = (AnnouncedCollectionViewCell *)cell;
        tmpCell.m_isDisplayed            = YES;
        [tmpCell loadData:_openList[indexPath.item] indexPath:indexPath];
    }else {
        AnnouncedBCollectionViewCell *tmpCell = (AnnouncedBCollectionViewCell *)cell;
        [tmpCell loadData:_openList[indexPath.item] indexPath:indexPath];
    }
    
}



//-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
////    AppNewOpenListModel * model = _openList[indexPath.item];
////    if ([model.status  integerValue] == 1) {
//        AnnouncedCollectionViewCell *tmpCell = (AnnouncedCollectionViewCell *)cell;
//        tmpCell.m_isDisplayed = NO;
////    }
////
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LWLog(@"Item ------ %ld",indexPath.item);
    LWLog(@"openList ----- %@",_openList);
    DetailViewController *detail=[[DetailViewController alloc]init];
    AppNewOpenListModel *model = _openList[indexPath.item];
    detail.issueId=model.issueId;
    detail.whichAPI=[NSNumber numberWithInteger:2];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.m_timer invalidate];
    self.m_timer = nil;
    [self.openList removeAllObjects];
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
