//
//  ClassViewController.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/1/21.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassATableViewCell.h"
#import "ClassBTableViewCell.h"
#import "AppCategoryListModel.h"
#import "TenViewController.h"
static NSString *cellClassA=@"cellClassA";
static NSString *cellClassB=@"cellClassB";

@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleList;


@end

@implementation ClassViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationItem changeNavgationBarTitle:@"分类浏览"];
    [self getTitleList];
    
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleList = [NSMutableArray array];
    [self createBarButtonItem];
    [self createTableView];

}
- (void)getTitleList {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"lastId"] = @0;
    [UserLoginTool loginRequestGet:@"getCategoryList" parame:dic success:^(id json) {
        
        LWLog(@"%@",json);
        
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
            
            LWLog(@"%@",json[@"resultDescription"]);
            NSArray *temp = [AppCategoryListModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
            [self.titleList removeAllObjects];
            [self.titleList addObjectsFromArray:temp];
            [_tableView reloadData];
        }else{
            LWLog(@"%@",json[@"resultDescription"]);
        }
        
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
    }];
    
}


- (void)createBarButtonItem{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:COLOR_NAV_BACK];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"ClassATableViewCell" bundle:nil]forCellReuseIdentifier:cellClassA];
    [_tableView registerNib:[UINib nibWithNibName:@"ClassBTableViewCell" bundle:nil]forCellReuseIdentifier:cellClassB];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ClassATableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellClassA forIndexPath:indexPath];
        cell.labelClass.text=@"全部商品";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        ClassBTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellClassB forIndexPath:indexPath];
        cell.labelClassB.text=@"分类浏览";
        cell.labelClassB.font=[UIFont systemFontOfSize:FONT_SIZE(22)];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row >1){
        ClassBTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellClassB forIndexPath:indexPath];
        AppCategoryListModel *model =_titleList[indexPath.row - 2];
        cell.labelClassB.text=model.title;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleList.count +2 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return ADAPT_HEIGHT(130);
    }else if (indexPath.row == 1) {
        return ADAPT_HEIGHT(70);
    }else{
        return ADAPT_HEIGHT(100);
    }
    
}
//1 10元专区进去 2 全部进入(有分页参数) 3商品分类(pid)进入 4其他进入(有分页参数)

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TenViewController *ten = [[TenViewController alloc]init];
    if (indexPath.row == 0) {
        ten.whichAPI = 2;
        ten.tenTitle = @"全部商品";
        [self.navigationController pushViewController:ten animated:YES];
        return;
    }else if (indexPath.row == 1) {
    
    } else {
        AppCategoryListModel *model = _titleList[indexPath.row - 2];
        if ([model.type integerValue] == 0) {
            ten.whichAPI = 1;
            ten.tenTitle =model.title;
            [self.navigationController pushViewController:ten  animated:YES];
        }
        if ([model.type integerValue] == 1) {
            ten.whichAPI = 3;
            ten.pid = model.pid;
            ten.tenTitle = model.title;
            [self.navigationController pushViewController:ten  animated:YES];
        }
        if ([model.type integerValue] == 2) {
            ten.whichAPI = 4;
            ten.tenTitle = @"其它商品";
            [self.navigationController pushViewController:ten  animated:YES];
        }

    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
