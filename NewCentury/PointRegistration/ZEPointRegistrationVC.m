//
//  ZEPointRegistrationVC.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEPointRegistrationVC.h"
#import "ZEPointRegistrationView.h"
#import "ZEPointRegCache.h"
#import "MBProgressHUD.h"
#import "ZEUserServer.h"

@interface ZEPointRegistrationVC ()<ZEPointRegistrationViewDelegate>

@end

@implementation ZEPointRegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    ZEPointRegistrationView * pointView = [[ZEPointRegistrationView alloc]initWithFrame:self.view.frame];
    pointView.delegate = self;
    [self.view addSubview:pointView];
}

#pragma mark - ZEPointRegistrationViewDelegate

-(void)view:(ZEPointRegistrationView *)pointRegView didSelectRowAtIndexpath:(NSIndexPath *)indexpath
{
    switch (indexpath.row) {
        case 0:
            [self showTaskView:pointRegView];
            break;
            
        case 1:
            [self showChooseDateView:pointRegView];
            break;
            
        case 3:
            [self showTypeView:pointRegView];
            break;
            
        default:
            break;
    }
    
}
#pragma mark - 工作任务

-(void)showTaskView:(ZEPointRegistrationView *)pointRegView
{
    NSArray * taskCacheArr = nil;
    taskCacheArr = [[ZEPointRegCache instance] getTaskCaches];
    
    if (taskCacheArr.count > 0) {
        [pointRegView showListView:taskCacheArr withLevel:TASK_LIST_LEVEL_JSON];
    }else{
        [MBProgressHUD showHUDAddedTo:pointRegView animated:YES];
        [ZEUserServer getTaskDataSuccess:^(id data) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            if ([ZEUtil isNotNull:[data objectForKey:@"data"]]) {
                [[ZEPointRegCache instance] setTaskCaches:[data objectForKey:@"data"]];
                [pointRegView showListView:[data objectForKey:@"data"] withLevel:TASK_LIST_LEVEL_JSON];
            }
        } fail:^(NSError *errorCode) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];

        }];
    }
}
#pragma mark - 发生日期
-(void)showChooseDateView:(ZEPointRegistrationView *)pointRegView
{
    [pointRegView showDateView];
}
#pragma mark - 分摊类型

-(void)showTypeView:(ZEPointRegistrationView *)pointRegView
{
    [pointRegView showListView:@[@"按系数分配",@"按人头均摊",@"按次分配",@"按工分*系数分配"] withLevel:TASK_LIST_LEVEL_NOJSON];
}



#pragma mark -
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
