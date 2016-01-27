//
//  ZEPointRegistrationVC.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZEPointRegistrationVC : UIViewController

@property (nonatomic,copy) NSString * codeStr;
@property (nonatomic,assign) BOOL sendRequest; // 扫码进入工分登记页面 发送请求 手动点入不请求

@end
