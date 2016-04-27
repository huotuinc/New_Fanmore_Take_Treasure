//
//  MineController.m
//  iOS_FanmoreIndiana
//
//  Created by 刘琛 on 16/1/22.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "MineController.h"
#import "LoginController.h"
#import "UserModel.h"
#import <UIView+BlocksKit.h>
#import <UIButton+WebCache.h>
#import "FanmoreUserController.h"
#import "OtherUserController.h"
#import "PayController.h"
#import "DetailViewController.h"
#import "AppGoodsListModel.h"
#import "RecordController.h"
#import "MCController.h"

@interface MineController ()

@end

@implementation MineController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:COLOR_NAV_BACK];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.pay.layer.cornerRadius = 5;

    
    
    [self.goahead bk_whenTapped:^{
        [self pushToRecordVCWithType:1];
    }];

    [self.announced bk_whenTapped:^{
        [self pushToRecordVCWithType:2];
    }];
    
    [self.record bk_whenTapped:^{
        [self pushToRecordVCWithType:0];
    }];
    
}

- (void)pushToRecordVCWithType:(NSInteger)type {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordController *record = [story instantiateViewControllerWithIdentifier:@"RecordController"];
    record.selectMark = type;
    [self.navigationController pushViewController:record animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    self.view.backgroundColor = COLOR_NAVBAR_A;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//    [self.navigationController.navigationBar setBarTintColor:COLOR_NAVBAR_A];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.pay.hidden = YES;

#pragma mark BC更改
    NSString * appExamineString = [[NSUserDefaults standardUserDefaults] stringForKey:AppExamine];
    if ([appExamineString isEqualToString:@"1"] ) {
        self.pay.hidden = YES;
    } else {
        self.pay.hidden = NO;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    if (![login isEqualToString:Success]) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginController *login = [story instantiateViewControllerWithIdentifier:@"LoginController"];
        login.isFromMall = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [path stringByAppendingPathComponent:UserInfo];
        UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        [self.logo sd_setBackgroundImageWithURL:[NSURL URLWithString:user.userHead] forState:UIControlStateNormal];
        self.nickname.text = user.realName;

#pragma bug
        self.money.text = [NSString stringWithFormat:@"%.2f", [user.money floatValue]];
        self.integral.text = [NSString stringWithFormat:@"积分:%ld", (long)user.integral];
        [self.logo bk_whenTapped:^{
            UIStoryboard *stroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            if ([user.userFormType intValue] == 0) {
                FanmoreUserController *fanmore = [stroy instantiateViewControllerWithIdentifier:@"FanmoreUserController"];
                [self.navigationController pushViewController:fanmore animated:YES];
//            }else {
//                OtherUserController *other = [stroy instantiateViewControllerWithIdentifier:@"OtherUserController"];
//                [self.navigationController pushViewController:other animated:YES];
//            }
            
            
        }];
        
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationIconBadgeNumber) {
        [_message setBackgroundImage:[UIImage imageNamed:@"xiaoxi_r"]forState:UIControlStateNormal];
    } else {
        [_message setBackgroundImage:[UIImage imageNamed:@"xiaoxi"]forState:UIControlStateNormal];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}




//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)userAction:(id)sender {
}

- (IBAction)payAction:(id)sender {
    
    UIStoryboard *story =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayController *payC = [story instantiateViewControllerWithIdentifier:@"PayController"];
    [self.navigationController pushViewController:payC animated:YES];
}
@end
