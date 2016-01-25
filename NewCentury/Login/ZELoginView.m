//
//  ZELoginView.m
//  NewCentury
//
//  Created by Stenson on 16/1/22.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//


#define kUsernameLabMarginLeft  20.0f
#define kUsernameLabMarginTop   110.0f
#define kUsernameLabWidth       70.0f
#define kUsernameLabHeight      40.0f

#define kPasswordLabMarginLeft  kUsernameLabMarginLeft
#define kPasswordLabMarginTop   kUsernameLabMarginTop + 55.0f
#define kPasswordLabWidth       kUsernameLabWidth
#define kPasswordLabHeight      kUsernameLabHeight

#define kUsernameFieldMarginLeft  110.0f
#define kUsernameFieldMarginTop   kUsernameLabMarginTop
#define kUsernameFieldWidth       (SCREEN_WIDTH - kUsernameFieldMarginLeft - 20.0f)
#define kUsernameFieldHeight      40.0f

#define kPasswordFieldMarginLeft  kUsernameFieldMarginLeft
#define kPasswordFieldMarginTop   kUsernameFieldMarginTop + 55.0f
#define kPasswordFieldWidth       kUsernameFieldWidth
#define kPasswordFieldHeight      kUsernameLabHeight

// 登陆按钮位置
#define kLoginBtnWidth _viewFrame.size.width - 100.0f
#define kLoginBtnHeight 44.0f
#define kLoginBtnToLeft 50.0f
#define kLoginBtnToTop 254.0f + 12.f


#import "ZELoginView.h"

@interface ZELoginView ()<UITextFieldDelegate>
{
    CGRect _viewFrame;
    UIButton * loginBtn;
    
    UITextField * _usernameField;
    UITextField * _passwordField;
    
    
}
@end

@implementation ZELoginView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        self.backgroundColor = MAIN_COLOR;
        [self initInputView];
        [self initLoginBtn];
    }
    return self;
}

#pragma mark - custom view init
- (void)initInputView
{
    for (int i = 0 ; i < 2; i ++) {
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentRight;
        lab.text = @"用户名:";
        [self addSubview:lab];
        
        UITextField * field = [[UITextField alloc]init];
        field.delegate = self;
        field.textColor = [UIColor whiteColor];
        [self addSubview:field];
        field.clipsToBounds = YES;
        field.layer.cornerRadius = 5;
        field.layer.borderColor = [MAIN_LINE_COLOR CGColor];
        field.layer.borderWidth = 0.5;
        field.leftViewMode = UITextFieldViewModeAlways;
        field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];

        if (i == 1) {
            lab.text = @"密 码:";
            field.placeholder = @"请输入密码";
            [field setValue:[UIColor colorWithWhite:1 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
            field.secureTextEntry = YES;
            [field mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kPasswordFieldMarginLeft);
                make.top.offset(kPasswordFieldMarginTop);
                make.size.mas_equalTo(CGSizeMake(kPasswordFieldWidth, kPasswordFieldHeight));
            }];
            _passwordField = field;
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kPasswordLabMarginLeft);
                make.top.offset(kPasswordLabMarginTop);
                make.size.mas_equalTo(CGSizeMake(kPasswordLabWidth, kPasswordLabHeight));
            }];
        }else {
            field.placeholder = @"请输入用户名";
            [field setValue:[UIColor colorWithWhite:1 alpha:0.8] forKeyPath:@"_placeholderLabel.textColor"];
            [field mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kUsernameFieldMarginLeft);
                make.top.offset(kUsernameFieldMarginTop);
                make.size.mas_equalTo(CGSizeMake(kUsernameFieldWidth, kUsernameFieldHeight));
            }];
            _usernameField = field;
            _usernameField.text = @"00180897";
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kUsernameLabMarginLeft);
                make.top.offset(kUsernameLabMarginTop);
                make.size.mas_equalTo(CGSizeMake(kUsernameLabWidth, kUsernameLabHeight));
            }];
        }
    }
}

- (void)initLoginBtn
{
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(kLoginBtnToLeft, kLoginBtnToTop, kLoginBtnWidth, kLoginBtnHeight);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [loginBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [loginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    loginBtn.clipsToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = [MAIN_LINE_COLOR CGColor];
}

-(void)goLogin
{    
    if ([self.delegate respondsToSelector:@selector(goLogin:password:)]) {
        [self.delegate goLogin:_usernameField.text password:_passwordField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![_usernameField isExclusiveTouch]) {
        [_usernameField resignFirstResponder];
    }
    
    if (![_passwordField isExclusiveTouch]) {
        [_passwordField resignFirstResponder];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
