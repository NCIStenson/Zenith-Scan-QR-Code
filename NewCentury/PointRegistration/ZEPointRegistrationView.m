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

// 返回按钮位置
#define kCloseBtnWidth  60.0f
#define kCloseBtnHeight 60.0f
#define kCloseBtnMarginLeft 10.0f
#define kCloseBtnMarginTop 12.0f

// 导航栏内右侧按钮
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
#import "ZEPointChooseTaskView.h"
#import "ZEPointRegModel.h"
#import "ZEPointRegCache.h"

@interface ZEPointRegistrationView ()<UITableViewDataSource,UITableViewDelegate,ZEPointRegOptionViewDelegate,ZEPointRegChooseDateViewDelegate,ZEPointChooseTaskViewDelegate,UITextFieldDelegate>
{
    JCAlertView * _alertView;
    NSInteger _currentSelectRow;
    UITableView * _contentTableView;
    BOOL _showJobRules; // 分摊类型为 按系数分配时  需用户选择角色
    BOOL _showJobCount; // 按次数分配时 输入次数
    ENTER_POINTREG_TYPE _enterType;
    UITextField * _countField;
}

@end

@implementation ZEPointRegistrationView

-(id)initWithFrame:(CGRect)rect withEnterType:(ENTER_POINTREG_TYPE)enterType;
{
    self = [super initWithFrame:rect];
    if (self) {
        _enterType = enterType;
        _showJobRules = YES;
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
    [rightBtn addTarget:self action:@selector(goSubmit) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (_enterType != ENTER_POINTREG_TYPE_DEFAULT) {
        [self showLeftBackButton];
    }
    
}

-(void)initView
{
    _contentTableView = [UITableView new];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.backgroundColor = [UIColor clearColor];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_contentTableView];
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kContentViewMarginLeft);
        make.top.offset(kContentViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentViewWidth, kContentViewHeight));
    }];
}

-(void)showLeftBackButton
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kCloseBtnMarginLeft, kCloseBtnMarginTop, kCloseBtnWidth, kCloseBtnHeight);
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn setImage:[UIImage imageNamed:@"icon_back" color:[UIColor whiteColor]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:closeBtn];
}


#pragma mark - Public
/**
 *  刷新表
 */
-(void)reloadContentView:(ENTER_POINTREG_TYPE)entertype
{
    _enterType = entertype;
    
    _showJobRules = YES;
    
    [_contentTableView reloadData];
}

