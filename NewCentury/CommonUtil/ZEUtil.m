//
//  ZEUtil.m
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEUtil.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation ZEUtil

+ (BOOL)isNotNull:(id)object
{
    if ([object isEqual:[NSNull null]]) {
        return NO;
    } else if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    } else if (object == nil) {
        return NO;
    }
    return YES;
}

+ (BOOL)isStrNotEmpty:(NSString *)str
{
    if ([ZEUtil isNotNull:str]) {
        if ([str isEqualToString:@""]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = nil;
    NSDate *dt2 = nil;
    dt1 = [df dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",date01]];
    dt2 = [df dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",date02]];
    
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
    }
    return ci;
}
+ (double)heightForString:(NSString *)str font:(UIFont *)font andWidth:(float)width
{
    double height = 0.0f;
    if (IS_IOS7) {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        height = ceil(rect.size.height);
    }
//    else {
//        CGSize sizeToFit = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//        height = sizeToFit.height;
//    }
    
    return height;
}

+ (double)widthForString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    double width = 0.0f;
    if (IS_IOS7) {
        CGRect rect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
        width = rect.size.width;
    }
//    else {
//        CGSize sizeToFit = [str sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
//        width = sizeToFit.width;
//    }
    return width;
}
+ (NSDictionary *)getSystemInfo
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *systemName = [[UIDevice currentDevice] systemName];
    
    NSString *device = [[UIDevice currentDevice] model];
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
    
    NSString *appBuildVersion = [bundleInfo objectForKey:@"CFBundleVersion"];
    
    NSArray *languageArray = [NSLocale preferredLanguages];
    
    NSString *language = [languageArray objectAtIndex:0];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *country = [locale localeIdentifier];
    
    // 手机型号
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    [infoDic setObject:country forKey:@"country"];
    [infoDic setObject:language forKey:@"language"];
    [infoDic setObject:systemName forKey:@"systemName"];
    [infoDic setObject:systemVersion forKey:@"systemVersion"];
    [infoDic setObject:device forKey:@"device"];
    [infoDic setObject:deviceModel forKey:@"deviceModel"];
    [infoDic setObject:appVersion forKey:@"appVersion"];
    [infoDic setObject:appBuildVersion forKey:@"appBuildVersion"];
    
    return infoDic;
}
+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * image = nil;
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd_HHmmssSSS"];
    return [df stringFromDate:date];
}

+ (NSString *)getPointRegInformation:(POINT_REG)point_reg
{
    switch (point_reg) {
        case POINT_REG_TASK:
            return @"工作任务";
            break;
        case POINT_REG_TIME:
            return @"发生日期";
            break;
        case POINT_REG_WORKING_HOURS:
            return @"核定工时";
            break;
        case POINT_REG_TYPE:
            return @"分摊类型";
            break;
        case POINT_REG_DIFF_DEGREE:
            return @"难度系数";
            break;
        case POINT_REG_TIME_DEGREE:
            return @"时间系数";
            break;
        case POINT_REG_JOB_ROLES:
            return @"工作角色";
            break;
        case POINT_REG_JOB_COUNT:
            return @"工作次数";
            break;
        default:
            return @"工作任务";
            break;
    }
}

+ (NSString *)getPointRegField:(POINT_REG)point_reg
{
    switch (point_reg) {
        case POINT_REG_TASK:
            return @"task";
            break;
        case POINT_REG_TIME:
            return @"date";
            break;
        case POINT_REG_WORKING_HOURS:
            return @"核定工时";
            break;
        case POINT_REG_TYPE:
            return @"shareType";
            break;
        case POINT_REG_DIFF_DEGREE:
            return @"difficultyCoefficient";
            break;
        case POINT_REG_TIME_DEGREE:
            return @"timeCoefficient";
            break;
        case POINT_REG_JOB_ROLES:
            return @"workrole";
            break;
        case POINT_REG_JOB_COUNT:
            return @"times";
            break;
        default:
            return @"task";
            break;
    }
}
//  获取分配类型中文
+ (NSString *)getPointRegShareType:(POINT_REG_SHARE_TYPE)point_reg_type
{
    switch (point_reg_type) {
        case POINT_REG_SHARE_TYPE_COE:
            return @"按系数分配";
            break;
        case POINT_REG_SHARE_TYPE_PEO:
            return @"按人头均摊";
            break;
        case POINT_REG_SHARE_TYPE_COUNT:
            return @"按次分配";
            break;
        case POINT_REG_SHARE_TYPE_WP:
            return @"按工分*系数分配";
        default:
            return @"按系数分配";
            break;
    }
}

+ (void)showAlertView:(NSString *)str viewController:(UIViewController *)viewCon
{

    if (IS_IOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [viewCon presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:str message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


@end
