//
//  ZEMainView.m
//  WeiXueTang
//
//  Created by Stenson on 16/3/3.
//  Copyright © 2016年  Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kToolKitBtnMarginLeft   0.0f
#define kToolKitBtnMarginTop    40.0f
#define kToolKitBtnWidth        SCREEN_WIDTH
#define kToolKitBtnHeight       80.0f

// 导航栏
#define kNavBarWidth SCREEN_WIDTH
#define kNavBarHeight 64.0f
#define kNavBarMarginLeft 0.0f
#define kNavBarMarginTop 0.0f

// 导航栏标题
#define kNavTitleLabelWidth (SCREEN_WIDTH - 110.0f)
#define kNavTitleLabelHeight 44.0f
#define kNavTitleLabelMarginLeft (kNavBarWidth - kNavTitleLabelWidth) / 2.0f
#define kNavTitleLabelMarginTop 20.0f


#import "ZEMainView.h"

@implementation ZEMainView

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {        
        [self initNavBar];
    }
    return self;
}
-(void)initNavBar
{
    UIView *navBar                = [[UIView alloc] initWithFrame:CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight)];
    navBar.backgroundColor        = MAIN_NAV_COLOR;

    UILabel * _titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(kNavTitleLabelMarginLeft, kNavTitleLabelMarginTop, kNavTitleLabelWidth, kNavTitleLabelHeight)];
    _titleLabel.backgroundColor   = [UIColor clearColor];
    _titleLabel.textAlignment     = NSTextAlignmentCenter;
    _titleLabel.textColor         = [UIColor whiteColor];
    _titleLabel.font              = [UIFont systemFontOfSize:22.0f];
    _titleLabel.text              = @"工分登记";
    [navBar addSubview:_titleLabel];

    [self addSubview:navBar];

    UIImage * bannerImg           = [UIImage imageNamed:@"banner.jpg"];
    UIImageView * bannerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH * (bannerImg.size.height / bannerImg.size.width))];
    bannerImageView.image         = bannerImg;
    [self addSubview:bannerImageView];
    
    for(int i = 0 ; i < 6 ; i ++){
        UIButton * enterBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn.frame          = CGRectMake(0 + SCREEN_WIDTH / 3 * i, (bannerImageView.frame.origin.y + bannerImageView.frame.size.height) , SCREEN_WIDTH / 3, (IPHONE4S_LESS ? 100 : 120));
        [enterBtn setImage:[UIImage imageNamed:@"home_toolkit"] forState:UIControlStateNormal];
        [self addSubview:enterBtn];
        [enterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        UILabel * tipsLabel     = [[UILabel alloc]init];
        tipsLabel.font          = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.frame         = CGRectMake(enterBtn.frame.origin.x, (enterBtn.frame.origin.y +( IPHONE4S_LESS ? 85 : 120)), SCREEN_WIDTH/3,30);
        [self addSubview:tipsLabel];
        
        switch (i) {
            case 0:
                [enterBtn setImage:[UIImage imageNamed:@"home_toolkit"] forState:UIControlStateNormal];
                tipsLabel.text  = @"二维码扫描";
                [enterBtn addTarget:self action:@selector(goScan) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [enterBtn setImage:[UIImage imageNamed:@"home_expertsassess"] forState:UIControlStateNormal];
                tipsLabel.text  = @"工分登记";
                [enterBtn addTarget:self action:@selector(goPointReg) forControlEvents:UIControlEventTouchUpInside];

                break;
            case 2:
                [enterBtn setImage:[UIImage imageNamed:@"home_personalskills"] forState:UIControlStateNormal];
                tipsLabel.text  = @"历史查询";
                [enterBtn addTarget:self action:@selector(goHistory) forControlEvents:UIControlEventTouchUpInside];

                break;
            case 3:
                enterBtn.frame  = CGRectMake(0 , (bannerImageView.frame.origin.y + bannerImageView.frame.size.height) + ( IPHONE4S_LESS ? 100 : 150) , SCREEN_WIDTH / 3, (IPHONE4S_LESS ? 100 : 120));
                tipsLabel.frame = CGRectMake(enterBtn.frame.origin.x,enterBtn.frame.origin.y + ( IPHONE4S_LESS ? 85 : 120), SCREEN_WIDTH/3,30);
                tipsLabel.text  = @"工分审核";
                [enterBtn addTarget:self action:@selector(goPointAudit) forControlEvents:UIControlEventTouchUpInside];
                [enterBtn setImage:[UIImage imageNamed:@"tab_dianzan"] forState:UIControlStateNormal];
                break;
            case 5:
            {
                enterBtn.frame  = CGRectMake(SCREEN_WIDTH / 3 * (i - 3) , (bannerImageView.frame.origin.y + bannerImageView.frame.size.height) + ( IPHONE4S_LESS ? 100 : 150) , SCREEN_WIDTH / 3, (IPHONE4S_LESS ? 100 : 120));
                tipsLabel.frame = CGRectMake(enterBtn.frame.origin.x,enterBtn.frame.origin.y + ( IPHONE4S_LESS ? 85 : 120), SCREEN_WIDTH/3,30);
                tipsLabel.text  = @"退出登录";
                [enterBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
                [enterBtn setImage:[UIImage imageNamed:@"home_download"] forState:UIControlStateNormal];
            }
                break;
            case 4:
                [enterBtn setImage:[UIImage imageNamed:@"home_toolkit"] forState:UIControlStateNormal];
                tipsLabel.text  = @"用户信息";
                enterBtn.frame  = CGRectMake(SCREEN_WIDTH / 3 * (i - 3) , (bannerImageView.frame.origin.y + bannerImageView.frame.size.height) + ( IPHONE4S_LESS ? 100 : 150) , SCREEN_WIDTH / 3, (IPHONE4S_LESS ? 100 : 120));
                tipsLabel.frame = CGRectMake(enterBtn.frame.origin.x,enterBtn.frame.origin.y + ( IPHONE4S_LESS ? 85 : 120), SCREEN_WIDTH/3,30);
                [enterBtn addTarget:self action:@selector(goUserCenter) forControlEvents:UIControlEventTouchUpInside];
                break;

            default:
                break;
        }
        
    }
    
    
}

#pragma mark - SelfDelegate

-(void)goScan
{
    if ([self.delegate respondsToSelector:@selector(goScanView) ]) {
        [self.delegate goScanView];
    }
}

-(void)goPointReg
{
    if ([self.delegate respondsToSelector:@selector(goPointReg) ]) {
        [self.delegate goPointReg];
    }
}

-(void)goHistory
{
    if ([self.delegate respondsToSelector:@selector(goHistory) ]) {
        [self.delegate goHistory];
    }
}
-(void)goPointAudit
{
    if ([self.delegate respondsToSelector:@selector(goPointAudit)]) {
        [self.delegate goPointAudit];
    }
}
-(void)logout{
    if ([self.delegate respondsToSelector:@selector(logout)]) {
        [self.delegate logout];
    }
}
-(void)goUserCenter
{
    if ([self.delegate respondsToSelector:@selector(goUserCenter)]) {
        [self.delegate goUserCenter];
    }
}


@end