-(void)showListView:(NSArray *)listArr withLevel:(TASK_LIST_LEVEL)level withPointReg:(POINT_REG)pointReg
{
    ZEPointRegOptionView * customAlertView = [[ZEPointRegOptionView alloc]initWithOptionArr:listArr showButtons:NO withLevel:level withPointReg:pointReg];
    customAlertView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:customAlertView dismissWhenTouchedBackground:YES];
    [_alertView show];
}
-(void)showTaskView:(NSArray *)array
{
    ZEPointChooseTaskView * chooseTaskView = [[ZEPointChooseTaskView alloc]initWithOptionArr:array];
    chooseTaskView.delegate = self;
    _alertView = [[JCAlertView alloc]initWithCustomView:chooseTaskView dismissWhenTouchedBackground:YES];
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
//    if (_enterType == ENTER_POINTREG_TYPE_HISTORY) {
//        if (!_showJobCount&&!_showJobRules){
//            return 7;
//        }
//        return 8;
//    }
    
    if (!_showJobCount&&!_showJobRules){
        return 6;
    }
    
    return 7;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_showJobRules == YES) {
        cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row];
    }else if(_showJobCount == YES){
        cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row];
        if (indexPath.row == 6 ) {
            cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row + 1];
        }
    }else{
        cell.textLabel.text = [ZEUtil getPointRegInformation:indexPath.row];
    }
    if(_enterType == ENTER_POINTREG_TYPE_SCAN){
        [self setScanCodeListDetailText:indexPath.row cell:cell];
    }else if(_enterType == ENTER_POINTREG_TYPE_HISTORY){
        [self setHistoryListDetailText:indexPath.row cell:cell];
    }else{
        [self setListDetailText:indexPath.row cell:cell];
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = MAIN_COLOR;
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(10, 43.5f, SCREEN_WIDTH - 10, 0.5f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [cell.contentView.layer addSublayer:lineLayer];
    
    return cell;
}
#pragma mark - 默认界面
-(void)setListDetailText:(NSInteger)row cell:(UITableViewCell *)cell
{
    NSDictionary * choosedOptionDic = [[ZEPointRegCache instance] getUserChoosedOptionDic];
    cell.detailTextLabel.text = @"请选择";
    switch (row) {
        case POINT_REG_TASK:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]];
                cell.detailTextLabel.text = model.TR_NAME;
            }
        }
            break;
        case POINT_REG_TIME:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME]]]) {
                cell.detailTextLabel.text = [choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME]];
            }else {
                NSDate * date = [NSDate date];
                NSDateFormatter * matter = [[NSDateFormatter alloc]init];
                matter.dateFormat = @"yyyy-MM-dd";
                NSString * dateStr = [matter stringFromDate:date];
                [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TIME]:dateStr}];
                cell.detailTextLabel.text = dateStr;
            }
        }
            break;
        case POINT_REG_WORKING_HOURS:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]];
                cell.detailTextLabel.text = model.TR_HOUR;
            }else{
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        case POINT_REG_TYPE:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TYPE]]]) {
                cell.detailTextLabel.text = [ZEUtil getPointRegShareType:[[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TYPE]] integerValue]];
            }else{
                [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TYPE]:@"1"}];
                
                cell.detailTextLabel.text = [ZEUtil getPointRegShareType:[[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TYPE]] integerValue]];
            }
        }
            break;
        case POINT_REG_DIFF_DEGREE:
        {
            cell.detailTextLabel.text = @"正常天气";
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]];
                cell.detailTextLabel.text = model.TWR_NAME;
            }
        }
            break;
            
        case POINT_REG_TIME_DEGREE:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME_DEGREE]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME_DEGREE]]];
                cell.detailTextLabel.text = model.NDXS_LEVEL;
            }
            cell.detailTextLabel.text = @"正常工作日";
        }
            break;
            
        case POINT_REG_JOB_ROLES:
            if (_showJobRules) {
                if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]]) {
                    ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]];
                    cell.detailTextLabel.text = model.TWR_NAME;
                }
            }else if (_showJobCount){
                cell.detailTextLabel.text = @"次";
                
                float fieldLeft = 0;
                fieldLeft = SCREEN_WIDTH - 200.0f - 30.0f;
                if (IPHONE6P){
                    fieldLeft = SCREEN_WIDTH - 200.0f - 35.0f;
                }
                
                _countField = [[UITextField alloc]initWithFrame:CGRectMake(fieldLeft, 2.0f, 200.0f, 44.0f)];
                _countField.textColor = cell.detailTextLabel.textColor;
                _countField.keyboardType = UIKeyboardTypeNumberPad;
                _countField.text = @"1";
                _countField.delegate = self;
                _countField.font = [UIFont systemFontOfSize:14];
                _countField.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:_countField];
                
                if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]]]) {
                    _countField.text = [choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]];
                }
            }
            break;
            
        default:
            break;
    }
}
#pragma mark - 扫描界面
/**
 *   扫描界面进入工分登记界面不同
 */
