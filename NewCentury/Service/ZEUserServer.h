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

/**
 *   获取难度系数列表
 */

+ (void)getDiffCoeSuccess:(ServerResponseSuccessBlock)successBlock
                      fail:(ServerResponseFailBlock)failBlock;

/**
 *   获取时间系数列表
 */
+ (void)getTimeCoeSuccess:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock;
/**
 *  获取角色列表
 */
+ (void)getWorkRolesSuccess:(ServerResponseSuccessBlock)successBlock
                       fail:(ServerResponseFailBlock)failBlock;

/**
 *   提交工分信息
 */

+(void)submitPointRegMessage:(NSDictionary *)dic
                     Success:(ServerResponseSuccessBlock)successBlock
                        fail:(ServerResponseFailBlock)failBlock;

/**
 *   扫描二维码获取登记信息
 */

+(void)getServerDataByCodeStr:(NSString *)codeStr
                      Success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock;

/**
 *   获取历史记录
 */

+(void)getHistoryDataWithPage:(NSString *)pageNum
                      success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock;


/**
 *  根据时间查找记录
 */

+ (void)getHistoryDataByStartDate:(NSString *)startDate
                          endDate:(NSString *)endDate
                          success:(ServerResponseSuccessBlock)successBlock
                             fail:(ServerResponseFailBlock)failBlock;


@end
