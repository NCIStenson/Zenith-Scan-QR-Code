//
//  ZEHistoryModel.m
//  NewCentury
//
//  Created by Stenson on 16/1/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEHistoryModel.h"

static ZEHistoryModel * historyModel = nil;
@implementation ZEHistoryModel

+(ZEHistoryModel *)getDetailWithDic:(NSDictionary *)dic
{
    historyModel = [[ZEHistoryModel alloc]init];
    
    historyModel.TT_ENDDATE    = [dic objectForKey:@"TT_ENDDATE"];
    historyModel.TT_FLAG       = [dic objectForKey:@"TT_FLAG"];
    historyModel.TT_TASK       = [dic objectForKey:@"TT_TASK"];
    historyModel.TT_HOUR       = [dic objectForKey:@"TT_HOUR"];
    historyModel.NDSX_NAME     = [dic objectForKey:@"NDSX_NAME"];
    historyModel.REAL_HOUR     = [dic objectForKey:@"REAL_HOUR"];
    historyModel.SJSX_NAME     = [dic objectForKey:@"SJSX_NAME"];
    historyModel.SJXS          = [dic objectForKey:@"SJXS"];
    historyModel.NDXS          = [dic objectForKey:@"NDXS"];
    historyModel.DISPATCH_TYPE = [dic objectForKey:@"DISPATCH_TYPE"];
    historyModel.seqkey        = [dic objectForKey:@"seqkey"];
    historyModel.integration   = [dic objectForKey:@"integration"];
    if([ZEUtil isNotNull:historyModel.integration]){
        historyModel.ROLENAME      = [historyModel.integration objectForKey:@"ROLENAME"];
        historyModel.TWR_ID        = [historyModel.integration objectForKey:@"TWR_ID"];
        historyModel.TTP_QUOTIETY  = [historyModel.integration objectForKey:@"TTP_QUOTIETY"];
        historyModel.TIMES         = [historyModel.integration objectForKey:@"TIMES"];
    }
    return historyModel;
}

@end
