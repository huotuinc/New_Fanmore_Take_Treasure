//
//  ListViewController.m
//  iOS_FanmoreIndiana
//
//  Created by che on 16/2/20.
//  Copyright © 2016年 刘琛. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "ListBottomCView.h"
#import "PayViewController.h"
#import "AppBalanceModel.h"
#import "LoginController.h"
#import "ArchiveLocalData.h"
static NSString *cellLMain=@"cellLMain";
/**
 *  用于标识buttonAll的选中状态
 *  = 1 的时候 buttonAll为选中状态(selected) 此时labelAll.text= @"取消全选"
 *  = 2 的时候 buttonAll为选中状态(unselected) 此时labelAll.text= @"全选"
 */
static NSInteger selectAllCount = 1;

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,logVCdelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *cartList;//数据源数组
@property (nonatomic, strong)  NSMutableArray *selectedArray; //选中商品的数组

@property (strong, nonatomic)  ListBottomCView *bottomView;//结算视图
@property(nonatomic,strong) UIToolbar *toolbar;//完成视图
@property (nonatomic,strong) UIBarButtonItem *previousBarButton;//完成选项
@property (strong, nonatomic)  UIImageView *imageVBack; //购物车为0的时候的图片
@property (strong, nonatomic)  AppBalanceModel *balanceModel; //选中商品的数组
@property (assign, nonatomic)  BOOL emptyTheCart; //是否清空购物车

@end

@implementation ListViewController{
    BOOL isSelect;    //是否全选
    CGFloat _kbHeight;//键盘弹起高度
    NSString * _beginNumber;//textField输入前的number
    
}

-(void)viewWillAppear:(BOOL)animated
{


    [super viewWillAppear:animated];
//    LWLog(@"viewWillAppearAAAAAAAAAA");

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationItem changeNavgationBarTitle:@"清单"];
    self.tabBarController.tabBar.hidden = NO;

    isSelect = YES;
    [self getShoppingList];

    
//    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
//    if ([login isEqualToString:Success]) {
//        [self getShoppingList];
//    }else{
//        _cartList = [NSMutableArray arrayWithArray:[ArchiveLocalData unarchiveLocalDataArray]];
//        _selectedArray = [NSMutableArray arrayWithArray:[ArchiveLocalData unarchiveLocalDataArray]];
//        if (_cartList.count == 0) {
//            [self createImageVBack];
//        }else {
//            self.imageVBack.hidden = YES;
//            [self.tableView reloadData];
//            
//            _bottomView.buttonAll.selected = YES;
//            _bottomView.labelAll.text = @"取消全选";
//            [self countPrice];
//            selectAllCount = 1;
//        }
//    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    _cartList =[NSMutableArray array];
    [self createTableView];
    [self finshBarView];
    [self createBottomView];
    [self loadNotificationCell];
    [self createBarButtonItem];
}

- (void)createBarButtonItem{
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 25)];
    buttonL.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *bbiL=[[UIBarButtonItem alloc]initWithCustomView:buttonL];
    self.navigationItem.leftBarButtonItem=bbiL;
    
    
    UIButton *buttonR = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    [UIButton changeButton:buttonR AndFont:30 AndTitleColor:COLOR_SHINE_BLUE AndBackgroundColor:[UIColor whiteColor] AndBorderColor:nil AndCornerRadius:0 AndBorderWidth:0];
    [buttonR setTitle:@"清空清单" forState:UIControlStateNormal];
    [buttonR bk_whenTapped:^{
        //提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清空清单?" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //判断是否登陆
            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
            if ([login isEqualToString:Success]) {
                _emptyTheCart = YES;
                //已登陆
                [self deleteShoppingCart];
                [_cartList removeAllObjects];
                [_selectedArray removeAllObjects];
//                [_tableView removeFromSuperview];
                [self createImageVBack];

            }else{
                //未登录
                [_cartList removeAllObjects];
                [_selectedArray removeAllObjects];
                [ArchiveLocalData emptyTheLocalDataArray];
//                [_tableView removeFromSuperview];
                [self createImageVBack];
            }

            
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    UIBarButtonItem *bbiR=[[UIBarButtonItem alloc]initWithCustomView:buttonR];
    self.navigationItem.rightBarButtonItem=bbiR;
}


- (NSArray *)getLocalDataArray{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:LOCALCART];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    // 2.创建反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 3.解码并存到数组中
    NSArray *namesArray = [unArchiver decodeObjectForKey:LOCALCART];
    return namesArray;
}


