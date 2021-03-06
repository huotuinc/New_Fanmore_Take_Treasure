//
//  MCController.m
//  fanmore---
//
//  Created by HuoTu-Mac on 15/7/3.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "MCController.h"
#import "MessageTableViewCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "AppDelegate.h"
#define pageSize 10

@interface MCController ()

/**消息存放数组*/
@property(nonatomic,strong) NSMutableArray * messageF;


@end


@implementation MCController



- (NSMutableArray *)messageF{
    if (_messageF == nil) {
        _messageF = [NSMutableArray array];
    }
    NSString* str= @"1,2,3";
    [str  componentsSeparatedByString:@","];
    return _messageF;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"消息中心";
    //集成刷新控件
    [self setupRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView removeSpaces];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
//    [self setClearBackground];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.tabBarController.tabBar.hidden =YES;
    
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    
    [self.tableView layoutIfNeeded];
    
    [self getNewMoreData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header = headRe;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    //#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
//    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableView.headerRefreshingText = @"正在刷新最新数据,请稍等";
//    
//    
//    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
//    
//    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//    self.tableView.footerRefreshingText = @"正在加载更多数据,请稍等";
    MJRefreshAutoFooter * Footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.tableView.mj_footer = Footer;
//    self.tableView.mj_footer.hidden = YES;
}
#pragma mark 开始进入刷新状态
//头部刷新
- (void)headerRereshing  //加载最新数据
{

   
    [self getNewMoreData];
    //    // 2.(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.tableView headerEndRefreshing];
}


//尾部刷新
- (void)footerRereshing{  //加载更多数据数据
    
    MessageFrame * task = [self.messageF lastObject];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"pagingTag"] = @(task.message.messageOrder);
    //    NSLog(@"尾部刷新%ld",task.taskOrder);
    params[@"pagingSize"] = @(pageSize);
    [self getMoreData:params];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.tableView footerEndRefreshing];
}


/**
 *   上拉加载更多
 *
 *
 */
- (void)getMoreData:(NSMutableDictionary *) params{
    


    __weak MCController * wself = self;
    [UserLoginTool loginRequestGet:@"messages" parame:params success:^(id json) {
        
        LWLog(@"%@",json);

        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==56001){

            return ;
        }
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue]==1) {//访问成果
            NSArray * taskArray = [Message mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"messages"]];
            if (taskArray.count > 0) {
                for (Message * aa in taskArray) {
                    //                    NSLog(@"%@  %lld",aa.context,aa.date);
                    MessageFrame *aas = [[MessageFrame alloc] init];
                    aas.message = aa;
                    [wself.messageF addObject:aas];
                    
                }
                [wself.tableView reloadData];
            }
            
        }
        
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
        
        [_tableView.mj_footer endRefreshing];
    }];
    
}


/**
 *  下拉加载更新数据
 */
-(void)getNewMoreData{
    
    

    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"pagingSize"] = @(pageSize);
    parame[@"pagingTag"] = @"";
    __weak MCController * wself = self;
    [UserLoginTool loginRequestGet:@"messages" parame:parame success:^(id json) {
        
        LWLog(@"%@",json);
        
        NSMutableArray * aaframe = [NSMutableArray array];
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            NSArray *messageArrays = [Message mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"messages"]];
            
            if (messageArrays.count == 0) {
//                [self.tableView setTabelViewListIsZero];
            }else {
//                [self.tableView setTableViewNormal];
            }
            
            if (messageArrays.count) {
                
                for (Message *aa in messageArrays) {
                    MessageFrame *aas = [[MessageFrame alloc] init];
                    aas.message = aa;
                    [aaframe addObject:aas];
                }
                [wself.messageF removeAllObjects];
                [wself.messageF addObjectsFromArray:aaframe];
 
                [wself.tableView reloadData];
            }
            
            
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络"];
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma tableView

//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 50;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageF.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell * cell = [MessageTableViewCell cellWithTableView:tableView];
    MessageFrame * meF = self.messageF[indexPath.row];
    cell.messageF = meF;
    //    cell.backgroundColor = [UIColor yellowColor];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageFrame * asb = self.messageF[indexPath.row];
    return asb.cellHeight+ 5;
}

#pragma 设置背景图片
- (void)setClearBackground {
    if (KScreenWidth == 375) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg750x1334"]];
    }
    if (KScreenWidth == 414) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg1242x2208"]];
    }
    if (KScreenWidth == 320) {
        if (KScreenWidth <= 480) {
            self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x960"]];
        }else {
            self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg640x1136"]];
        }
    }
}

- (void)setWiteBackground {
    self.tableView.backgroundColor = [UIColor whiteColor];
}

@end
