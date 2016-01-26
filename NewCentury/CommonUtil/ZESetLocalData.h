//
//  ZESetLocalData.h
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZESetLocalData : NSObject

+(void)setLocalUserData:(NSDictionary *)dic;
+(NSDictionary *)getUserData;
/**
 *  工号
 */

+(NSString *)getNumber;
/**
 *  用户名
 */

+(NSString *)getUsername;

/**
 *  部门
 */
+(NSString *)getOrgcode;
/**
 *  单位
 */
+(NSString *)getUnitcode;
/**
 *  部门名称
 */
+(NSString *)getUserOrgCodeName;
/**
 *  部门名称
 */
+(NSString *)getUnitName;


@end