- (void)setupRefresh
{
    
    
    MJRefreshNormalHeader * headRe = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getShoppingList)];
    _tableView.mj_header = headRe;

}

#pragma mark 网络请求购物车商品列表
/**
 *  下拉刷新
 */
- (void)getShoppingList{
    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
    //已登陆
    if ([login isEqualToString:Success]) {
        [SVProgressHUD show];
        [UserLoginTool loginRequestGet:@"getShoppingList" parame:nil success:^(id json) {
//            LWLog(@"%@",json);
            if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
                
//                LWLog(@"%@",json[@"resultDescription"]);
                NSArray *temp = [CartModel mj_objectArrayWithKeyValuesArray:json[@"resultData"][@"list"]];
                //            self.lastSort =json[@"resultData"][@"sort"];
                _cartList = [NSMutableArray array];
                _selectedArray = [NSMutableArray array];
                [self.cartList removeAllObjects];
                [self.cartList addObjectsFromArray:temp];
                for (CartModel *item in _cartList) {
                    item.isSelect = YES;
                }
                _selectedArray = [NSMutableArray arrayWithArray:_cartList];

                
            }else{
//                LWLog(@"%@",json[@"resultDescription"]);
            }
            [SVProgressHUD dismiss];
            if (_cartList.count == 0) {
                [self createImageVBack];
            }else {
                self.imageVBack.hidden = YES;
                self.tableView.hidden = NO;
                self.bottomView.hidden = NO;
                [self.tableView reloadData];
                _bottomView.labelAll.text = @"取消全选";
                [self countPrice];
                _bottomView.buttonAll.selected = YES;
                selectAllCount = 1;
            }
            
            [_tableView.mj_header endRefreshing];
            
//            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [_tableView.mj_header endRefreshing];
//            LWLog(@"%@",error);
        }];

    }
    //未登录
    else{
        _cartList = [[NSMutableArray alloc] initWithArray:[self getLocalDataArray]];
        for (int i = 0; i<_cartList.count; i++) {
            CartModel *cartM = _cartList[i];
            cartM.isSelect = YES;
        }
        if (_cartList.count == 0) {
            [self createImageVBack];
        }else {
                self.imageVBack.hidden = YES;
                self.tableView.hidden = NO;
                self.bottomView.hidden = NO;
                [self.tableView reloadData];
                _bottomView.labelAll.text = @"取消全选";
                _bottomView.buttonAll.selected = YES;
                _selectedArray = [NSMutableArray arrayWithArray:_cartList];
                [self countPrice];
                selectAllCount = 1;

        }
        [_tableView.mj_header endRefreshing];
    }
    
    
}

#pragma mark  网络删除商品

