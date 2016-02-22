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
{
    ZEPointRegistrationView * _pointView;
}

@end

@implementation ZEPointRegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
        
    _pointView = [[ZEPointRegistrationView alloc]initWithFrame:self.view.frame withEnterType:_enterType];
    _pointView.delegate = self;
    _pointView.historyModel = _hisModel;
    [self.view addSubview:_pointView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_enterType == ENTER_POINTREG_TYPE_SCAN) {
        [self getDateByCodeStr];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

-(void)getDateByCodeStr
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getServerDataByCodeStr:_codeStr Success:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary * dataDic = [data objectForKey:@"data"];
        [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TASK]:dataDic}];
        [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TYPE]:@"1"}];
        [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]:@"1"}];
        [_pointView reloadContentView:ENTER_POINTREG_TYPE_SCAN];
    } fail:^(NSError *errorCode) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - ZEPointRegistrationViewDelegate

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[ZEPointRegCache instance] clear];
    }];
}

-(void)goSubmit:(ZEPointRegistrationView *)pointRegView withShowRoles:(BOOL)showRoles withShowCount:(BOOL)showCount
{
    NSDictionary * choosedDic = [[ZEPointRegCache instance] getUserChoosedOptionDic];

    if(![ZEUtil isNotNull:[choosedDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]]){
        [self showAlertView:[NSString stringWithFormat:@"请选择%@",[ZEUtil getPointRegInformation:POINT_REG_TASK]]];
        return;
    }
    
    if(showRoles && ![ZEUtil isNotNull:[choosedDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]]){
        [self showAlertView:[NSString stringWithFormat:@"请选择%@",[ZEUtil getPointRegInformation:POINT_REG_JOB_ROLES]]];
        return;
    }

    [self submitMessageToServer:choosedDic withView:pointRegView];
    
 }
-(void)submitMessageToServer:(NSDictionary *)dic withView:(ZEPointRegistrationView *)pointRegView
{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];

    if(![ZEUtil isNotNull:[dataDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]]]){
        [dataDic setValue:@"1" forKey:@"times"];
    }
    
    [dataDic setValue:[ZESetLocalData getNumber] forKey:@"userid"];
    [dataDic setValue:[ZESetLocalData getUsername] forKey:@"username"];
    [dataDic setValue:[ZESetLocalData getOrgcode] forKey:@"userOrgcode"];
    [dataDic setValue:[ZESetLocalData getUnitcode] forKey:@"userUnitcode"];
    [dataDic setValue:[ZESetLocalData getOrgcode] forKey:@"userOrgCodeName"];
    [dataDic setValue:[ZESetLocalData getUnitName] forKey:@"userUintName"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer submitPointRegMessage:dataDic Success:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([ZEUtil isNotNull:data]) {
            if ([[data objectForKey:@"data"] integerValue] == 1) {
                [self showAlertView:@"提交成功"];
                if (_enterType != ENTER_POINTREG_TYPE_SCAN){
                    [[ZEPointRegCache instance] clear];
                    [pointRegView reloadContentView:ENTER_POINTREG_TYPE_DEFAULT];
                }
            }else{
                [self showAlertView:@"提交失败"];
            }
        }
    }
                                   fail:^(NSError *errorCode) {
                                       [self showAlertView:@"提交失败"];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       
                                   }];
    
}
-(void)showAlertView:(NSString *)str
{
    if (IS_IOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_enterType == ENTER_POINTREG_TYPE_SCAN) {
                [self goBack];
            }
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:str message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


-(void)view:(ZEPointRegistrationView *)pointRegView didSelectRowAtIndexpath:(NSIndexPath *)indexpath withShowRules:(BOOL)showRules
{
    switch (indexpath.row) {
        case 0:
            if(_enterType != ENTER_POINTREG_TYPE_SCAN){
                [self showTaskView:pointRegView];
            }
            break;
        case 1:
            [self showChooseDateView:pointRegView];
            break;
        case 3:
            [self showTypeView:pointRegView];
            break;
        case 4:
            [self showDiffCoeView:pointRegView];
            break;
        case 5:
            [self showTimeCoeView:pointRegView];
            break;
        case POINT_REG_JOB_ROLES:
        {
            if (showRules) {
                [self showWorkRolesView:pointRegView];
            }else{

            }
        }
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
        [pointRegView showTaskView:taskCacheArr];
    }else{
        [MBProgressHUD showHUDAddedTo:pointRegView animated:YES];
        [ZEUserServer getTaskDataSuccess:^(id data) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            if ([ZEUtil isNotNull:[data objectForKey:@"data"]]) {
                [[ZEPointRegCache instance] setTaskCaches:[data objectForKey:@"data"]];
                [pointRegView showTaskView:[data objectForKey:@"data"]];
            }
        } fail:^(NSError *errorCode) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];

        }];
    }
}

