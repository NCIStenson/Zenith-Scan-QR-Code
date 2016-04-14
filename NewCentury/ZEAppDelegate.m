//
//  AppDelegate.m
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEAppDelegate.h"

#import "ZELoginViewController.h"

#import "ZEScanQRViewController.h"
#import "ZEHistoryViewController.h"
#import "ZEPointRegistrationVC.h"
#import "ZEPointAuditViewController.h"

#import "ZEUserServer.h"

@interface ZEAppDelegate ()<UIAlertViewDelegate>

@end

@implementation ZEAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = YES;
    NSLog(@"%@",Zenith_Server);
    NSLog(@"%@",NSHomeDirectory());
    /***** 检测更新  *****/
    [self checkUpdate];
    
    ZEScanQRViewController * scanQRVC = [[ZEScanQRViewController alloc]init];
    scanQRVC.tabBarItem.image = [UIImage imageNamed:@"icon_home.png"];
    scanQRVC.title = @"首页";
    UINavigationController * scanQRNav = [[UINavigationController alloc]initWithRootViewController:scanQRVC];
    
    ZEPointRegistrationVC * pointVC = [[ZEPointRegistrationVC alloc]init];
    pointVC.tabBarItem.image = [UIImage imageNamed:@"icon_share_all.png"];
    pointVC.title = @"登记工分";
    pointVC.enterType = ENTER_POINTREG_TYPE_DEFAULT;
    UINavigationController * pointNav = [[UINavigationController alloc]initWithRootViewController:pointVC];
    
    ZEHistoryViewController * historyVC = [[ZEHistoryViewController alloc]init];
    historyVC.tabBarItem.image = [UIImage imageNamed:@"icon_history.png"];
    historyVC.title = @"历史记录";
    UINavigationController * historyNav = [[UINavigationController alloc]initWithRootViewController:historyVC];
    
    ZEPointAuditViewController * pointAuditVC = [[ZEPointAuditViewController alloc]init];
    pointAuditVC.tabBarItem.image = [UIImage imageNamed:@"tab_xiaoxi_normal"];
    pointAuditVC.title = @"工分审核";
    UINavigationController * pointAuditNav = [[UINavigationController alloc]initWithRootViewController:pointAuditVC];
    
    NSArray * viewControllerArr = @[scanQRNav,pointNav,historyNav];
    if([ZESetLocalData getRoleFlag]){
        viewControllerArr = @[scanQRNav,pointNav,historyNav,pointAuditNav];
    }
    UITabBarController * tabBarVC = [[UITabBarController alloc]init];
    tabBarVC.viewControllers = viewControllerArr;
    
    NSDictionary * userDataDic = [ZESetLocalData getUserData];
    if (userDataDic.allKeys > 0) {
        self.window.rootViewController = tabBarVC;
        return YES;
    }
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    self.window.rootViewController = tabBarVC;
    self.window.rootViewController = loginVC;

    return YES;
}

-(void)checkUpdate
{
    NSString* localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*)kCFBundleVersionKey];

    [ZEUserServer getVersionUpdateSuccess:^(id data) {
        if ([ZEUtil isNotNull:data]) {
            if([data objectForKey:@"data"]){
                NSDictionary * dic = [data objectForKey:@"data"];
                if ([localVersion floatValue] < [[dic objectForKey:@"versionCode"] floatValue]) {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"经检测当前版本不是最新版本，点击确定跳转更新。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    [alertView show];
                }
            }
        }
    } fail:^(NSError *errorCode) {
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