-(void)deleteShoppingCart {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_emptyTheCart == YES) {
        NSMutableString *emptyCartString = [NSMutableString string];
        for ( int i =0 ; i<_cartList.count; i++) {
            CartModel *model = _cartList[i];
            if (i == _cartList.count - 1) {
                [emptyCartString appendFormat:@"{shoppingCartId:%@}",model.sid];
            }else{
                [emptyCartString appendFormat:@"{shoppingCartId:%@},",model.sid];
            }
        }
        [emptyCartString insertString:@"[" atIndex:0];
        [emptyCartString appendString:@"]"];
        dic[@"shoppingCarts"] = emptyCartString;
        
    } else {
        NSString *delecateString = [[NSString alloc] initWithFormat:@"[{shoppingCartId:%@}]",self.shoppingCartId];
        dic[@"shoppingCarts"] = delecateString;
    }
    
    
    [UserLoginTool loginRequestPostWithFile:@"deleteShoppingCart" parame:dic success:^(id json) {
//        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
//            LWLog(@"%@",json[@"resultDescription"]);
        }else {
//            LWLog(@"%@",json[@"resultDescription"]);
        }
        
    } failure:^(NSError *error) {
//        LWLog(@"%@",error);
        
        
    } withFileKey:nil];
    
    
}
#pragma mark 网络请求结算 未登录 进行登陆
- (void)goToLogin {
    NSMutableString *AllCartsString = [NSMutableString string];
    
    for ( int i =0 ; i<_cartList.count; i++) {
        CartModel *model = _cartList[i];
        if (i == _cartList.count - 1) {
            [AllCartsString appendFormat:@"{issueId:%@,amount:%@}",model.issueId,model.userBuyAmount];
        }else{
            [AllCartsString appendFormat:@"{issueId:%@,amount:%@},",model.issueId,model.userBuyAmount];
        }
    }
    [AllCartsString insertString:@"[" atIndex:0];
    [AllCartsString appendString:@"]"];

    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *login = [story instantiateViewControllerWithIdentifier:@"LoginController"];
    login.isFromMall = NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    login.logDelegate = self;
//    login.cartsString = AllCartsString;
//    login.postData = 1;
    _bottomView.buttonGo.userInteractionEnabled = YES;
    [self presentViewController:nav animated:YES completion:nil];


    
}


#pragma mark 网络请求结算 已登录

- (void)goToPay {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableString *cartsString = [NSMutableString string];
    for ( int i =0 ; i<_selectedArray.count; i++) {
        CartModel *model = _selectedArray[i];
        if (i == _selectedArray.count - 1) {
            [cartsString appendFormat:@"{pid:%@,buyAmount:%@}",model.sid,model.userBuyAmount];
        }else{
            [cartsString appendFormat:@"{pid:%@,buyAmount:%@},",model.sid,model.userBuyAmount];
        }
    }
    [cartsString insertString:@"[" atIndex:0];
    [cartsString appendString:@"]"];
    dic[@"carts"] = cartsString;
    [UserLoginTool loginRequestPostWithFile:@"balance" parame:dic success:^(id json) {
//        LWLog(@"%@",json);
        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
//            LWLog(@"%@",json[@"resultDescription"]);
            _balanceModel = [AppBalanceModel mj_objectWithKeyValues:json[@"resultData"][@"data"]];
            PayViewController *pay = [[PayViewController alloc] init];
            pay.payModel = _balanceModel;
            pay.cartString = cartsString;
            _bottomView.buttonGo.userInteractionEnabled = YES;
            [self.navigationController pushViewController:pay animated:YES];
        }else {
            _bottomView.buttonGo.userInteractionEnabled = YES;
            [SVProgressHUD showInfoWithStatus:@"商品信息发生改变"];

//            LWLog(@"%@",json[@"resultDescription"]);
        }
        
    } failure:^(NSError *error) {
//        LWLog(@"%@",error);
        _bottomView.buttonGo.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:@"商品信息发生改变"];


        
    } withFileKey:nil];
    
}





-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}

-(void)finshBarView
{
//    if (!_toolbar) {
    [_toolbar removeFromSuperview];
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-ADAPT_HEIGHT(130) - 49 - 64, SCREEN_WIDTH, 44)];
        [_toolbar setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
        NSArray *barButtonItems = @[flexBarButton,self.previousBarButton];
        _toolbar.items = barButtonItems;
        [self.view addSubview:_toolbar];
//    }

}

- (void) previousButtonIsClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(void) createImageVBack{
    _tableView.hidden = YES;
    _toolbar.hidden =YES;
    _bottomView.hidden =YES;
//    _tableView = nil;
    if (_imageVBack) {
        _imageVBack.hidden =NO;
    }else {
        _imageVBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _imageVBack.image = [UIImage imageNamed:@"kkry"];
        [self.view addSubview:_imageVBack];
    }
    
}

