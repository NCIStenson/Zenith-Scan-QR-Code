//
//  ZEHistoryViewController.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEHistoryViewController.h"
#import "ZEHistoryView.h"
#import "MBProgressHUD.h"
#import "ZEUserServer.h"

#import "ZEHistoryDetailVC.h"
#import "ZEPointRegistrationVC.h"
@interface ZEHistoryViewController ()<ZEHistoryViewDelegate>
{
    ZEHistoryView * _historyView;
    NSInteger _currentPage;
}
@end

@implementation ZEHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    _historyView = [[ZEHistoryView alloc]initWithFrame:self.view.frame];
    _historyView.delegate = self;
    [self.view addSubview:_historyView];
    
    _currentPage = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _currentPage = 0;
    [_historyView canLoadMoreData];
    [self sendRequest];
}
-(void)sendRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getHistoryDataWithPage:[NSString stringWithFormat:@"%ld",(long)_currentPage]
                                 success:^(id data) {
                                     NSArray * dataArr = [data objectForKey:@"data"];
                                     if ([ZEUtil isNotNull:dataArr]) {
                                         if (_currentPage == 0) {
                                             [_historyView reloadFirstView:dataArr];
                                         }else{
                                             [_historyView reloadView:dataArr];
                                         }
                                         if (dataArr.count%20 == 0) {
                                             _currentPage += 1;
                                         }
                                     }
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
                                    fail:^(NSError *errorCode) {
                                        [_historyView headerEndRefreshing];
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)searchHistoryStartDate:(NSString *)startDate withEndDate:(NSString *)endDate{
    [_historyView showAlertView:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZEUserServer getHistoryDataByStartDate:startDate
                                    endDate:endDate
                                    success:^(id data) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        NSArray * dataArr = [data objectForKey:@"data"];
                                        if ([ZEUtil isNotNull:dataArr]) {
                                            if(dataArr.count > 0){
                                                [_historyView reloadSearchView:dataArr];
                                            }else{
                                                [ZEUtil showAlertView:@"未查询到历史数据" viewController:self];
                                            }
                                        }
    }
                                       fail:^(NSError *errorCode) {
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


#pragma mark - ZEHistoryViewDelegate

-(void)beginSearch:(ZEHistoryView *)hisView withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate
{
    if ([startDate isEqualToString:@"开始日期"]&&[endDate isEqualToString:@"结束日期"]) {
        [hisView showAlertView:YES];
        [ZEUtil showAlertView:@"请至少选择一个日期" viewController:self];
        return;
    }
    if ([self compareDate:startDate withDate:endDate] == -1) {
        [ZEUtil showAlertView:@"开始日期不能晚于结束日期" viewController:self];
        [hisView showAlertView:YES];
        return;
    }

    if ([startDate isEqualToString:@"开始日期"]) {
        [self searchHistoryStartDate:@"" withEndDate:endDate];
    }else if ([endDate isEqualToString:@"结束日期"]){
        [self searchHistoryStartDate:startDate withEndDate:@""];
    }else{
        [self searchHistoryStartDate:startDate withEndDate:endDate];
    }
    
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",date01]];
    dt2 = [df dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",date02]];

    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
    }
    return ci;
}


-(void)loadNewData:(ZEHistoryView *)hisView
{
    _currentPage = 0;
    [self sendRequest];
}

-(void)loadMoreData:(ZEHistoryView *)hisView
{
    [self sendRequest];
}

-(void)enterDetailView:(ZEHistoryModel *)hisMod
{
    if ([hisMod.TT_FLAG isEqualToString:@"未审核"]) {
        ZEPointRegistrationVC * pointRegVC = [[ZEPointRegistrationVC alloc]init];
        pointRegVC.enterType = ENTER_POINTREG_TYPE_HISTORY;
        pointRegVC.hisModel = hisMod;
        [self presentViewController:pointRegVC animated:YES completion:nil];
    }else{
        ZEHistoryDetailVC * detailVC = [[ZEHistoryDetailVC alloc]init];
        detailVC.hisModel = hisMod;
        [self presentViewController:detailVC animated:YES completion:nil];
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
