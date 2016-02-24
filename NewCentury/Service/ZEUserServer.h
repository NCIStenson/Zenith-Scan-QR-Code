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

#pragma mark - 工分登记

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

#pragma mark - 二维码扫描
/**
 *   扫描二维码获取登记信息
 */

+(void)getServerDataByCodeStr:(NSString *)codeStr
                      Success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock;

#pragma mark - 历史记录

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

#pragma mark - 工分审核
/**
 *  获取工分审核列表
 */
+ (void)getPointAuditWithPage:(NSString *)pageNum
                      success:(ServerResponseSuccessBlock)successBlock
                         fail:(ServerResponseFailBlock)failBlock;

/**
 *  进行工分审核
 */
+ (void)auditingTeamTask:(NSArray *)taskArr
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock;
/**
 *  根据时间查询当天审核列表
 */
+ (void)queryTeamTaskByDate:(NSString *)dateStr
                    success:(ServerResponseSuccessBlock)successBlock
                       fail:(ServerResponseFailBlock)failBlock;
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
              fail:(ServerResponseFailBlock)failBlock;

@end
