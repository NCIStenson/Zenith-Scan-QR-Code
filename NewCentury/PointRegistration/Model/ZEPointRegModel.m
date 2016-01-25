//
//  ZEPointRegModel.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEPointRegModel.h"

static ZEPointRegModel * pointReg = nil;
@implementation ZEPointRegModel

+(ZEPointRegModel *)getDetailWithDic:(NSDictionary *)dic
{
    pointReg = [[ZEPointRegModel alloc]init];
    
    pointReg.DISPATCH_TYPE  = [dic objectForKey:@"DISPATCH_TYPE"];
    pointReg.SUITUNIT       = [dic objectForKey:@"SUITUNIT"];
    pointReg.TRC_ID         = [dic objectForKey:@"TRC_ID"];
    pointReg.TRC_NAME       = [dic objectForKey:@"TRC_NAME"];
    pointReg.TR_HOUR        = [dic objectForKey:@"TR_HOUR"];
    pointReg.TR_NAME        = [dic objectForKey:@"TR_NAME"];
    pointReg.TR_REMARK      = [dic objectForKey:@"TR_REMARK"];
    pointReg.TR_UNIT        = [dic objectForKey:@"TR_UNIT"];
    pointReg.TR_VALID       = [dic objectForKey:@"TR_VALID"];
    pointReg.USER_ORGID     = [dic objectForKey:@"USER_ORGID"];
    pointReg.seqkey         = [dic objectForKey:@"seqkey"];
    
    return pointReg;
}

@end
