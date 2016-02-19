//
//  ZEPointAuditModel.h
//  NewCentury
//
//  Created by Stenson on 16/2/18.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEPointAuditModel : NSObject

@property (nonatomic,copy) NSString * REALKEY;    //  实际工时
@property (nonatomic,copy) NSString * SEQKEY;      //   工作任务
@property (nonatomic,copy) NSString * SOURCES;   //   发生日期
@property (nonatomic,copy) NSString * TT_CONTENT;      //   核定工时
@property (nonatomic,copy) NSString * TT_ENDDATE;      //   分摊类型
@property (nonatomic,copy) NSString * TT_FLAG;    //  难度系数
@property (nonatomic,copy) NSString * TT_PERIOD;      //   时间系数
@property (nonatomic,copy) NSString * TT_REMARK;      //   时间系数
@property (nonatomic,copy) NSString * TT_TASK;      //   时间系数

+(ZEPointAuditModel *)getDetailWithDic:(NSDictionary *)dic;

@end
