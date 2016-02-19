//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#define kLoginType          @"tologin"//    登陆

#define kTaskType           @"getRation"        //  任务列表
#define kDiffCoeType        @"getDiff"          //  1 是难度系数 2 是时间系数
#define kGetWorkRole        @"getWorkRole"      // g工作角色
#define kInsertToTask       @"insertToTask"     // 提交工作数据
#define kGetRationItem      @"getRationItem"    // 获取扫描结果

#define kGetHistoryItem     @"getHistoryItem"   // 获取历史
#define kGetHistoryByDate   @"getHistoryByDate"   //根据时间查询历史列表

#define kQueryTeamTask      @"queryTeamTask"    //  获取工分审核列表
#define kAuditingTeamTask   @"auditingTeamTask" //  进行审核
#define kQueryTeamTaskByDate   @"queryTeamTaskByDate" //  当天日期审核列表

#import "ZEUserServer.h"

@implementation ZEUserServer

+ (void)getLoginDataWithUsername:(NSString *)usernameStr
                    withPassword:(NSString *)passwordStr
                         success:(ServerResponseSuccessBlock)successBlock
                            fail:(ServerResponseFailBlock)failBlock
{ 
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kLoginType,
                                                        @"data":[NSString stringWithFormat:@"%@#%@",usernameStr,passwordStr]}
                                                        httpMethod:HTTPMETHOD_POST
                                                        success:^(id data) {
                                                            successBlock(data);
    }
                                                        fail:^(NSError *errorCode) {
                                                            failBlock(errorCode);
                                                        }];
}

+ (void)getTaskDataSuccess:(ServerResponseSuccessBlock)successBlock
                      fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kTaskType,
                                                        @"data":[NSString stringWithFormat:@"%@#%@#%@",[ZESetLocalData getNumber],[ZESetLocalData getOrgcode],[ZESetLocalData getUnitcode]]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
}

+ (void)getDiffCoeSuccess:(ServerResponseSuccessBlock)successBlock
                      fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kDiffCoeType,
                                                        @"data":[NSString stringWithFormat:@"1#%@",[ZESetLocalData getUnitcode]]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
}

+ (void)getTimeCoeSuccess:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kDiffCoeType,
                                                        @"data":[NSString stringWithFormat:@"2#%@",[ZESetLocalData getUnitcode]]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
}
+ (void)getWorkRolesSuccess:(ServerResponseSuccessBlock)successBlock
                       fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetWorkRole,
                                                        @"data":[NSString stringWithFormat:@"%@#%@",[ZESetLocalData getOrgcode],[ZESetLocalData getUnitcode]]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
}

/**
 *   提交工分信息
 */

+(void)submitPointRegMessage:(NSDictionary *)dic
                     Success:(ServerResponseSuccessBlock)successBlock
                        fail:(ServerResponseFailBlock)failBlock
{
    NSString * jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];

    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kInsertToTask,
                                                        @"data":jsonStr}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
    

}
/**
 *   扫描二维码获取登记信息
 */

+(void)getServerDataByCodeStr:(NSString *)codeStr
                      Success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetRationItem,
                                                        @"data":codeStr}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];

}
/**
 *   获取历史记录
 */

+(void)getHistoryDataWithPage:(NSString *)pageNum
                      success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock;
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetHistoryItem,
                                                        @"data":[NSString stringWithFormat:@"%@#%@",[ZESetLocalData getNumber],pageNum]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
}


/**
 *  根据时间查找记录
 */

+ (void)getHistoryDataByStartDate:(NSString *)startDate
                          endDate:(NSString *)endDate
                          success:(ServerResponseSuccessBlock)successBlock
                             fail:(ServerResponseFailBlock)failBlock

{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetHistoryByDate,
                                                        @"data":[NSString stringWithFormat:@"%@#%@#%@",[ZESetLocalData getNumber],startDate,endDate]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];

}

/**
 *  获取工分审核列表
 */
+ (void)getPointAuditWithPage:(NSString *)pageNum
                      success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock

{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kQueryTeamTask,
                                                        @"data":[NSString stringWithFormat:@"%@#%@#%@",[ZESetLocalData getOrgcode],[ZESetLocalData getUnitcode],pageNum]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
    
}

/**
 *  进行工分审核
 */
+ (void)auditingTeamTask:(NSArray *)taskArr
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock

{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:taskArr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kAuditingTeamTask,
                                                        @"data":jsonString}

                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
    
}
/**
 *  根据时间查询当天审核列表
 */
+ (void)queryTeamTaskByDate:(NSString *)dateStr
                    success:(ServerResponseSuccessBlock)successBlock
                       fail:(ServerResponseFailBlock)failBlock

{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kQueryTeamTaskByDate,
                                                        @"data":[NSString stringWithFormat:@"%@#%@#%@",[ZESetLocalData getOrgcode],[ZESetLocalData getUnitcode],dateStr]}
     
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
    
}

@end
