//
//  ZEUserServer.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#define kLoginType @"tologin"

#define kTaskType @"getRation"

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


@end