-(void)setScanCodeListDetailText:(NSInteger)row cell:(UITableViewCell *)cell
{
    NSDictionary * choosedOptionDic = [[ZEPointRegCache instance] getUserChoosedOptionDic];
    ZEPointRegModel * model = nil;
    if ([ZEUtil isNotNull:choosedOptionDic]) {
         model = [ZEPointRegModel getDetailWithDic:choosedOptionDic];
    }

    cell.detailTextLabel.text = @"请选择";
    switch (row) {
        case POINT_REG_TASK:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]];
                cell.detailTextLabel.text = model.TR_NAME;
            }
        }
            break;
        case POINT_REG_TIME:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME]]]) {
                cell.detailTextLabel.text = [choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME]];
            }else {
                NSDate * date = [NSDate date];
                NSDateFormatter * matter = [[NSDateFormatter alloc]init];
                matter.dateFormat = @"yyyy-MM-dd";
                NSString * dateStr = [matter stringFromDate:date];
                [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TIME]:dateStr}];
                cell.detailTextLabel.text = dateStr;
            }
        }
            break;
        case POINT_REG_WORKING_HOURS:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TASK]]];
                cell.detailTextLabel.text = model.TR_HOUR;
            }
        }
            break;
        case POINT_REG_TYPE:
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TYPE]]]) {
                cell.detailTextLabel.text = [ZEUtil getPointRegShareType:[[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TYPE]] integerValue]];
            }
            break;
        case POINT_REG_DIFF_DEGREE:
        {
            cell.detailTextLabel.text = @"正常天气";
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]];
                cell.detailTextLabel.text = model.TWR_NAME;
            }
        }
            break;
            
        case POINT_REG_TIME_DEGREE:
        {
            if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME_DEGREE]]]) {
                ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_TIME_DEGREE]]];
                cell.detailTextLabel.text = model.NDXS_LEVEL;
            }
            cell.detailTextLabel.text = @"正常工作日";
        }
            break;
            
        case POINT_REG_JOB_ROLES:
            if (_showJobRules) {
                if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]]) {
                    ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]]];
                    cell.detailTextLabel.text = model.TWR_NAME;
                }
            }else if (_showJobCount){
                cell.detailTextLabel.text = @"次";
                
                float fieldLeft = 0;
                fieldLeft = SCREEN_WIDTH - 200.0f - 30.0f;
                if (IPHONE6P){
                    fieldLeft = SCREEN_WIDTH - 200.0f - 35.0f;
                }
                
                _countField = [[UITextField alloc]initWithFrame:CGRectMake(fieldLeft, 2.0f, 200.0f, 44.0f)];
                _countField.textColor = cell.detailTextLabel.textColor;
                _countField.keyboardType = UIKeyboardTypeNumberPad;
                _countField.text = @"1";
                _countField.delegate = self;
                _countField.font = [UIFont systemFontOfSize:14];
                _countField.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:_countField];
                
                if ([ZEUtil isNotNull:[choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]]]) {
                    _countField.text = [choosedOptionDic objectForKey:[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]];
                }
            }
            break;
            
        default:
            break;
    }

}
#pragma mark - 历史界面
-(void)setHistoryListDetailText:(NSInteger)row cell:(UITableViewCell *)cell
{
//    cell.textLabel.text = [ZEUtil getPointRegInformation:row - 1];
    
//    if (row == 0) {
//        cell.textLabel.text = @"工作人员";
//        cell.detailTextLabel.text = [ZESetLocalData getUsername];
//    }
    
    switch (row ) {
        case POINT_REG_TASK:
        {
            cell.detailTextLabel.text = _historyModel.TT_TASK;
        }
            break;
        case POINT_REG_TIME:
        {
            cell.detailTextLabel.text = _historyModel.TT_ENDDATE;
        }
            break;
        case POINT_REG_WORKING_HOURS:
        {
            cell.detailTextLabel.text = _historyModel.TT_HOUR;
        }
            break;
        case POINT_REG_TYPE:
        {
            cell.detailTextLabel.text = [ZEUtil getPointRegShareType:[_historyModel.DISPATCH_TYPE integerValue]];
        }
            break;
        case POINT_REG_DIFF_DEGREE:
        {
            cell.detailTextLabel.text = _historyModel.NDSX_NAME;
        }
            break;
            
        case POINT_REG_TIME_DEGREE:
        {
            cell.detailTextLabel.text = _historyModel.SJSX_NAME;
        }
            break;
            
        case POINT_REG_JOB_ROLES:
        {
            if([_historyModel.DISPATCH_TYPE integerValue] == 1 ||[_historyModel.DISPATCH_TYPE integerValue] == 4 ){
                //按系数分配的情况
                cell.detailTextLabel.text = _historyModel.ROLENAME;
            }else if ([_historyModel.DISPATCH_TYPE integerValue] == 3){
                cell.textLabel.text = [ZEUtil getPointRegInformation:row];
                if ([_historyModel.TT_FLAG isEqualToString:@"未审核"]) {
                    cell.detailTextLabel.text = @"次";
                    float fieldLeft = 0;
                    fieldLeft = SCREEN_WIDTH - 200.0f - 30.0f;
                    if (IPHONE6P){
                        fieldLeft = SCREEN_WIDTH - 200.0f - 35.0f;
                    }
                    
                    _countField = [[UITextField alloc]initWithFrame:CGRectMake(fieldLeft, 2.0f, 200.0f, 44.0f)];
                    _countField.textColor = cell.detailTextLabel.textColor;
                    _countField.keyboardType = UIKeyboardTypeNumberPad;
                    _countField.text = @"1";
                    _countField.delegate = self;
                    _countField.font = [UIFont systemFontOfSize:14];
                    _countField.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:_countField];
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@次",_historyModel.TIMES];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentSelectRow = indexPath.row;
//    if(_enterType == ENTER_POINTREG_TYPE_HISTORY){
//        _currentSelectRow = indexPath.row - 1;
//        indexPath = [NSIndexPath indexPathForRow:_currentSelectRow inSection:0];
//    }

    if (_currentSelectRow != POINT_REG_JOB_ROLES) {
        if (![_countField isExclusiveTouch]) {
            [UIView animateWithDuration:0.29 animations:^{
                self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            [_countField resignFirstResponder];
        }
    }
    if ([self.delegate respondsToSelector:@selector(view:didSelectRowAtIndexpath:withShowRules:)]) {
        [self.delegate view:self didSelectRowAtIndexpath:indexPath withShowRules:_showJobRules];
    }
}


#pragma mark - ZEPointRegistrationViewDelegate
-(void)goBack
{
    if ([self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
}
-(void)goSubmit{
    if ([self.delegate respondsToSelector:@selector(goSubmit:withShowRoles:withShowCount:)]) {
        [self.delegate goSubmit:self withShowRoles:_showJobRules withShowCount:_showJobCount];
    }
}

-(void)didSelectOption:(NSDictionary *)object withRow:(NSInteger)row
{
    UITableViewCell * cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectRow inSection:0]];
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (_currentSelectRow == POINT_REG_TASK) {
            NSDictionary * dic = [NSDictionary dictionaryWithObject:object forKey:[ZEUtil getPointRegField:POINT_REG_TASK]];
            [[ZEPointRegCache instance] setUserChoosedOptionDic:dic];
            
            ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:object];
            cell.detailTextLabel.text = model.TR_NAME;
            UITableViewCell * taskHoursCell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            taskHoursCell.detailTextLabel.text = model.TR_HOUR;
        }else if (_currentSelectRow == POINT_REG_DIFF_DEGREE){
            [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_DIFF_DEGREE]:object}];
            ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:object];
            cell.detailTextLabel.text = model.NDXS_LEVEL;
        }else if (_currentSelectRow == POINT_REG_TIME_DEGREE){
            [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TIME_DEGREE]:object}];
            ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:object];
            cell.detailTextLabel.text = model.NDXS_LEVEL;
        }else if (_currentSelectRow == POINT_REG_JOB_ROLES &&  _showJobRules){
            [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_JOB_ROLES]:object}];
            ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:object];
            cell.detailTextLabel.text = model.TWR_NAME;
        }
    }else{
        if(_currentSelectRow == 3){
            [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_TYPE]:[NSString stringWithFormat:@"%ld",(long)row + 1]}];
            NSDictionary * dic = [[ZEPointRegCache instance] getUserChoosedOptionDic];
            cell.detailTextLabel.text = [ZEUtil getPointRegShareType:[[dic objectForKey:[ZEUtil getPointRegField:POINT_REG_TYPE]] integerValue]];
        }else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",object];
        }
    }
    
    [_alertView dismissWithCompletion:nil];
    
    if (_currentSelectRow == 3 && [[NSString stringWithFormat:@"%@",object] isEqualToString:[ZEUtil getPointRegShareType:POINT_REG_SHARE_TYPE_COE]]) {
        [[ZEPointRegCache instance] clearCount];
        _showJobRules = YES;
        _showJobCount = NO;
        [_contentTableView reloadData];
    }else if (_currentSelectRow == 3 && [[NSString stringWithFormat:@"%@",object] isEqualToString:[ZEUtil getPointRegShareType:POINT_REG_SHARE_TYPE_COUNT ]] ){
        [[ZEPointRegCache instance] clearRoles];
        [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]:@"1"}];
        _showJobRules = NO;
        _showJobCount = YES;
        [_contentTableView reloadData];
    }else if (_currentSelectRow == 3 && [[NSString stringWithFormat:@"%@",object] isEqualToString:[ZEUtil getPointRegShareType:POINT_REG_SHARE_TYPE_WP]]){
        [[ZEPointRegCache instance] clearCount];
        _showJobRules = YES;
        _showJobCount = NO;
        [_contentTableView reloadData];
    }else if (_currentSelectRow == 3 && [[NSString stringWithFormat:@"%@",object] isEqualToString:[ZEUtil getPointRegShareType:POINT_REG_SHARE_TYPE_PEO]]){
        [[ZEPointRegCache instance] clearCount];
        [[ZEPointRegCache instance] clearRoles];
        _showJobRules = NO;
        _showJobCount = NO;
        [_contentTableView reloadData];
    }
  
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
    [[ZEPointRegCache instance] setUserChoosedOptionDic:@{@"date":dateStr}];

    [_alertView dismissWithCompletion:nil];
}
#pragma mark - ZEPointRegChooseTaskViewDelegate

-(void)didSeclectTask:(ZEPointChooseTaskView *)taskView withData:(NSDictionary *)dic
{    
    NSDictionary * diction = [NSDictionary dictionaryWithObject:dic forKey:[ZEUtil getPointRegField:POINT_REG_TASK]];
    [[ZEPointRegCache instance] setUserChoosedOptionDic:diction];
    
    UITableViewCell * cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectRow inSection:0]];
    
    ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:dic];
    cell.detailTextLabel.text = model.TR_NAME;
    UITableViewCell * taskHoursCell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    taskHoursCell.detailTextLabel.text = model.TR_HOUR;
    [_alertView dismissWithCompletion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [UIView animateWithDuration:0.29 animations:^{
        if(IPHONE5){
            self.frame = CGRectMake(0, -120, SCREEN_WIDTH, SCREEN_HEIGHT);
        }else if (IPHONE4S_LESS){
            self.frame = CGRectMake(0, -216, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
    }];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [[ZEPointRegCache instance] setUserChoosedOptionDic:@{[ZEUtil getPointRegField:POINT_REG_JOB_COUNT]:textField.text}];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.29 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![_countField isExclusiveTouch]) {
        [UIView animateWithDuration:0.29 animations:^{
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        [_countField resignFirstResponder];
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
