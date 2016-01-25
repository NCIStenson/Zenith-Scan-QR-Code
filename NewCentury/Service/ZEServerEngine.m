//
//  NCIServerEngine.m
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEServerEngine.h"

#define kServerErrorNotLogin                @"E020601" // 用户未登陆
#define kServerErrorLoginTimeOut            @"E020602" // 登陆超时
#define kServerErrorReqTimeOut              @"E020603" // 请求超时
#define kServerErrorIllegalReq              @"E020604" // 非法请求

static ZEServerEngine *serverEngine = nil;

@implementation ZEServerEngine

+ (ZEServerEngine *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverEngine = [[ZEServerEngine alloc] initSingle];
    });
    return serverEngine;
}

-(id)initSingle
{
    self = [super init];
    if ( self) {
        
    }
    return self;
}

-(void)requestWithParams:(NSDictionary *)params
              httpMethod:(NSString *)httpMethod
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock
{
    NSString * serverAdress = Zenith_Server;
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([httpMethod isEqualToString:HTTPMETHOD_GET]) {
        [sessionManager GET:serverAdress
                 parameters:nil
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                        if ([responseDic isKindOfClass:[NSDictionary class]] && [ZEUtil isNotNull:responseDic]) {
                            if (successBlock != nil) {
                                successBlock (responseDic);
                            }
                        }
        }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if (error != nil) {
                            failBlock(error);
                        }}];
    }else if ([httpMethod isEqualToString:HTTPMETHOD_POST])
    {
        [sessionManager POST:serverAdress
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if ([ZEUtil isNotNull:responseObject]) {
                             [self showNetErrorAlertView];
                         }
                         NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                         if ([responseDic isKindOfClass:[NSDictionary class]] && [ZEUtil isNotNull:responseDic]) {
                             if (successBlock != nil) {
                                 successBlock(responseDic);
                             }
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
    }
    
    
}

-(void)showNetErrorAlertView
{
    if (IS_IOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络连接异常，请重试"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"网络连接异常，请重试"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}



@end