-(void)createBottomView{
//    if (!_bottomView) {
//    [_bottomView removeFromSuperview];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ListBottomCView" owner:nil options:nil];
        _bottomView=[nib firstObject];
        _bottomView.frame=CGRectMake(0, SCREEN_HEIGHT-ADAPT_HEIGHT(130) - 49 - 64, SCREEN_WIDTH, ADAPT_HEIGHT(130));
        _bottomView.buttonAll.userInteractionEnabled=YES;
        [_bottomView.buttonAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.buttonGo bk_whenTapped:^{
            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
            if ([login isEqualToString:Success]) {
                if (_selectedArray.count != 0) {
                    _bottomView.buttonGo.userInteractionEnabled = NO;
                    [self goToPay];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"没有选中商品"];
                }
            }else{
                if (_selectedArray.count != 0) {
                    _bottomView.buttonGo.userInteractionEnabled = NO;
                    [self goToLogin];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"没有选中商品"];
                }
            }
            
        }];
        [self.view addSubview:_bottomView];
//    }

    
}

-(void)createTableView{
//    if (_tableView) {
//        return;
//    } else {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-ADAPT_HEIGHT(130) -64 -49 ) style:UITableViewStylePlain];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:cellLMain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //self.tableView.tableFooterView=[[UIView alloc]init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        //    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
        //    if ([login isEqualToString:Success]) {
        [self setupRefresh];
//    }

//    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellLMain forIndexPath:indexPath];
    
    //是否被选中
    if ([_selectedArray containsObject:[_cartList objectAtIndex:indexPath.row]]) {
        cell.isCellSelect = YES;
    }
    
    //选择回调
    cell.cartBlock = ^(BOOL isSelec){
        CartModel * model = _cartList[indexPath.row];
        //选中
        if (isSelec) {
            model.isSelect = YES;
            [_selectedArray addObject:[_cartList objectAtIndex:indexPath.row]];
        }
        else
        {
            CartModel *removeModel = [_cartList objectAtIndex:indexPath.row];
            for (NSInteger i = _selectedArray.count - 1; i>=0; i--) {
                CartModel *model = _selectedArray[i];
                if (model.issueId == removeModel.issueId) {
                    [_selectedArray removeObject:model];
                }
            }
            model.isSelect = NO;

            _bottomView.labelAll.text = @"全选";
            _bottomView.buttonAll.selected = NO;
            selectAllCount = 2;//再次点击buttonALL 进入selected状态
        }
        
        if (_selectedArray.count == _cartList.count) {
            _bottomView.buttonAll.selected = YES;
            _bottomView.labelAll.text = @"取消全选";
            selectAllCount = 1;
        }
        else
        {

        }
        
        //选中商品为0 相当于click一次buttonAll操作
        if (_selectedArray.count == 0) {
            selectAllCount = 2;
        }
        
        [self countPrice];
    };
    __block ListTableViewCell *weakCell = cell;
    //商品 + 方法
    cell.numAddBlock =^(){
//        NSLog(@"*******");

        NSInteger count = [weakCell.textFNumber.text integerValue];
        CartModel *model = [_cartList objectAtIndex:indexPath.row];
        NSInteger addNumber = [model.stepAmount integerValue];
        NSInteger remainAmount = [model.remainAmount integerValue];

//        if ([model.areaAmount integerValue] == 0) {
//            addNumber = 1;
//        }else {
//            addNumber = [model.areaAmount integerValue];
//        }
    
        count+= addNumber;
        if(count > remainAmount){
            count = remainAmount;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        
        weakCell.textFNumber.text = numStr;
        model.userBuyAmount = [NSNumber numberWithInteger:count];
//        NSLog(@"%@",_cartList[0]);
        [_cartList replaceObjectAtIndex:indexPath.row withObject:model];
        
        for (int i = (int)_selectedArray.count - 1; i>=0; i--) {
            CartModel *cModel = _selectedArray[i];
            if (cModel.issueId == model.issueId) {
                cModel.userBuyAmount = model.userBuyAmount;
//                [_selectedArray removeObject:cModel];
//                [_selectedArray addObject:model];
                
            }
        }
        [self countPrice];


    };
    //商品 - 方法
    cell.numCutBlock =^(){
//        NSLog(@"*******");
        NSInteger count = [weakCell.textFNumber.text integerValue];
        CartModel *model = [_cartList objectAtIndex:indexPath.row];
        NSInteger cutNumber = [model.stepAmount integerValue];

        count-= cutNumber;
        if(count <= 0){
            count = cutNumber;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        
        weakCell.textFNumber.text = numStr;
        
        model.userBuyAmount = [NSNumber numberWithInteger:count];
        
        [_cartList replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        for (NSInteger i = _selectedArray.count - 1; i>=0; i--) {
            CartModel *cModel = _selectedArray[i];
            if (cModel.issueId == model.issueId) {
                cModel.userBuyAmount = model.userBuyAmount;
            }
        }
        [self countPrice];

        //
    };
    cell.textFNumber.delegate=self;
    _kbHeight = cell.keyBoardHeight;
    [cell loadData:_cartList[indexPath.row] indexPath:indexPath];
    //    [cell reloadDataWith:[_cartList objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            CartModel *model = [_cartList objectAtIndex:indexPath.row];
            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus];
            if ([login isEqualToString:Success]) {
                [_cartList removeObjectAtIndex:indexPath.row];
                self.shoppingCartId = model.sid;
                [self deleteShoppingCart];
            }else{
                [self archiverTheLoaclArray:_cartList];
                NSMutableArray *localChangeArray = [NSMutableArray arrayWithArray:[self getLocalDataArray]];
                for (int i = 0; i < localChangeArray.count; i++) {
                    CartModel *changeModel = localChangeArray[i];
                    if (changeModel.issueId == model.issueId) {
                        [localChangeArray removeObject:changeModel];
                    }
                }
                [self archiverTheLoaclArray:localChangeArray];
                _cartList = [NSMutableArray arrayWithArray:[self getLocalDataArray]];
                
            }

            
            
            
            
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            
            
            //判断删除的商品是否被选中
            if ([_selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [_selectedArray removeObject:model];
                [self countPrice];
            }
            
            if (_cartList.count == _selectedArray.count) {
                _bottomView.labelAll.text = @"取消全选";
                _bottomView.buttonAll.selected = YES;
                selectAllCount= 1;//buttonAll再次点击进入 unselected状态
            }else{
                _bottomView.labelAll.text = @"全选";
                _bottomView.buttonAll.selected = NO;
                selectAllCount = 2;
            }
            
            if (_cartList.count == 0) {
                [self createImageVBack];
            }else{
                //延迟0.5s刷新一下,否则数据会乱
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            }
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//归档
- (void)archiverTheLoaclArray:(NSMutableArray *)localChangeArray{
    NSMutableData *data = [[NSMutableData alloc] init];
    //创建归档辅助类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //编码
    [archiver encodeObject:localChangeArray forKey:LOCALCART];
    //结束编码
    [archiver finishEncoding];
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filename = [[array objectAtIndex:0] stringByAppendingPathComponent:LOCALCART];
    //写入
    [data writeToFile:filename atomically:YES];
//    LWLog(@"归档成功");


}

-(void)reloadTable
{
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cartList.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ADAPT_HEIGHT(275);
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(void)selectAllBtnClick:(UIButton*)button
{
    //全选中
    if (selectAllCount  == 1) {
        _bottomView.labelAll.text = @"全选";
        _bottomView.buttonAll.selected = NO;
        [_selectedArray removeAllObjects];
        for (CartModel *model in _cartList) {
            model.isSelect = NO;
//            [_selectedArray addObject:model];
        }
        [self.tableView reloadData];
        
        [self countPrice];
        selectAllCount = 2;
    }
    //未选中
    if (selectAllCount == 2) {
        _bottomView.labelAll.text = @"取消全选";
        _bottomView.buttonAll.selected = YES;
        [_selectedArray removeAllObjects];
        for (CartModel *model in _cartList) {
            model.isSelect = YES;
            [_selectedArray addObject:model];
        }
        [self.tableView reloadData];
        [self countPrice];
        selectAllCount = 1;
        
    }
}

#pragma mark 计算价格
-(void)countPrice
{
    CGFloat totlePrice = 0;
    
    for (CartModel *model in _selectedArray) {
        //单价
        CGFloat price = [model.pricePercentAmount floatValue];
//        if ([model.areaAmount integerValue] == 0) {
//            price =1;
//        }else {
//            price = [model.areaAmount integerValue];
//        }
        totlePrice += price*[model.userBuyAmount floatValue];

    }
    _bottomView.labelMoney.text = [NSString stringWithFormat:@"总计%.2f元",totlePrice];
}


- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]]) {
            // -22
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, SCREEN_HEIGHT-_toolbar.frame.size.height-rect.size.height - 44 -22);
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, (sub.frame.size.height)/2);
            
        }else{
            if (maxY > y - 2) {
//                if ([sub isKindOfClass:[ListBottomCView class]]) {
//                    sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y  - maxY + y - ADAPT_HEIGHT(130));
//                }
                if ([sub isKindOfClass:[UIToolbar class]]) {
                    sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y  - maxY + y - ADAPT_HEIGHT(130));
                }
                
            }
        }
    }
