//
//  ZEHistoryModel.h
//  NewCentury
//
//  Created by Stenson on 16/1/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEHistoryModel : NSObject

@property (nonatomic,copy) NSString * TT_ENDDATE;
@property (nonatomic,copy) NSString * TT_TASK;
@property (nonatomic,copy) NSString * NDSX_NAME;
@property (nonatomic,copy) NSString * REAL_HOUR;

+(ZEHistoryModel *)getDetailWithDic:(NSDictionary *)dic;

@end
