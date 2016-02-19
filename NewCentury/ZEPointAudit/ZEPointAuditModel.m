//
//  ZEPointAuditModel.m
//  NewCentury
//
//  Created by Stenson on 16/2/18.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEPointAuditModel.h"

static ZEPointAuditModel * PAModel = nil;
@implementation ZEPointAuditModel

+(ZEPointAuditModel *)getDetailWithDic:(NSDictionary *)dic
{
    PAModel = [[ZEPointAuditModel alloc]init];
    
    PAModel.TT_ENDDATE      = [dic objectForKey:@"TT_ENDDATE"];
    PAModel.TT_TASK         = [dic objectForKey:@"TT_TASK"];
    PAModel.TT_CONTENT      = [dic objectForKey:@"TT_CONTENT"];
    PAModel.TT_FLAG         = [dic objectForKey:@"TT_FLAG"];
    PAModel.TT_PERIOD       = [dic objectForKey:@"TT_PERIOD"];
    PAModel.TT_REMARK       = [dic objectForKey:@"TT_REMARK"];
    PAModel.REALKEY         = [dic objectForKey:@"REALKEY"];
    PAModel.SEQKEY          = [dic objectForKey:@"SEQKEY"];
    PAModel.SOURCES         = [dic objectForKey:@"SOURCES"];
    
    return PAModel;
}

@end
