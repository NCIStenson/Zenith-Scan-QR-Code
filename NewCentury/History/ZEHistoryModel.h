//
//  ZEHistoryModel.h
//  NewCentury
//
//  Created by Stenson on 16/1/28.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEHistoryModel : NSObject

@property (nonatomic,copy) NSString * REAL_HOUR;    //  实际工时
@property (nonatomic,copy) NSString * TT_TASK;      //   工作任务
@property (nonatomic,copy) NSString * TT_ENDDATE;   //   发生日期
@property (nonatomic,copy) NSString * TT_HOUR;      //   核定工时
@property (nonatomic,copy) NSString * DISPATCH_TYPE;      //   分摊类型
@property (nonatomic,copy) NSString * NDSX_NAME;    //  难度系数
@property (nonatomic,copy) NSString * SJSX_NAME;      //   时间系数



@property (nonatomic,retain) NSDictionary * integration;
+(ZEHistoryModel *)getDetailWithDic:(NSDictionary *)dic;

@end