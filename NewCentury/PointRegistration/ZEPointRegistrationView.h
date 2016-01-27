//
//  ZEPointRegistrationView.h
//  NewCentury
//
//  Created by Stenson on 16/1/21.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEPointRegistrationView;

@protocol ZEPointRegistrationViewDelegate <NSObject>

/**
 *  选择工分登记界面row
 */
-(void)view:(ZEPointRegistrationView *)pointRegView didSelectRowAtIndexpath:(NSIndexPath *)indexpath withShowRules:(BOOL)showRules;

/**
 *  提交
 */
-(void)goSubmit:(ZEPointRegistrationView *)pointRegView withShowRoles:(BOOL)showRoles withShowCount:(BOOL)showCount;

/**
 *  返回扫描界面
 */
-(void)goBack;
@end

@interface ZEPointRegistrationView : UIView

@property (nonatomic,assign) id <ZEPointRegistrationViewDelegate> delegate;

-(id)initWithFrame:(CGRect)rect withIsFromScan:(BOOL)fromScan;

-(void)showListView:(NSArray *)listArr withLevel:(TASK_LIST_LEVEL)level withPointReg:(POINT_REG)pointReg;
-(void)showDateView;

/**
 *  刷新表
 */
-(void)reloadContentView:(BOOL)fromScanCode;

@end