//     _toolbar.frame=CGRectMake(0, SCREEN_HEIGHT -ADAPT_HEIGHT(130) - 44, SCREEN_WIDTH, ADAPT_HEIGHT(130));
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
    _toolbar.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _toolbar.frame.size.height);
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height-_bottomView.frame.size.height - 44, SCREEN_WIDTH, _bottomView.frame.size.height);
    //-44
    self.tableView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, SCREEN_HEIGHT-ADAPT_HEIGHT(130) - 44 -44);
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        
    }
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    NSLog(@"tf开始编辑");
    _beginNumber = textField.text;


    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    LWLog(@"tf结束编辑");
    NSInteger row = textField.tag -300;
    CartModel * model = _cartList[row];
    //倍数值
    NSInteger areNumber = [model.stepAmount integerValue];
//    if ([model.areaAmount integerValue] == 0) {
//        areNumber = 1 ;
//    }else {
//        areNumber = [model.areaAmount integerValue];
//    }
    if ([textField.text integerValue] % areNumber != 0 || [textField.text integerValue] <= 0) {
        textField.text = [NSString stringWithFormat:@"%@",_beginNumber];
//        model.buyAmount = [NSNumber numberWithInteger:[textField.text integerValue]];
        for (NSInteger i = _selectedArray.count - 1; i>=0; i--) {
            CartModel *cModel = _selectedArray[i];
            if (cModel.issueId == model.issueId) {
                cModel.userBuyAmount = model.userBuyAmount;
            }
        }
        [self countPrice];
        return YES;
    }
    if ([textField.text integerValue] > [model.remainAmount integerValue] || [textField.text integerValue] <= 0) {
        textField.text = [NSString stringWithFormat:@"%@",model.remainAmount];
        model.userBuyAmount = [NSNumber numberWithInteger:[textField.text integerValue]];
        for (NSInteger i = _selectedArray.count - 1; i>=0; i--) {
            CartModel *cModel = _selectedArray[i];
            if (cModel.issueId == model.issueId) {
                cModel.userBuyAmount = model.userBuyAmount;
            }
        }
        [self countPrice];
        return YES;
    }
    model.userBuyAmount = [NSNumber numberWithInteger:[textField.text integerValue]];
    //判断已选择数组里有无该对象,有就删除  重新添加
    for (NSInteger i = _selectedArray.count - 1; i>=0; i--) {
        CartModel *cModel = _selectedArray[i];
        if (cModel.issueId == model.issueId) {
            cModel.userBuyAmount = model.userBuyAmount;
        }
    }
    [self countPrice];
    return YES;
}

-(void)tableViewReloadData{
    [self getShoppingList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_imageVBack removeFromSuperview];
    _imageVBack =nil;

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
