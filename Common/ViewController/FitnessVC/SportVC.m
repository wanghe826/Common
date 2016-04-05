//
//  SportVC.m
//  Common
//
//  Created by QFITS－iOS on 16/2/27.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SportVC.h"
#import "Masonry.h"
#import "HMMCustomCircleView.h"
#import "BackgroundChartView.h"
#import "SportSleepDetailView.h"

#import "SportData.h"

@interface SportVC ()<UIScrollViewDelegate>
{
    UISegmentedControl* _segmentedControl;
    UIScrollView* _scrollView;
    
    UIView* _seperatorView;
    
    CGRect _seperatorOriginRect;
    
    HMMCustomCircleView* _circleView;
    
    SportSleepDetailView* _sportDetailView1;
    SportSleepDetailView* _sportDetailView2;
    SportSleepDetailView* _sportDetailView3;
    
    UILabel* _weekRangeLabel;
    UILabel* _monthRangeLabel;
}

@end

@implementation SportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kHexRGBAlpha(0x030918, 1.0);
    [self initialNavigationbar];
    
    [self createSegmentControl];
    [self createBackgroundScrollView];
    [self oneDaySportView];
    [self createOneWeekSportView];
    [self createOneMonthSportView];
}

- (void) initialNavigationbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    self.title = NSLocalizedString(@"运动健康", nil);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createShareBtn];
    
    SportData* sportData = [[SportData alloc] init];
    [sportData fetchAllSportDataLength];
}

- (void) createShareBtn
{
    UIButton* shareButton = [self.navigationController.navigationBar viewWithTag:1090];
    if(shareButton)
    {
        shareButton.hidden = NO;
    }
    else
    {
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.tag = 1090;
        [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setFrame:CGRectMake(screen_width - 90, 2, 40, 40)];
        [shareButton setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:shareButton];
    }
    
    UIButton *settingButton = [self.navigationController.navigationBar viewWithTag:1091];
    if(settingButton) {
        settingButton.hidden = NO;
    }
    else {
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setFrame:CGRectMake(screen_width - 44, 10, 25, 25)];
        settingButton.tag = 1091;
        [settingButton setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:settingButton];
    }
    
}

- (void) createSegmentControl
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString =  [formatter stringFromDate:date];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[dateString, @"一周", @"一个月"]];
    _segmentedControl.tintColor = [UIColor clearColor];
    [_segmentedControl addTarget:self action:@selector(segementTarget:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dicOfNomal = [NSDictionary dictionaryWithObjectsAndKeys:kHexRGBAlpha(0x939393, 1.0f), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:15], NSFontAttributeName, nil];
    [_segmentedControl setTitleTextAttributes:dicOfNomal forState:UIControlStateNormal];
    
    NSDictionary *dicOfSelectd = [NSDictionary dictionaryWithObjectsAndKeys:kHexRGBAlpha(0xe7e7e7, 1.0f), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:15], NSFontAttributeName, nil];
    [_segmentedControl setTitleTextAttributes:dicOfSelectd forState:UIControlStateSelected];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(70);
        make.size.mas_equalTo(CGSizeMake((screen_width-20),40));
    }];
    
    _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 1)];
    _seperatorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_seperatorView];
    [_seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_segmentedControl.mas_bottom);
        make.left.mas_equalTo(_segmentedControl.mas_left);
        make.size.mas_equalTo(CGSizeMake(_segmentedControl.frame.size.width/3, 1));
    }];
    _seperatorOriginRect = _seperatorView.frame;
}

- (void) segementTarget:(UISegmentedControl*)segment
{
    _scrollView.contentOffset = CGPointMake(segment.selectedSegmentIndex*screen_width, 0);
}


- (void) createBackgroundScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(screen_width*3, 300);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seperatorView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(@(screen_width));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-5);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma scrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    _seperatorView.frame = CGRectMake(10 + scrollView.contentOffset.x * 100/320, _seperatorView.frame.origin.y, _seperatorView.frame.size.width, _seperatorView.frame.size.height);
    
    if(scrollView.contentOffset.x == 0)
    {
        _segmentedControl.selectedSegmentIndex = 0;
    }
    else if(scrollView.contentOffset.x == screen_width)
    {
        _segmentedControl.selectedSegmentIndex = 1;
    }
    else if(scrollView.contentOffset.x == screen_width*2)
    {
        _segmentedControl.selectedSegmentIndex = 2;
    }
    
}

