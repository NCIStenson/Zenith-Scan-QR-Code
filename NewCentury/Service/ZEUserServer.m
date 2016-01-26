//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#define kLoginType      @"tologin"

#define kTaskType       @"getRation"
#define kDiffCoeType    @"getDiff"
#define kGetWorkRole    @"getWorkRole"
#define kInsertToTask   @"insertToTask"

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
                                                        @"data":[NSString stringWithFormat:@"%@#%@",[ZESetLocalData getOrgcode],[ZESetLocalData getUnitcode]]}
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
    NSError *error;
    NSLog(@"insertDic >>>>   %@",dic);
//    NSMutableDictionary * finalDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    NSDictionary * taskdic = [dic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
//    [finalDic setObject:[[NSString alloc] initWithData:taskJsonData encoding:NSUTF8StringEncoding] forKey:[ZEUtil getPointRegField:POINT_REG_TASK]];
//    NSLog(@" finalDic >>  %@",[finalDic objectForKey:@"task"]);
    
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
@end
