//
//  ZEUtil.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#define kNotiRefreshAuditView   @"kAuditRefresh"          // 审核过工分之后，通知工分审核界面刷新。
#define kNotiRefreshHistoryView @"kNotiRefreshHistoryView"// 审核过工分之后，通知工分审核界面刷新。
#define kShowAllTaskList        @"kShowAllTaskList"       // 显示全部任务列表

@interface ZEUtil : NSObject
// 检查对象是否为空
+ (BOOL)isNotNull:(id)object;
// 获取手机信息
+ (NSDictionary *)getSystemInfo;
// 检查字符串是否为空
+ (BOOL)isStrNotEmpty:(NSString *)str;
// 比较时间早晚
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;
// 计算文字高度
+ (double)heightForString:(NSString *)str font:(UIFont *)font andWidth:(float)width;

+ (double)widthForString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

// 根据颜色生成图片
+ (UIImage *)imageFromColor:(UIColor *)color;

//  时间格式化
+ (NSString *)formatDate:(NSDate *)date;

//  获取登记页面登记信息
+ (NSString *)getPointRegInformation:(POINT_REG)point_reg;

//  获取登记页面登记字段
+ (NSString *)getPointRegField:(POINT_REG)point_reg;
//  获取分配类型中文
+ (NSString *)getPointRegShareType:(POINT_REG_SHARE_TYPE)point_reg_type;

//  弹出提示框
+ (void)showAlertView:(NSString *)str viewController:(UIViewController *)viewCon;

//


@end
