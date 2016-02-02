//
//  ZEHistoryView.h
//  NewCentury
//
//  Created by Stenson on 16/1/27.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZEHistoryView;
@protocol ZEHistoryViewDelegate <NSObject>

/**
 *  刷新界面
 */
-(void)loadNewData:(ZEHistoryView * )hisView;

/**
 *  加载更多数据
 */
-(void)loadMoreData:(ZEHistoryView * )hisView;

/**
 *  查询按钮点击
 */
-(void)goSearch;

/**
 *  开始查询
 */
-(void)beginSearch:(ZEHistoryView *)hisView withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate;

@end

@interface ZEHistoryView : UIView

@property (nonatomic,assign) id <ZEHistoryViewDelegate> delegate;

-(id)initWithFrame:(CGRect)rect;
/**
 *  刷新数据
 */
-(void)reloadFirstView:(NSArray *)array;
/**
 *  刷新数据
 */
-(void)reloadView:(NSArray *)array;
/**
 *  刷新搜索结果页面
 */
-(void)reloadSearchView:(NSArray *)array;
/**
 *    没有更多数据了
 */

-(void)loadNoMoreData;
/**
 *    加载更多数据
 */
-(void)canLoadMoreData;
/**
 *  隐藏弹出框
 */
-(void)showAlertView:(BOOL)isShow;

@end
