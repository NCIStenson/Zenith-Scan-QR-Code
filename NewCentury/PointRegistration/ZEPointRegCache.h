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

- (void)setTaskCaches:(NSArray *)taskArr;
- (NSArray *)getTaskCaches;


@end
