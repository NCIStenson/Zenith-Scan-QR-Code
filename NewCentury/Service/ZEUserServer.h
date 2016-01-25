//
//  ZEUserServer.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZEServerEngine.h"

@interface ZEUserServer : NSObject
/**
 *  登录接口
 */
+ (void)getLoginDataWithUsername:(NSString *)usernameStr
                    withPassword:(NSString *)passwordStr
                         success:(ServerResponseSuccessBlock)successBlock
                            fail:(ServerResponseFailBlock)failBlock;

/**
 *   获取登记页面工作任务列表
 */

+ (void)getTaskDataSuccess:(ServerResponseSuccessBlock)successBlock
                      fail:(ServerResponseFailBlock)failBlock;
@end
