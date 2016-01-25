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

-(void)view:(ZEPointRegistrationView *)pointRegView didSelectRowAtIndexpath:(NSIndexPath *)indexpath;

@end

@interface ZEPointRegistrationView : UIView

@property (nonatomic,assign) id <ZEPointRegistrationViewDelegate> delegate;

-(id)initWithFrame:(CGRect)rect;

-(void)showListView:(NSArray *)listArr withLevel:(TASK_LIST_LEVEL)level;
-(void)showDateView;

@end
