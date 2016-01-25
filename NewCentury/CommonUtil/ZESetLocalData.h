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

+(NSString *)getOrgcode;
+(NSString *)getUnitcode;

@end
