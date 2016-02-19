//
//  ZEPointChooseTaskView.m
//  NewCentury
//
//  Created by Stenson on 16/2/2.
//  Copyright © 2016年 Zenith Electronic. All rights reserved.
//
#define kOptionViewMarginLeft   0.0f
#define kOptionViewMarginTop    44.0f
#define kOptionViewWidth        _viewFrame.size.width

#define kMaxHeight SCREEN_HEIGHT * 0.7

#import "ZEPointChooseTaskView.h"
#import "ZEPointRegModel.h"

@interface ZEPointChooseTaskView ()<UITableViewDataSource,UITableViewDelegate>
{
    CGRect _viewFrame;
    NSMutableArray * _kindTaskArr;
    NSMutableArray * _detailTaskArr;
    UITableView * _optionTableView;
    NSMutableArray * _maskArr;
}
@property (nonatomic,retain) NSArray * optionsArray;
@end

@implementation ZEPointChooseTaskView
-(id)initWithOptionArr:(NSArray *)options
{
    int viewHeight = 0;
    
    viewHeight = 44.0f * (options.count + 1);
    
    if (viewHeight > kMaxHeight) {
        viewHeight = kMaxHeight;
    }
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, viewHeight)];
    if (self) {
        _optionsArray = options;
        _viewFrame = CGRectMake(0, 0, SCREEN_WIDTH - 40, viewHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        [self initData];
        [self initView];
    }
    return self;

}

-(void)initData
{
    _kindTaskArr = [NSMutableArray array];
    _detailTaskArr = [NSMutableArray array];
    NSMutableArray * contArray = [NSMutableArray array];
    
    for (int i = 0; i < _optionsArray.count; i ++) {
        ZEPointRegModel * regModel = [ZEPointRegModel getDetailWithDic:_optionsArray[i]];
        
        if (_kindTaskArr.count > 0) {
            if([regModel.TRC_NAME isEqualToString:[_kindTaskArr lastObject]]){
                [contArray addObject:_optionsArray[i]];
            }else{
                [_kindTaskArr addObject:regModel.TRC_NAME];
                [_detailTaskArr addObject:contArray];
                contArray = [NSMutableArray array];
                [contArray addObject:_optionsArray[i]];
            }
            if (i == _optionsArray.count - 1) {
                [_detailTaskArr addObject:contArray];
            }
        }else{
            [_kindTaskArr addObject:regModel.TRC_NAME];
            [contArray addObject:_optionsArray[i]];
            if (i == _optionsArray.count - 1) {
                [_detailTaskArr addObject:contArray];
            }
        }
    }
    
    _maskArr = [NSMutableArray array];
    for (int i = 0; i < _kindTaskArr.count; i ++) {
        [_maskArr addObject:@"0"];
    }

}

-(void)initView
{
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44.0f)];
    titleLab.text = @"请选择";
    titleLab.backgroundColor = MAIN_COLOR;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    _optionTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _optionTableView.delegate = self;
    _optionTableView.dataSource = self;
    [self addSubview:_optionTableView];
    int maxHeight = kMaxHeight;
    if (_viewFrame.size.height != maxHeight) _optionTableView.scrollEnabled = NO;
    [_optionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kOptionViewMarginLeft);
        make.top.offset(kOptionViewMarginTop);
        if (_viewFrame.size.height == maxHeight) {
            make.size.mas_equalTo(CGSizeMake(kOptionViewWidth,_viewFrame.size.height - 44.0f));
        }else{
            make.size.mas_equalTo(CGSizeMake(kOptionViewWidth, _optionsArray.count * 44.0f));
        }
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _kindTaskArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * headerBut = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBut.backgroundColor = [UIColor whiteColor];
    headerBut.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [headerBut setTitle:_kindTaskArr[section] forState:UIControlStateNormal];
    [headerBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headerBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    BOOL mask = [_maskArr[section] boolValue];
    if (!mask) {
    [headerBut setImage:[UIImage imageNamed:@"icon_up" color:[UIColor blackColor]] forState:UIControlStateNormal];
    }else{
        [headerBut setImage:[UIImage imageNamed:@"icon_down" color:[UIColor blackColor]] forState:UIControlStateNormal];
    }
    headerBut.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    headerBut.tag = section;
    [headerBut addTarget:self action:@selector(showDetailTaskList:) forControlEvents:UIControlEventTouchUpInside];
    
    return headerBut;
}

-(void)showDetailTaskList:(UIButton *)button
{
    BOOL boolean = [_maskArr[button.tag] boolValue];
    boolean = !boolean;
    [_maskArr removeObjectAtIndex:button.tag];
    [_maskArr insertObject:[NSString stringWithFormat:@"%d",boolean] atIndex:button.tag];
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:button.tag];
    [_optionTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL mask = [_maskArr[section] boolValue];
    if (!mask) {
        return 0;
    }
    return [_detailTaskArr[section] count];
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZEPointRegModel * model = [ZEPointRegModel getDetailWithDic:_detailTaskArr[indexPath.section][indexPath.row]];
    cell.textLabel.text = model.TR_NAME;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = MAIN_COLOR;
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(10, 43.5f, SCREEN_WIDTH - 10, 0.5f);
    lineLayer.backgroundColor = [MAIN_LINE_COLOR CGColor];
    [cell.contentView.layer addSublayer:lineLayer];
    
    return cell;
}

#pragma mark - UITabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSeclectTask:withData:)]) {
        [self.delegate didSeclectTask:self withData:_detailTaskArr[indexPath.section][indexPath.row]];
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