//一天
- (UIView*) oneDaySportView
{
    UIView* backView = [self scrollBackgroundView:0];
    
    _circleView = [[HMMCustomCircleView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    _circleView.personOf = 1000;
    _circleView.totle = 1500;
    [backView addSubview:_circleView];
    [_circleView startAnimating];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top);
        make.left.mas_equalTo(backView.mas_left).offset(65*480/screen_height);
        make.right.mas_equalTo(backView.mas_right).offset(-65*480/screen_height);
        make.height.mas_equalTo(_circleView.mas_width);
    }];
    
    _completedStepLabel = [[UILabel alloc] init];
    _completedStepLabel.textAlignment = NSTextAlignmentCenter;
    _completedStepLabel.text = @"1243";
    _completedStepLabel.textColor = RGBColor(0x3f, 0xdd, 0x8f);
    [_completedStepLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:60]];
    [_completedStepLabel sizeToFit];
    [backView addSubview:_completedStepLabel];
    
    [_completedStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_circleView);
        make.left.mas_equalTo(_circleView.mas_left).offset(20);
        make.right.mas_equalTo(_circleView.mas_right).offset(-20);
        make.height.mas_equalTo(_circleView.frame.size.height/4);
    }];
    
    UILabel* todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    todayLabel.textAlignment = NSTextAlignmentCenter;
    todayLabel.textColor = [UIColor whiteColor];
    todayLabel.text = NSLocalizedString(@"今日步数", nil);
    [todayLabel setFont:[UIFont systemFontOfSize:18]];
    [backView addSubview:todayLabel];
    [todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_completedStepLabel.mas_centerX);
        make.bottom.mas_equalTo(_completedStepLabel.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    
    
    _totalStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    _totalStepLabel.textAlignment = NSTextAlignmentCenter;
    _totalStepLabel.textColor = [UIColor whiteColor];
    _totalStepLabel.text = NSLocalizedString(@"目标 : 10000", nil);
    [_totalStepLabel setFont:[UIFont systemFontOfSize:18]];
    [backView addSubview:_totalStepLabel];
    [_totalStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_completedStepLabel.mas_centerX);
        make.top.mas_equalTo(_completedStepLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    
    
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _percentLabel.textColor = [UIColor redColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    [_percentLabel setFont:[UIFont systemFontOfSize:15]];
    _percentLabel.text = @"60%";
    [backView addSubview:_percentLabel];
    [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_circleView.mas_centerX);
        make.top.mas_equalTo(_totalStepLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    BackgroundChartView* containView = [[BackgroundChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    [backView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_circleView.mas_bottom).offset(10);
        make.left.mas_equalTo(backView.mas_left).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(5);
#warning 动态改变大小
        if(screen_height==480){
            make.height.mas_equalTo(@(60));
        }
        else{
            make.height.mas_equalTo(@(100));
        }
    }];
    
    
    _sportDetailView1 = [SportSleepDetailView detailViewWithFrame:CGRectMake(0, 0, 0, 0)];
    [backView addSubview:_sportDetailView1];
    [_sportDetailView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(backView.mas_bottom).offset(-10);
        make.left.mas_equalTo(backView.mas_left).offset(0);
        make.right.mas_equalTo(backView.mas_right).offset(0);
    }];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = @"时分数据表";
    [label setFont:[UIFont systemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [backView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containView.mas_bottom).offset(0);
        make.centerX.mas_equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtnTarget) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(10);
        make.centerY.mas_equalTo(_circleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(leftBtnTarget) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).offset(-10);
        make.centerY.mas_equalTo(_circleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    return backView;
}

- (void) leftBtnTarget
{
    
}

- (void) rightBtnTarget
{
    
}

- (void) settingAction
{
    
}

- (void) shareAction
{
    
}


//一周
- (void) createOneWeekSportView
{
    UIView* backView = [self scrollBackgroundView:screen_width];
    
    _sportDetailView2 = [SportSleepDetailView detailViewWithFrame:CGRectZero];
    _weekRangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _weekRangeLabel.text = @"2016.2.21-2016.2.27";
    _weekRangeLabel.textColor = HexRGBAlpha(0xc1c1c1, 1);
    _weekRangeLabel.font = [UIFont systemFontOfSize:24];
    
    [self createBodyViewWithBackView:backView withRangeLabel:_weekRangeLabel withSportDetailView:_sportDetailView2];
    
    BackgroundChartView* chartView = [[BackgroundChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [backView addSubview:chartView];
    
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seperatorView.mas_bottom).offset(10);
        make.left.mas_equalTo(backView.mas_left).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(5);
#warning 动态调整大小
        make.bottom.mas_equalTo(_weekRangeLabel.mas_top).offset(-40);
    }];
    chartView.hidden = YES;
    
    UIView* weekLabel = [[[NSBundle mainBundle] loadNibNamed:@"WeekLabel" owner:nil options:nil] lastObject];
    [backView addSubview:weekLabel];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(chartView.mas_bottom).offset(5);
        make.left.mas_equalTo(chartView);
        make.right.mas_equalTo(chartView);
        make.height.mas_equalTo(@(25));
    }];
}

//一个月
- (void) createOneMonthSportView
{
    UIView* backView = [self scrollBackgroundView:2*screen_width];
    [_scrollView addSubview:backView];
    
    _monthRangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _monthRangeLabel.text = @"2016.3.1-2016.3.31";
    _monthRangeLabel.textColor = HexRGBAlpha(0xc1c1c1, 1);
    _monthRangeLabel.font = [UIFont systemFontOfSize:24];
    
    _sportDetailView3 = [SportSleepDetailView detailViewWithFrame:CGRectZero];
    
    [self createBodyViewWithBackView:backView withRangeLabel:_monthRangeLabel withSportDetailView:_sportDetailView3];
    
    BackgroundChartView* chartView = [[BackgroundChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [backView addSubview:chartView];
    
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seperatorView.mas_bottom).offset(10);
        make.left.mas_equalTo(backView.mas_left).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(5);
#warning 动态调整大小
        make.bottom.mas_equalTo(_weekRangeLabel.mas_top).offset(-40);
    }];
    chartView.hidden = YES;
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    label1.text = @"1";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    [backView addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chartView.mas_left);
        make.top.mas_equalTo(chartView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"16";
    label2.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(label1);
        make.centerX.mas_equalTo(chartView);
        make.top.mas_equalTo(label1);
    }];
    
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    label3.textColor = [UIColor whiteColor];
    label3.text = @"31";
    label3.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(label1);
        make.right.mas_equalTo(chartView);
        make.top.mas_equalTo(label1);
    }];
    
}


