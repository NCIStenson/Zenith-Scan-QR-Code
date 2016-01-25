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

@end
