//
//  ZEAlertSearchView.m
//  NewCentury
//
//  Created by Stenson on 16/2/1.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

#import "ZEAlertSearchView.h"
#import "ZEPointRegChooseDateView.h"
#import "JCAlertView.h"

@interface ZEAlertSearchView ()<ZEPointRegChooseDateViewDelegate>
{
    CGRect _viewFrame;
    JCAlertView * _alertView;
    UIButton * _startDateBut;
    UIButton * _endDateBut;
}

@end
@implementation ZEAlertSearchView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 190.0f)];
    if (self) {
        _viewFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 190.0f);
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

-(void)initView
{
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
    titleLab.text = @"历史查询";
    titleLab.backgroundColor = MAIN_COLOR;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    for (int i = 0; i < 2; i ++) {
        
        UIButton * chooseDateBut = [UIButton buttonWithType:UIButtonTypeSystem];
        chooseDateBut.frame = CGRectMake(10 , 50.0f + 50 * i, _viewFrame.size.width - 20.0f, 40.0f);
        [chooseDateBut setTitle:@"开始日期" forState:UIControlStateNormal];
        [chooseDateBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        chooseDateBut.tag = i + 100;
        [chooseDateBut addTarget:self action:@selector(chooseDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chooseDateBut];
        if (i == 1) {
            _endDateBut = chooseDateBut;
            [chooseDateBut setTitle:@"结束日期" forState:UIControlStateNormal];
        }else{
            _startDateBut =chooseDateBut;
        }
        chooseDateBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        chooseDateBut.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        chooseDateBut.clipsToBounds = YES;
        chooseDateBut.layer.borderColor = [MAIN_LINE_COLOR CGColor];
        chooseDateBut.layer.borderWidth = 1;
        chooseDateBut.layer.cornerRadius = 5;
        
        
        UIButton * optionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        optionBtn.frame = CGRectMake(0 + _viewFrame.size.width / 2 * i , 146.0f, _viewFrame.size.width / 2, 44.0f);
        [optionBtn setTitle:@"取消" forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [optionBtn setBackgroundColor:MAIN_COLOR];
        optionBtn.tag = i;
        [optionBtn addTarget:self action:@selector(cancelSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionBtn];
        if (i == 1) {
            [optionBtn setTitle:@"查询" forState:UIControlStateNormal];
        }
    }
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(_viewFrame.size.width / 2 - 0.25f, 146.0f, 0.5, 44.0f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [self.layer addSublayer:lineLayer];
    
}


-(void)chooseDateBtnClick:(UIButton *)button
{
    ZEPointRegChooseDateView * chooseDateView = [[ZEPointRegChooseDateView alloc]initWithFrame:CGRectZero];
    chooseDateView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:chooseDateView dismissWhenTouchedBackground:YES];
    _alertView.tag = button.tag + 100;
    [_alertView show];
}

#pragma mark - ZEPointRegChooseDateViewDelegate

-(void)cancelChooseDate
{
    [_alertView dismissWithCompletion:nil];
}

-(void)confirmChooseDate:(NSString *)dateStr
{
    [_alertView dismissWithCompletion:^{
        if(_alertView.tag == 200){
            [_startDateBut setTitle:dateStr forState:UIControlStateNormal];
        }else{
            [_endDateBut setTitle:dateStr forState:UIControlStateNormal];
        }
    }];
}

-(void)cancelSearchBtnClick:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
                [self.delegate cancelSearch];
            }
        }
            break;
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(confirmSearchStartDate:endDate:)]) {
                [self.delegate confirmSearchStartDate:_startDateBut.titleLabel.text endDate:_endDateBut.titleLabel.text];
            }
        }
            break;
            
        default:
            break;
    }
}

@end