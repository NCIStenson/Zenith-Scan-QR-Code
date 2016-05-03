//
//  ZEMainViewController.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年  Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEMainViewController.h"

#import "ZEScanQRViewController.h"
#import "ZEPointRegistrationVC.h"
#import "ZEHistoryViewController.h"
#import "ZEPointAuditViewController.h"
#import "ZEUserCenterVC.h"
#import "ZELoginViewController.h"
#import "ZEPointRegCache.h"
@interface ZEMainViewController ()
{

}
@end

@implementation ZEMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self initView];
}
-(void)initView
{
    ZEMainView * mainView = [[ZEMainView alloc]initWithFrame:self.view.frame];
    mainView.delegate = self;
    [self.view addSubview:mainView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.tintColor = ;
//    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - ZEMainViewDelegate

-(void)goScanView
{
    ZEScanQRViewController * scanVC = [[ZEScanQRViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

-(void)goPointReg
{
    ZEPointRegistrationVC * pointVC = [[ZEPointRegistrationVC alloc]init];
    pointVC.enterType = ENTER_POINTREG_TYPE_DEFAULT;
    [self.navigationController pushViewController:pointVC animated:YES];
}

-(void)goHistory
{
    ZEHistoryViewController * historyVC = [[ZEHistoryViewController alloc]init];
    [self.navigationController pushViewController:historyVC animated:YES];
}
-(void)goPointAudit
{
    ZEPointAuditViewController * pointAuditVC = [[ZEPointAuditViewController alloc]init];
    [self.navigationController pushViewController:pointAuditVC animated:YES];
}
-(void)goUserCenter
{
    ZEUserCenterVC * userCenterVC = [[ZEUserCenterVC alloc]init];
    [self.navigationController pushViewController:userCenterVC animated:YES];
}
-(void)logout{
    
    [ZESetLocalData deleteLoaclUserData];
    [[ZEPointRegCache instance] clear];
        
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    ZELoginViewController * loginVC =[[ZELoginViewController alloc]init];
    window.rootViewController = loginVC;
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
