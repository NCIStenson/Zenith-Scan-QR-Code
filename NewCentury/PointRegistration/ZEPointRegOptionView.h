//
//  PointRegOptionView.h
//  NewCentury
//
//  Created by Stenson on 16/1/21.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZEPointRegOptionViewDelegate <NSObject>

-(void)didSelectOption:(NSDictionary *)object;

@end;

@interface ZEPointRegOptionView : UIView

@property (nonatomic,assign) id <ZEPointRegOptionViewDelegate> delegate;

-(id)initWithOptionArr:(NSArray *)options showButtons:(BOOL)showBut withLevel:(TASK_LIST_LEVEL)level;

@end
