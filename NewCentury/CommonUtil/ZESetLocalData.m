//
//  ZESetLocalData.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZESetLocalData.h"

static NSString * kUserInformation = @"keyUserInformation";

@implementation ZESetLocalData

+(id)Get:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSString *)GetStringWithKey:(NSString *)key
{
    id value = [self Get:key];
    
    if (value == [NSNull null] || value == nil) {
        return @"";
    }
    
    return value;
}

+(int)GetIntWithKey:(NSString *)key
{
    id value = [self Get:key];
    
    if (value == [NSNull null] || value == nil) {
        return -1;
    }
    
    return [value intValue];
}

+(void)Set:(NSString*)key value:(id)value
{
    if (value == [NSNull null] || value == nil) {
        value = @"";
    }
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLocalUserData:(NSDictionary *)dic
{
    [self Set:kUserInformation value:dic];
}

+(NSDictionary *)getUserData
{
    return [self Get:kUserInformation];
}

+(void)deleteLoaclUserData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInformation];
}

+(NSString *)getNumber
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"unum"];
}
/**
 *  用户名
 */

+(NSString *)getUsername
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"uname"];
}
+(NSString *)getOrgcode
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"orgcode"];
}

+(NSString *)getUnitcode
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"unitcode"];
}
/**
 *  账号权限
 */
+(BOOL)getRoleFlag
{
    NSDictionary * dic = [self getUserData];
    return [[dic objectForKey:@"roleFlag"] boolValue];
}

/**
 *  部门名称
 */
+(NSString *)getUserOrgCodeName
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"orgname"];
}
/**
 *  部门名称
 */
+(NSString *)getUnitName
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"unitname"];
}
/**
 *  获取登陆工号
 */
+(NSString*)getUnum
{
    NSDictionary * dic = [self getUserData];
    return [dic objectForKey:@"unum"];
}

@end
