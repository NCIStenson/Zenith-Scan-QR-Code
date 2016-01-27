//
//  ZEPointRegCache.m
//  NewCentury
//
//  Created by Stenson on 16/1/21.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEPointRegCache.h"

@interface ZEPointRegCache ()
{
    NSArray * _taskCachesArr;          //  任务列表缓存
    NSArray * _diffCoeCachesArr;       //  难度系数
    NSArray * _timesCoeCachesArr;      //  时间系数
    NSArray * _workRulesCachesArr;     //  工作角色
    NSMutableDictionary * _optionDic; // 用户选择信息缓存
}
@property(nonatomic,retain) NSDictionary * optionDic;
@property (nonatomic,retain) NSArray * taskCachesArr;
@property (nonatomic,retain) NSArray * diffCoeCachesArr;
@property (nonatomic,retain) NSArray * timesCoeCachesArr;
@property (nonatomic,retain) NSArray * workRulesCachesArr;

@end

static ZEPointRegCache * pointRegCahe = nil;

@implementation ZEPointRegCache

-(id)initSingle
{
    self = [super init];
    if (self) {
//        self.optionDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)init
{
    return [ZEPointRegCache instance];
}

+(ZEPointRegCache *)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        pointRegCahe = [[ZEPointRegCache alloc] initSingle];
    });
    return pointRegCahe;
}

/**
 *  存储用户第一次请求任务列表，APP运行期间 只请求一次任务列表
 */
- (void)setTaskCaches:(NSArray *)taskArr
{
    self.taskCachesArr = taskArr;
}
- (NSArray *)getTaskCaches
{
    return self.taskCachesArr;
}

/**
 *  存储用户第一次请求 难度系数 列表，APP运行期间 只请求一次 难度系数 列表
 */
- (void)setDiffCoeCaches:(NSArray *)diffCoeArr
{
    self.diffCoeCachesArr = diffCoeArr;
}
- (NSArray *)getDiffCoeCaches
{
    return self.diffCoeCachesArr;
}
/**
 *  存储用户第一次请求时间系数列表，APP运行期间 只请求一次时间系数列表
 */
- (void)setTimesCoeCaches:(NSArray *)timesCoeArr
{
    self.timesCoeCachesArr = timesCoeArr;
}
- (NSArray *)getTimesCoeCaches
{
    return self.timesCoeCachesArr;
}

/**
 *  存储用户第一次请求 工作角色 列表，APP运行期间 只请求一次 工作角色 列表
 */
- (void)setWorkRulesCaches:(NSArray *)workRulesArr
{
    self.workRulesCachesArr = workRulesArr;
}
- (NSArray *)getWorkRulesCaches
{
    return self.workRulesCachesArr;
}

/**
 *  存储用户选择过的选项
 */
- (void)setOptionDic:(NSDictionary *)choosedDic
{
    _optionDic = [NSMutableDictionary dictionaryWithDictionary:choosedDic];
}

- (void)setUserChoosedOptionDic:(NSDictionary *)choosedDic
{
    _optionDic = [NSMutableDictionary dictionaryWithDictionary:[self getUserChoosedOptionDic]];
    if ([ZEUtil isNotNull:choosedDic]) {
        [_optionDic setValue:choosedDic.allValues[0] forKey:choosedDic.allKeys[0]];
    }
}
- (NSDictionary * )getUserChoosedOptionDic
{
    return _optionDic;
}

/**
 *  清除输入次数缓存
 */
-(void)clearCount
{
    if ([ZEUtil isNotNull:[_optionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]]]) {
        [_optionDic removeObjectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]];
    }
}

/**
 *  清除工作角色缓存
 */
-(void)clearRoles
{
    if ([ZEUtil isNotNull:[_optionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]]) {
        [_optionDic removeObjectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]];
    }
}

/**
 *  清空缓存
 */

- (void)clear
{
    _taskCachesArr      = nil;        //  任务列表缓存
    _diffCoeCachesArr   = nil;       //  难度系数
    _timesCoeCachesArr  = nil;      //  时间系数
    _workRulesCachesArr = nil;     //  工作角色
    _optionDic          = nil;    // 用户选择信息缓存
}

@end