-(void)showDiffCoeView:(ZEPointRegistrationView *)pointRegView
{
    NSArray * diffCoeCacheArr = nil;
    diffCoeCacheArr = [[ZEPointRegCache instance] getDiffCoeCaches];
    
    if (diffCoeCacheArr.count > 0) {
        [pointRegView showListView:diffCoeCacheArr withLevel:TASK_LIST_LEVEL_JSON withPointReg:POINT_REG_DIFF_DEGREE];
    }else{
        [MBProgressHUD showHUDAddedTo:pointRegView animated:YES];
        [ZEUserServer getDiffCoeSuccess:^(id data) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            if ([ZEUtil isNotNull:[data objectForKey:@"data"]]) {
                [[ZEPointRegCache instance] setDiffCoeCaches:[data objectForKey:@"data"]];
                [pointRegView showListView:[data objectForKey:@"data"] withLevel:TASK_LIST_LEVEL_JSON withPointReg:POINT_REG_DIFF_DEGREE];
            }
        } fail:^(NSError *errorCode) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            
        }];
    }
    
}

-(void)showTimeCoeView:(ZEPointRegistrationView *)pointRegView
{
    NSArray * timeCoeCacheArr = nil;
    timeCoeCacheArr = [[ZEPointRegCache instance] getTimesCoeCaches];
    
    if (timeCoeCacheArr.count > 0) {
        [pointRegView showListView:timeCoeCacheArr withLevel:TASK_LIST_LEVEL_JSON withPointReg:POINT_REG_TIME_DEGREE];
    }else{
        [MBProgressHUD showHUDAddedTo:pointRegView animated:YES];
        [ZEUserServer getTimeCoeSuccess:^(id data) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            if ([ZEUtil isNotNull:[data objectForKey:@"data"]]) {
                [[ZEPointRegCache instance] setTimesCoeCaches:[data objectForKey:@"data"]];
                [pointRegView showListView:[data objectForKey:@"data"] withLevel:TASK_LIST_LEVEL_JSON withPointReg:POINT_REG_DIFF_DEGREE];
            }
        } fail:^(NSError *errorCode) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            
        }];
    }
    
}
-(void)showWorkRolesView:(ZEPointRegistrationView *)pointRegView
{
    NSArray * workRolesArr = nil;
    workRolesArr = [[ZEPointRegCache instance] getWorkRulesCaches];
    
    if (workRolesArr.count > 0) {
        [pointRegView showListView:workRolesArr withLevel:TASK_LIST_LEVEL_JSON withPointReg:POINT_REG_JOB_ROLES];
    }else{
        [MBProgressHUD showHUDAddedTo:pointRegView animated:YES];
        [ZEUserServer getWorkRolesSuccess:^(id data) {
            [MBProgressHUD hideAllHUDsForView:pointRegView animated:YES];
            if ([ZEUtil isNotNull:[data objectForKey:@"data"]]) {
                [[ZEPointRegCache instance] setWorkRulesCaches:[data objectForKey:@"data"]];
                [pointRegView showListView:[data objectForKey:@"data"] withLevel:TASK_LIST_LEVEL_JSON withPointReg:POINT_REG_JOB_ROLES];
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
    [pointRegView showListView:@[@"按系数分配",@"按人头均摊",@"按次分配",@"按工分*系数分配"] withLevel:TASK_LIST_LEVEL_NOJSON withPointReg:POINT_REG_TYPE];
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
