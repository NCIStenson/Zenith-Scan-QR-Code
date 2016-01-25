//
//  ZEPointRegistrationView.m
//  NewCentury
//
//  Created by Stenson on 16/1/21.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//

// 导航栏
#define kNavBarWidth SCREEN_WIDTH
#define kNavBarHeight 64.0f
#define kNavBarMarginLeft 0.0f
#define kNavBarMarginTop 0.0f

// 导航栏内左侧按钮
#define kRightButtonWidth 76.0f
#define kRightButtonHeight 40.0f
#define kRightButtonMarginRight -10.0f
#define kRightButtonMarginTop 20.0f + 2.0f
// 导航栏标题
#define kNavTitleLabelWidth SCREEN_WIDTH
#define kNavTitleLabelHeight 44.0f
#define kNavTitleLabelMarginLeft 0.0f
#define kNavTitleLabelMarginTop 20.0f

#define kContentViewMarginTop   64.0f
#define kContentViewMarginLeft  0.0f
#define kContentViewWidth       SCREEN_WIDTH
#define kContentViewHeight      (SCREEN_HEIGHT - kNavBarHeight - 44.0f)


#import "ZEPointRegistrationView.h"
#import "Masonry.h"
#import "JCAlertView.h"
#import "ZEPointRegOptionView.h"
#import "ZEPointRegChooseDateView.h"

#import "ZEPointRegModel.h"

@interface ZEPointRegistrationView ()<UITableViewDataSource,UITableViewDelegate,ZEPointRegOptionViewDelegate,ZEPointRegChooseDateViewDelegate>
{
    JCAlertView * _alertView;
    NSInteger _currentSelectRow;
    UITableView * _contentTableView;
    BOOL _showJobRules;
}

@end

@implementation ZEPointRegistrationView

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        
        [self initNavBar];
        [self initView];
    }
    return self;
}

- (void)initNavBar
{
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(kNavBarMarginLeft, kNavBarMarginTop, kNavBarWidth, kNavBarHeight)];
    [self addSubview:navBar];

    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kNavBarMarginLeft);
        make.top.offset(kNavBarMarginTop);
        make.size.mas_equalTo(CGSizeMake(kNavBarWidth, kNavBarHeight));
    }];
    navBar.backgroundColor = MAIN_COLOR;
    navBar.clipsToBounds = YES;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"icon_tick.png" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
//    [rightBtn addTarget:self action:@selector(goBackToTheRootView) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0,0)];

    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0,0)];
    [navBar addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(kRightButtonMarginRight);
        make.top.offset(kRightButtonMarginTop);
        make.size.mas_equalTo(CGSizeMake(kRightButtonWidth, kRightButtonHeight));
    }];
    
    UILabel *navTitleLabel = [UILabel new];
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.font = [UIFont systemFontOfSize:24.0f];
    navTitleLabel.text = @"工分登记";
    [navBar addSubview:navTitleLabel];
    [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.offset(kNavTitleLabelMarginLeft);
        make.top.offset(kNavTitleLabelMarginTop);
        make.size.mas_equalTo(CGSizeMake(kNavTitleLabelWidth, kNavTitleLabelHeight));
    }];
    
}

-(void)initView
{
    _contentTableView = [UITableView new];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_contentTableView];
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kContentViewMarginLeft);
        make.top.offset(kContentViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentViewWidth, kContentViewHeight));
    }];
}

#pragma mark - Public
-(void)showListView:(NSArray *)listArr withLevel:(TASK_LIST_LEVEL)level
{
    ZEPointRegOptionView * customAlertView = [[ZEPointRegOptionView alloc]initWithOptionArr:listArr showButtons:NO withLevel:level];
    customAlertView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:customAlertView dismissWhenTouchedBackground:YES];
    [_alertView show];
}
-(void)showDateView
{
    ZEPointRegChooseDateView * chooseDateView = [[ZEPointRegChooseDateView alloc]initWithFrame:CGRectZero];
    chooseDateView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:chooseDateView dismissWhenTouchedBackground:YES];
    [_alertView show];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showJobRules == YES) {
        return 8;
    }
    return  _showJobRules ? 8 : 7;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_showJobRules == YES) {
        cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row];
    }else{
        cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row];
        if (indexPath.row == 6 ) {
            cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row + 1];
        }
    }
   
    cell.detailTextLabel.text = @"请选择";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(10, 43.5f, SCREEN_WIDTH - 10, 0.5f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [cell.contentView.layer addSublayer:lineLayer];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentSelectRow = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(view:didSelectRowAtIndexpath:)]) {
        [self.delegate view:self didSelectRowAtIndexpath:indexPath];
    }
}

#pragma mark - ZEPointRegistrationViewDelegate
-(void)didSelectOption:(NSDictionary *)object
{
    UITableViewCell * cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectRow inSection:0]];
    if ([object isKindOfClass:[NSDictionary class]]) {
        ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:object];
        cell.detailTextLabel.text = model.TR_NAME;
        UITableViewCell * taskHoursCell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        taskHoursCell.detailTextLabel.text = model.TR_VALID;
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",object];
    }
    
    [_alertView dismissWithCompletion:nil];
    
//    if (_currentSelectRow == 3 && [str isEqualToString:@"2"]) {
//        _showJobRules = YES;
//        [_contentTableView reloadData];
//    }else if (_currentSelectRow == 3 && ![str isEqualToString:@"2"]){
//        _showJobRules = NO;
//        [_contentTableView reloadData];
//    }
  
}
#pragma mark - ZEPointRegChooseDateViewDelegate

-(void)cancelChooseDate
{
    [_alertView dismissWithCompletion:nil];
}
-(void)confirmChooseDate:(NSString *)dateStr
{
    UITableViewCell * cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectRow inSection:0]];
    cell.detailTextLabel.text = dateStr;
    [_alertView dismissWithCompletion:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
