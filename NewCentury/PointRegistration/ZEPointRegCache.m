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
    NSArray * _taskCaches;
}
@end

static ZEPointRegCache * pointRegCahe = nil;

@implementation ZEPointRegCache

-(id)initSingle
{
    self = [super init];
    if (self) {
        
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

- (void)setTaskCaches:(NSArray *)taskArr
{
    _taskCaches = taskArr;
}
- (NSArray *)getTaskCaches
{
    return _taskCaches;
}


@end
