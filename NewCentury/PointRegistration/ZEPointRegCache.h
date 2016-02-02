//
//  ZEPointRegCache.h
//  NewCentury
//
//  Created by Stenson on 16/1/21.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEPointRegCache : NSObject

+ (ZEPointRegCache*)instance;

/**
 *  存储用户第一次请求任务列表，APP运行期间 只请求一次任务列表
 */
- (void)setTaskCaches:(NSArray *)taskArr;
- (NSArray *)getTaskCaches;

/**
 *  存储用户第一次请求难度系数列表，APP运行期间 只请求一次难度系数列表
*/
- (void)setDiffCoeCaches:(NSArray *)diffCoeArr;
- (NSArray *)getDiffCoeCaches;
/**
 *  存储用户第一次请求时间系数列表，APP运行期间 只请求一次时间系数列表
 */
- (void)setTimesCoeCaches:(NSArray *)timesCoeArr;
- (NSArray *)getTimesCoeCaches;

/**
 *  存储用户第一次请求 工作角色 列表，APP运行期间 只请求一次 工作角色 列表
 */
- (void)setWorkRulesCaches:(NSArray *)workRulesArr;
- (NSArray *)getWorkRulesCaches;

/**
 *  存储用户选择过的选项
 */
- (void)setUserChoosedOptionDic:(NSDictionary *)choosedDic;
- (NSDictionary * )getUserChoosedOptionDic;

/**
 *  清除输入次数缓存
 */
-(void)clearCount;

/**
 *  清除工作角色缓存
 */
-(void)clearRoles;

/**
 *  清空缓存
 */

- (void)clear;

@end