- (UIView*) scrollBackgroundView:(CGFloat)leftDistance
{
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,0, screen_width, screen_height-70-CGRectGetHeight(_segmentedControl.frame))];
    [_scrollView addSubview:backView];
    return  backView;
}



- (void) createBodyViewWithBackView:(UIView*)backView withRangeLabel:(UILabel*)rangeLabel withSportDetailView:(SportSleepDetailView*)sportDetailView;
{
    [backView addSubview:sportDetailView];
    [sportDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(-5);
        make.bottom.mas_equalTo(backView.mas_bottom).offset(-15);
        make.height.mas_equalTo(@(120));
    }];
    
    rangeLabel.textColor = [UIColor whiteColor];
    rangeLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:rangeLabel];
    [rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView);
        make.bottom.mas_equalTo(sportDetailView.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(160, 25));
    }];
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnTarget) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rangeLabel.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(rangeLabel);
    }];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    [backView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnTarget) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rangeLabel.mas_right).offset(0);
        make.size.mas_equalTo(leftBtn);
        make.centerY.mas_equalTo(leftBtn);
    }];
    
    BackgroundChartView* chartView = [[BackgroundChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [backView addSubview:chartView];
    
    [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seperatorView.mas_bottom).offset(10);
        make.left.mas_equalTo(backView.mas_left).offset(5);
        make.right.mas_equalTo(backView.mas_right).offset(5);
#warning 动态调整大小
        make.bottom.mas_equalTo(rangeLabel.mas_top).offset(-40);
    }];
    chartView.row = 6;
    chartView.labelHidden = YES;
}

@end
