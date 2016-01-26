//
//  ZELoginViewController.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZELoginViewController.h"
#import "MBProgressHUD.h"
#import "ZELoginView.h"

#import "ZEUserServer.h"

#import "ZEScanQRViewController.h"
#import "ZEPointRegistrationVC.h"
#import "ZEHistoryViewController.h"

@interface ZELoginViewController ()<ZELoginViewDelegate>

@end

@implementation ZELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}
-(void)initView
{
    ZELoginView * loginView = [[ZELoginView alloc]initWithFrame:self.view.frame];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

#pragma mark - ZELoginViewDelegate

-(void)goLogin:(NSString *)username password:(NSString *)pwd
{
    if ([username isEqualToString:@""]) {
        if (IS_IOS8) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户名不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"用户名不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        return;
    }else if (![ZEUtil isStrNotEmpty:pwd]){
        if (IS_IOS8) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码不能为空"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                               style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"密码不能为空"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        return;
    }

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ZEUserServer getLoginDataWithUsername:username withPassword:pwd
                                   success:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       NSDictionary * dataDic = data;
                                       NSLog(@"%@",dataDic);
                                       if ([ZEUtil isNotNull:dataDic]) {
                                           if ([[dataDic objectForKey:@"login"] integerValue] == 0) {
                                               if (IS_IOS8) {
                                                   UIAlertController *alertController = [UIAlertController
                                                                                         alertControllerWithTitle:@"账号与密码不对应" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                                   UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的"
                                                                                                      style:UIAlertActionStyleDefault handler:nil];
                                                   [alertController addAction:okAction];
                                                   [self presentViewController:alertController animated:YES completion:nil];
                                                   
                                               }else{
                                                   UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"账号与密码不对应"
                                                                                                       message:nil
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"好的"
                                                                                             otherButtonTitles:nil, nil];
                                                   [alertView show];
                                               }

                                           }else if ([[dataDic objectForKey:@"login"] integerValue] == 1){
                                               [ZESetLocalData setLocalUserData:[dataDic objectForKey:@"data"]];
                                               [self goHome];
                                           }
                                       }
    }
                                      fail:^(NSError *errorCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      }];
    
    
}

-(void)goHome{
    ZEScanQRViewController * scanQRVC = [[ZEScanQRViewController alloc]init];
    scanQRVC.tabBarItem.image = [UIImage imageNamed:@"icon_home.png"];
    scanQRVC.title = @"首页";
    UINavigationController * scanQRNav = [[UINavigationController alloc]initWithRootViewController:scanQRVC];
    
    ZEPointRegistrationVC * pointVC = [[ZEPointRegistrationVC alloc]init];
    pointVC.tabBarItem.image = [UIImage imageNamed:@"icon_share_all.png"];
    pointVC.title = @"登记工分";
    UINavigationController * pointNav = [[UINavigationController alloc]initWithRootViewController:pointVC];
    
    ZEHistoryViewController * historyVC = [[ZEHistoryViewController alloc]init];
    historyVC.tabBarItem.image = [UIImage imageNamed:@"icon_history.png"];
    historyVC.title = @"历史记录";
    UINavigationController * historyNav = [[UINavigationController alloc]initWithRootViewController:historyVC];
    
    
    UITabBarController * tabBarVC = [[UITabBarController alloc]init];
    tabBarVC.viewControllers = @[scanQRNav,pointNav,historyNav];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabBarVC;
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
