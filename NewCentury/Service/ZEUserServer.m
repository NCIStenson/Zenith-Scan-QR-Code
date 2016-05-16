//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#define kCheckUpdate         @"checkUpdate"         //  检测更新

#define kLoginType           @"tologin"            //    登陆

#define kGetTeamRation       @"getTeamRation"       // 所有任务列表
#define kGetCommonRation     @"getCommonRation"     // 常用任务列表

#define kDiffCoeType         @"getDiff"            //  1 是难度系数 2 是时间系数
#define kGetWorkRole         @"getWorkRole"        // g工作角色
#define kInsertToTask        @"insertToTask"       // 提交工作数据
#define kGetRationItem       @"getRationItem"      // 获取扫描结果

#define kGetHistoryItem      @"getHistoryItem"     // 获取历史
#define kGetHistoryByDate    @"getHistoryByDate"   //根据时间查询历史列表

#define kQueryTeamTask       @"queryTeamTask"      //  获取工分审核列表
#define kAuditingTeamTask    @"auditingTeamTask"   //  进行审核
#define kQueryTeamTaskByDate @"queryTeamTaskByDate"//  当天日期审核列表
#define kUpdateTask          @"updateTask"         //  重新提交审核

#define kDeleteHistory       @"historyItemDelete"
#define kDeleteAudit         @"teamTaskDelete"

#import "ZEUserServer.h"

@implementation ZEUserServer

/**
 *  获取版本是否更新接口
 */

+ (void)getVersionUpdateSuccess:(ServerResponseSuccessBlock)successBlock
                           fail:(ServerResponseFailBlock)failBlock
{
    NSLog(@">>>  %@",[ZEUtil getSystemInfo]);
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:[ZEUtil getSystemInfo]
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:nil];
    
    NSString * jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kCheckUpdate,
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
 *  登录接口
 */
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
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetCommonRation,
                                                        @"data":[NSString stringWithFormat:@"%@#%@#%@",[ZESetLocalData getNumber],[ZESetLocalData getOrgcode],[ZESetLocalData getUnitcode]]}
                                           httpMethod:HTTPMETHOD_POST
                                              success:^(id data) {
                                                  successBlock(data);
                                              }
                                                 fail:^(NSError *errorCode) {
                                                     failBlock(errorCode);
                                                 }];
}

/**
 *   获取全部页面工作任务列表
 */

+ (void)getAllTaskDataSuccess:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetTeamRation,
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
                                                        @"data":[NSString stringWithFormat:@"%@#%@",codeStr,[ZESetLocalData getOrgcode]]}
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
                             page:(NSString *)pageNum
                          success:(ServerResponseSuccessBlock)successBlock
                             fail:(ServerResponseFailBlock)failBlock

{    
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kGetHistoryByDate,
                                                        @"data":[NSString stringWithFormat:@"%@#%@#%@#%@",[ZESetLocalData getNumber],pageNum,startDate,endDate]}
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
/**
 *  @author Zenith Electronic, 16-02-23 14:02:45
 *
 *  重新提交审核任务
 *
 *  @param resubmitDic  修改后的审核数据
 *  @param successBlock 提交成功处理
 *  @param failBlock    失败处理
 */
+ (void)updateTask:(NSDictionary *)resubmitDic
           success:(ServerResponseSuccessBlock)successBlock
              fail:(ServerResponseFailBlock)failBlock
{
    if(![ZEUtil isNotNull:resubmitDic]){
        failBlock(nil);
        return;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resubmitDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [[ZEServerEngine sharedInstance]requestWithParams:@{@"type":kUpdateTask,
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
 *  @author Zenith Electronic, 16-03-31 16:03:17
 *
 *  删除未审核历史记录
 *
 *  @param seqkey       主键
 *  @param successBlock <#successBlock description#>
 *  @param failBlock    <#failBlock description#>
 */
+ (void)deleteHistoryItem:(NSString *)seqkey
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance] requestWithParams:@{@"type":kDeleteHistory,
                                                         @"data":seqkey}
                                            httpMethod:HTTPMETHOD_POST
                                               success:^(id data) {
                                                   successBlock(data);
                                               } fail:^(NSError *errorCode) {
                                                   failBlock(errorCode);
                                               }];
}
/**
 *  @author Zenith Electronic, 16-03-31 16:03:17
 *
 *  删除未审核工分
 *
 *  @param seqkey       主键
 *  @param successBlock <#successBlock description#>
 *  @param failBlock    <#failBlock description#>
 */
+ (void)deleteTeamTask:(NSString *)seqkey
               success:(ServerResponseSuccessBlock)successBlock
                  fail:(ServerResponseFailBlock)failBlock
{
    [[ZEServerEngine sharedInstance] requestWithParams:@{@"type":kDeleteAudit,
                                                       @"data":seqkey}
                                          httpMethod:HTTPMETHOD_POST
                                             success:^(id data) {
                                                 successBlock(data);
                                             } fail:^(NSError *errorCode) {
                                                 failBlock(errorCode);
                                             }];
}
@end
