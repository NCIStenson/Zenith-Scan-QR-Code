//
//  ZEPointAuditView.h
//  NewCentury
//
//  Created by Stenson on 16/2/17.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEPointAuditModel.h"
@class ZEPointAuditView;
@protocol ZEPointAuditViewDelegate <NSObject>

/**
 *  刷新界面
 */
-(void)loadNewData:(ZEPointAuditView * )hisView;

/**
 *  加载更多数据
 */
-(void)loadMoreData:(ZEPointAuditView * )hisView;


/**
 *  是否审核
 */
-(void)confirmWeatherAudit:(ZEPointAuditView *)hisView withModel:(ZEPointAuditModel *)pointAM;

/**
 *  审核界面
 */

-(void)goAuditVC;

@end

@interface ZEPointAuditView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id <ZEPointAuditViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;
/**
 *  刷新界面
 */
-(void)reloadFirstView:(NSArray *)array;
-(void)reloadView:(NSArray *)array;
/**
 *  停止刷新
 */
-(void)headerEndRefreshing;

/**
 *  审核成功，刷新界面
 */
-(void)auditSuccessRefreshView;

@end