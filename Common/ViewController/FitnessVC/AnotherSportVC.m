//
//  AnotherSportVC.m
//  Common
//
//  Created by HuMingmin on 16/3/11.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "AnotherSportVC.h"

#import "HMMCustomCircleView.h" // 自定义彩色圆环界面
#import "DaySleepContainTableView.h" // 运动界面中包涵柱状图的自定义 View
#import "ZhouYueSleepContainTableView.h" // 周月中包涵柱状图的自定义 View

@interface AnotherSportVC () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CKCalendarViewDataSource, CKCalendarViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollViewOfViewchange; // 底层最大的 UIScrollView
@property (nonatomic, strong) NSMutableArray *arrOfBaseView; // UIScrollView 底边承接内容的 View
@property (nonatomic, strong) UISegmentedControl *mySelectedTag; // 创建选择标签
@property (nonatomic, strong) UIView *seperateView; // 创建分割线
@property (nonatomic, assign) BOOL isFromTagClick; // 判断是否来自 tag 点击
@property (nonatomic, strong) HMMCustomCircleView *myHMMCustomCircleView; // 自定义彩色圆环 View

@property (nonatomic, assign) CGFloat rateOfDevice; // 设备比例

@property (nonatomic, strong) CKCalendarView *calendarView; // 日历
@property (nonatomic, strong) UISegmentedControl *modePicker;
@property (nonatomic, strong) NSMutableArray *events;

@property (nonatomic, strong) ZhouYueSleepContainTableView * myZhouSleepContainTableView; // 周柱状
@property (nonatomic, assign) NSInteger pageNumZhou;
@property (nonatomic, assign) NSInteger maxPageOfZhou;
@property (nonatomic, strong) ZhouYueSleepContainTableView * myYueSleepContainTableView; // 月柱状
@property (nonatomic, assign) NSInteger pageNumYue;
@property (nonatomic, assign) NSInteger maxPageOfYue;

@property (nonatomic, strong) NSMutableArray *mutArrOfallDays; // 所有天数步数
@property (nonatomic, assign) NSInteger numOfAllDays; // 所有的天数
@property (nonatomic, assign) NSInteger pageOfCicle;

@property (nonatomic, strong) NSMutableArray *mutArrOfZhou; // 每周数据
@property (nonatomic, strong) NSMutableArray *mutArrOfYue; // 每月数据

@property (nonatomic, strong) UIButton *leftBtnOfZhou;
@property (nonatomic, strong) UIButton *rightBtnOfZhou;

@property (nonatomic, strong) UIButton *leftBtnOfYue;
@property (nonatomic, strong) UIButton *rightBtnOfYue;

@end

@implementation AnotherSportVC

- (NSMutableArray *)mutArrOfZhou {
    if (!_mutArrOfZhou) {
        _mutArrOfZhou = [NSMutableArray new];
    }
    return _mutArrOfZhou;
} // 周数据
- (NSMutableArray *)mutArrOfYue {
    if (!_mutArrOfYue) {
        _mutArrOfYue = [NSMutableArray new];
    }
    return _mutArrOfYue;
} // 月数据
- (NSMutableArray *)mutArrOfallDays {
    if (!_mutArrOfallDays) {
        _mutArrOfallDays = [NSMutableArray new];
    }
    return _mutArrOfallDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rateOfDevice = (screen_height / 667); // 初始化不同设备比例
    
    [self initialNavigationbar]; // 初始化 Nav
    [self createSelectdTag]; // 创建上方分页显示标签
    [self createScrollViewOfViewchange]; // 创建最大的并且可以滑动的 UIScrollView
    [self createCalendar:nil]; // 创建日历
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createShareBtn];
}

/**
 *  初始化 Nav
 */
- (void)initialNavigationbar {
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    self.title = NSLocalizedString(@"运动健康", nil);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
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
- (void) settingAction {
}
- (void) shareAction {
}

/**
 *  创建日历
 */
- (void)createCalendar:(id)semder {
    _myScrollViewOfViewchange.userInteractionEnabled = YES; // 保险操作，控件太多原因
    
    // 承接日历控件的一个大 View
    UIView *myAllViewLike = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    myAllViewLike.tag = 100;
    myAllViewLike.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myAllViewLike];
    myAllViewLike.userInteractionEnabled = YES;
    
    // 控制位置的一个 View
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 320) / 2.0, 0, kScreenWidth, 300 + 64 + 30)];
    blankView.backgroundColor = [UIColor clearColor];
    [myAllViewLike addSubview:blankView];
//    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyBaseView:)];
    blankView.userInteractionEnabled = YES;
//    [blankView addGestureRecognizer:tapOne];
    
    if (kScreenHeight == 667) {
        blankView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.185, 1.185), 0, 20);
    } else if (kScreenHeight == 736) {
        blankView.transform = CGAffineTransformTranslate(CGAffineTransformTranslate(CGAffineTransformMakeScale(1.3, 1.3), 0, 20), 8, 10);
    }
    
    // Prepare the events array
    [self setEvents:[NSMutableArray new]];
    
    // Calendar View
    [self setCalendarView:[CKCalendarView new]];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    
    [blankView addSubview:[self calendarView]];
    
    [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    [[self calendarView] setDisplayMode:CKCalendarViewModeMonth animated:NO];
    [self calendarView].transform = CGAffineTransformMakeTranslation(0, 64);
    
    UIButton *myBaseViewDis = [UIButton buttonWithType:UIButtonTypeCustom];
    myBaseViewDis.frame = CGRectMake(0, blankView.frame.size.height, kScreenWidth, kScreenHeight);
    myBaseViewDis.tag = 101;
    myBaseViewDis.backgroundColor = [UIColor clearColor];
    [myAllViewLike addSubview:myBaseViewDis];
    [myBaseViewDis addTarget:self action:@selector(tapMyBaseView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self calendarView].returnClickBlock = ^(NSInteger index, NSInteger num) {
        NSLog(@"index%ld、num%ld", index, num);
    };
}
- (void)tapMyBaseView:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.view viewWithTag:100].transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
    _myScrollViewOfViewchange.userInteractionEnabled = YES;
}

/**
 *  创建选择标签
 */
- (void)createSelectdTag {
    NSMutableArray *itemsOfSelectdtag = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"今天", nil), NSLocalizedString(@"一周", nil), NSLocalizedString(@"一个月", nil)]];
    _mySelectedTag = [[UISegmentedControl alloc] initWithItems:itemsOfSelectdtag];
    _mySelectedTag.frame = CGRectMake(0, 64, kScreenWidth, 40);
    _mySelectedTag.tintColor = [UIColor clearColor];
    
    NSDictionary *dicOfNomal = [NSDictionary dictionaryWithObjectsAndKeys:kHexRGBAlpha(0x939393, 1.0f), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:15], NSFontAttributeName, nil];
    [_mySelectedTag setTitleTextAttributes:dicOfNomal forState:UIControlStateNormal];
    
    NSDictionary *dicOfSelectd = [NSDictionary dictionaryWithObjectsAndKeys:kHexRGBAlpha(0xe7e7e7, 1.0f), NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:15], NSFontAttributeName, nil];
    [_mySelectedTag setTitleTextAttributes:dicOfSelectd forState:UIControlStateSelected];
    
    _mySelectedTag.selectedSegmentIndex = 0;
    [self.view addSubview:_mySelectedTag];
    
    [_mySelectedTag addTarget:self action:@selector(tagSeleted:) forControlEvents:UIControlEventValueChanged];
    
    // 创建分割线
    CGFloat widthOfSeperateView = (kScreenWidth - 30 * 6) / 3.0;
    _seperateView = [[UIView alloc] initWithFrame:CGRectMake(30, 64 + 37, widthOfSeperateView, 1)];
    _seperateView.backgroundColor = kHexRGBAlpha(0xe7e7e7, 0.9f);
    [self.view addSubview:_seperateView];
    [self.view bringSubviewToFront:_seperateView];
    
}
- (void)tagSeleted:(UISegmentedControl *)selectedTag {
    _isFromTagClick = YES;
    
    NSInteger tag = selectedTag.selectedSegmentIndex;
    [_myScrollViewOfViewchange setContentOffset:CGPointMake(kScreenWidth * tag, 0) animated:YES];
    
    CGFloat widthOfSeperateView = (kScreenWidth - 30 * 6) / 3.0;
    [UIView animateWithDuration:0.35f animations:^{
        _mySelectedTag.userInteractionEnabled = NO;
        _seperateView.frame = CGRectMake(30 + (widthOfSeperateView + 30 * 2) * tag, 64 + 37, widthOfSeperateView, 1);
    } completion:^(BOOL finished) {
        _isFromTagClick = NO;
        _mySelectedTag.userInteractionEnabled = YES;
    }];
    
    if (tag == 0) {
        [_myHMMCustomCircleView removeFromSuperview];
        _myHMMCustomCircleView = nil;
        [self createDynamicCircleView:YES];
    }
}

/**
 *  创建 底层最大的 UIScrollView
 */
- (void)createScrollViewOfViewchange {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myScrollViewOfViewchange = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, kScreenWidth, kScreenHeight - 64 - 40)];
    _myScrollViewOfViewchange.delegate = self;
    _myScrollViewOfViewchange.pagingEnabled = YES;
    _myScrollViewOfViewchange.userInteractionEnabled = YES;
    CGFloat widthOfMyScrollViewOfViewchange = _myScrollViewOfViewchange.frame.size.width;
    CGFloat heightOfMyScrollViewOfViewchange = _myScrollViewOfViewchange.frame.size.height;
    _myScrollViewOfViewchange.contentSize = CGSizeMake(widthOfMyScrollViewOfViewchange *  3, heightOfMyScrollViewOfViewchange);
    [self.view addSubview:_myScrollViewOfViewchange];
    
    if (!_arrOfBaseView) {
        _arrOfBaseView = [NSMutableArray new];
    }
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(widthOfMyScrollViewOfViewchange * i, 0, widthOfMyScrollViewOfViewchange, heightOfMyScrollViewOfViewchange)];
        baseView.backgroundColor = kRandomColor(0.0f);
        baseView.userInteractionEnabled = YES;
        [_myScrollViewOfViewchange addSubview:baseView];
        
        [self.arrOfBaseView addObject:baseView];
    } // 创建三个测试 UIView
    
    [self createDynamicCircleView:NO]; // 创建动态圆环
    [self createFirstViewContainTabelView]; // 睡眠界面中包涵柱状图的自定义 View
    [self createZhouViewContainTabelView];
    [self createYueViewContainTabelView];
    [self createDetailInfoDisplay:0]; // 创建下方详情显示控件0
    [self createDetailInfoDisplay:1]; // 创建下方详情显示控件1
    [self createDetailInfoDisplay:2]; // 创建下方详情显示控件2
    [self createCalendarView]; // 创建日历点击控件
    //    [self createLikeNav]; // 创建类似NavView
    
    [self creatCicleBtnChange]; // 创建左右滑动选择的 circle btn
}
- (void)createLikeNav {
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    backBtn.backgroundColor = kRandomColor(0.0f);
    backBtn.frame = CGRectMake(15, 40 - 10, 20, 24);
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 标题
    UILabel *myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + kScreenWidth / 2.0 - 60 / 2.0, 40 - 10, 60, 24)];
    myTitleLabel.backgroundColor = kRandomColor(0.0f);
    myTitleLabel.text = @"Sleep";
    myTitleLabel.textAlignment = NSTextAlignmentCenter;
    myTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    myTitleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:myTitleLabel];
    
    // 设置与分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = kRandomColor(0.0f);
    shareBtn.frame = CGRectMake(kScreenWidth - 80, 40 - 10, 30, 24);
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    [shareBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.backgroundColor = kRandomColor(0.0f);
    settingBtn.frame = CGRectMake(kScreenWidth - 80 + 20 + 20, 40 - 10, 30, 24);
    [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    [settingBtn setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
}// 创建类似NavView
- (void)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
} // 返回按钮
- (void)shareBtnClick:(id)sender {
} // 分享按钮
- (void)settingBtnClick:(id)sender {
} // 设置按钮

- (void)createCalendarView {
    UIButton *myCalenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myCalenderBtn.frame = CGRectMake(20, 20, 20, 20);
    [myCalenderBtn setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    [myCalenderBtn addTarget:self action:@selector(movecreatedCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollViewOfViewchange addSubview:myCalenderBtn];
} // 创建日历点击控件
- (void)movecreatedCalendar:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.view viewWithTag:100].transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } completion:^(BOOL finished) {
    }];
} // 日历显示动画效果

- (void)createDynamicCircleView:(BOOL)existArr {
    [_myHMMCustomCircleView removeFromSuperview];
    _myHMMCustomCircleView = nil;
    _myHMMCustomCircleView = [[HMMCustomCircleView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - (240 * _rateOfDevice) / 2.0, 25 * _rateOfDevice, 240 * _rateOfDevice, 240 * _rateOfDevice)];
    if (existArr) {
        _myHMMCustomCircleView.personOf = [[self.mutArrOfallDays[_pageOfCicle] allObjects][0] floatValue];
    } else {
        _myHMMCustomCircleView.personOf = 0;
    }
    
    _myHMMCustomCircleView.backgroundColor = kRandomColor(0.0);
    _myHMMCustomCircleView.totle = 10000;
    [_myHMMCustomCircleView startAnimating];
    
    [_arrOfBaseView[0] addSubview:_myHMMCustomCircleView];
    
    [self createCentenViews:existArr]; // 创建中心子视图
}
- (void)creatCicleBtnChange {
    // 创建左右转换 btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_lefting"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = kRandomColor(0.0f);
    leftBtn.frame = CGRectMake(20, _myHMMCustomCircleView.frame.size.height / 2.0, 20, 30);
    leftBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_arrOfBaseView[0] addSubview:leftBtn];
    leftBtn.tag = 312008;
    [leftBtn addTarget:self action:@selector(leftBtnCick3:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = kRandomColor(0.0f);
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    rightBtn.tag = 312009;
    rightBtn.enabled = NO;
    rightBtn.frame = CGRectMake(kScreenWidth - 20 - 30, _myHMMCustomCircleView.frame.size.height / 2.0, 20, 30);
    [_arrOfBaseView[0] addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnCick3:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leftBtnCick3:(id)sender {
    ((UIButton *)[_arrOfBaseView[0] viewWithTag:312009]).enabled = YES;
    self.pageOfCicle ++;
    if (self.pageOfCicle >= self.numOfAllDays - 1) {
        self.pageOfCicle = self.numOfAllDays - 1;
        ((UIButton *)sender).enabled = NO;
    }

    [self createDynamicCircleView:YES];
    
    ((UILabel *)[_myHMMCustomCircleView viewWithTag:312001]).text = [self.mutArrOfallDays[_pageOfCicle] allObjects][0];

    
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
        if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * (((170) - 13.63636) * 0.000693 + 0.00495)];
            
            
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        } else {
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * ((([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) - 13.63636) * 0.000693 + 0.00495)];
            
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
        }
    } else {
        ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * (((170) - 13.63636) * 0.000693 + 0.00495)];
        
        ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
    }
    
    ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue] / 10000.0];
    
} // 彩色圆环切换左
- (void)rightBtnCick3:(id)sender {
    ((UIButton *)[_arrOfBaseView[0] viewWithTag:312008]).enabled = YES;
    self.pageOfCicle --;
    if (self.pageOfCicle <= 0) {
        self.pageOfCicle = 0;
        ((UIButton *)sender).enabled = NO;
    }
    
    [self createDynamicCircleView:YES];

    ((UILabel *)[_myHMMCustomCircleView viewWithTag:312001]).text = [self.mutArrOfallDays[_pageOfCicle] allObjects][0];
    
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
        if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * (((170) - 13.63636) * 0.000693 + 0.00495)];

            
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        } else {
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * ((([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) - 13.63636) * 0.000693 + 0.00495)];
            
            ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
        }
    } else {
        ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * (((170) - 13.63636) * 0.000693 + 0.00495)];
        
        ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
    }
    
    ((UILabel *)[[_arrOfBaseView[0] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue] / 10000.0];
} // 彩色圆环切换右
- (void)createCentenViews:(BOOL)isexitArr {
    
    CGFloat insideWidth = _myHMMCustomCircleView.frame.size.width;
    CGFloat insderheight = _myHMMCustomCircleView.frame.size.height;
    
    // 显示总步数的字样
    UILabel *myHourLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 40 - (18), insderheight / 2.0 - 20, _myHMMCustomCircleView.frame.size.width - (insideWidth / 2.0 - 40 - (18)) * 2, 40)];
    myHourLable.text = @"0";
    myHourLable.adjustsFontSizeToFitWidth = YES;
    myHourLable.tag = 312001;
    myHourLable.textAlignment = NSTextAlignmentCenter;
    myHourLable.backgroundColor = kRandomColor(0.0f);
    myHourLable.font = [UIFont boldSystemFontOfSize:30];
    myHourLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
    [_myHMMCustomCircleView addSubview:myHourLable];

    // “今日步数”
    UILabel *labelOfTotleTime = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40, 100, 25)];
    labelOfTotleTime.text = NSLocalizedString(@"今日步数", nil);
    labelOfTotleTime.font = [UIFont boldSystemFontOfSize:15];
    labelOfTotleTime.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
    labelOfTotleTime.textAlignment = NSTextAlignmentCenter;
    [_myHMMCustomCircleView addSubview:labelOfTotleTime];
    
    // 目标
    UILabel *labelOfTarget = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40 + 60, 100, 25)];
    labelOfTarget.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"目标", nil), @"10000"];
    labelOfTarget.font = [UIFont boldSystemFontOfSize:15];
    labelOfTarget.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
    labelOfTarget.textAlignment = NSTextAlignmentCenter;
    [_myHMMCustomCircleView addSubview:labelOfTarget];
    
    // 百分比
    UILabel *labelOfPerson = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40 + 80, 100, 25)];
    
    if (isexitArr) {
        if (([[self.mutArrOfallDays[_pageOfCicle] allObjects][0] floatValue]) / 10000 >= 1.0) {
            labelOfPerson.text = @"100%";// [[self.mutArrOfallDays[_pageOfCicle] allObjects][0] floatValue];
        } else {
            labelOfPerson.text = [NSString stringWithFormat:@"%.0f%%", ([[self.mutArrOfallDays[_pageOfCicle] allObjects][0] floatValue]) / 10000.0 * 100];
        }
    } else {
        labelOfPerson.text = [NSString stringWithFormat:@"%.0f%%", 0 / 10000.0 * 100];
    }
    labelOfPerson.font = [UIFont boldSystemFontOfSize:15];
    labelOfPerson.textColor = HexRGBAlpha(0xf5532d, 1.0);
    labelOfPerson.textAlignment = NSTextAlignmentCenter;
    [_myHMMCustomCircleView addSubview:labelOfPerson];
    
} // 彩色圆环中心控件

- (void)createDetailInfoDisplay:(NSInteger)whichViewNum {
    //    140 * _rateOfDevice
    
    NSArray *arrOfDayDetailDisplayType = @[@{@"icon_energy":NSLocalizedString(@"卡", nil) }, @{@"icon_step":NSLocalizedString(@"有效时间", nil)}, @{@"icon_distance":NSLocalizedString(@"千米", nil)}];
    NSArray *arrOfZhouDetailDisplayType = @[@{@"icon_energy":@"Dayly distance:Km"}, @{@"icon_step":@"Weekly steps:K"}, @{@"icon_distance":@"Weekly distance"}];
    NSArray *arrOfYueDetailDisplayType = @[@{@"icon_energy":@"Dayly distance:Km"}, @{@"icon_step":@"Monthly steps:K"}, @{@"icon_distance":@"Monthly distance:K"}];
    NSArray *arrOfType = @[arrOfDayDetailDisplayType, arrOfZhouDetailDisplayType, arrOfYueDetailDisplayType];
    
    CGFloat distance = kScreenWidth / 3.0;
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *myBottomDetialView = [[UIView alloc] initWithFrame:CGRectMake(distance * i, (_myScrollViewOfViewchange.frame.size.height - ((140 - 50) * _rateOfDevice)) - (30 + 20 - 25)  * _rateOfDevice, distance, (140 - 50) * _rateOfDevice + (30 + 20)  * _rateOfDevice)];
        myBottomDetialView.backgroundColor = kRandomColor(0.0);
        myBottomDetialView.tag = 31201 * (i + 1) + 1;
        [_arrOfBaseView[whichViewNum] addSubview:myBottomDetialView];
        
        UIImageView *myImageViewBase = [[UIImageView alloc] initWithFrame:CGRectMake(distance / 4.0, 0, distance / 2.0, myBottomDetialView.frame.size.height / 3.0)];
        myImageViewBase.contentMode = UIViewContentModeScaleAspectFit;
        myImageViewBase.image = [UIImage imageNamed:[arrOfType[whichViewNum][i] allKeys][0]];
        [myBottomDetialView addSubview:myImageViewBase];
        
        CGFloat insideWidth = myBottomDetialView.frame.size.width;
        CGFloat insderheight = myBottomDetialView.frame.size.height;
        
        // 显示总时长的字样 like
        UILabel *myHourLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 40 - (18) + 15 * _rateOfDevice + 10, insderheight / 2.0 - 20, myImageViewBase.frame.size.width, 40)];
        myHourLable.text = @"00";
        myHourLable.adjustsFontSizeToFitWidth = YES;
        myHourLable.tag = 31201 * (i + 1) + 2 + (i + 1);
        myHourLable.adjustsFontSizeToFitWidth = YES;
        myHourLable.textAlignment = NSTextAlignmentCenter;
        myHourLable.backgroundColor = kRandomColor(0.0f);
        myHourLable.font = [UIFont boldSystemFontOfSize:26];
        myHourLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
        [myBottomDetialView addSubview:myHourLable];
        
        // 类型 like
        UILabel *labelOfTarget = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40 + 60 - 10, 100, 25)];
        labelOfTarget.adjustsFontSizeToFitWidth = YES;
        labelOfTarget.text = [arrOfType[whichViewNum][i] allObjects][0];
        labelOfTarget.font = [UIFont boldSystemFontOfSize:12];
        labelOfTarget.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
        labelOfTarget.textAlignment = NSTextAlignmentCenter;
        [myBottomDetialView addSubview:labelOfTarget];
    }
} // 创建下方详细信息接口

/**
 *  天
 */
- (void)createFirstViewContainTabelView {
    // 初始化
    DaySleepContainTableView *myDaySleepContainTableView = [[DaySleepContainTableView alloc] initWithFrame:CGRectMake(28, _myHMMCustomCircleView.frame.origin.y + _myHMMCustomCircleView.frame.size.height + 15 * _rateOfDevice, kScreenWidth - 28 * 2, kScreenHeight - 64 - (25 * _rateOfDevice) - _myHMMCustomCircleView.frame.size.height - (40 * _rateOfDevice) - ((140 + 30) * _rateOfDevice))];
    myDaySleepContainTableView.backgroundColor = [UIColor clearColor];
    
    // 参数
    myDaySleepContainTableView.row = 7;
    myDaySleepContainTableView.column = 7;
    
    // 是否是运动界面
    myDaySleepContainTableView.isSportVC = YES;
    
    [_arrOfBaseView[0] addSubview:myDaySleepContainTableView];
    
    // “时分数据表” UILabel
    UILabel *myShiFenShuJuBiaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, myDaySleepContainTableView.frame.origin.y + myDaySleepContainTableView.frame.size.height, kScreenWidth, 20)];
    myShiFenShuJuBiaoLabel.text = NSLocalizedString(@"时分数据表", nil);
    myShiFenShuJuBiaoLabel.textColor = kHexRGBAlpha(0xffffff, 0.4f);
    myShiFenShuJuBiaoLabel.font = [UIFont boldSystemFontOfSize:11];
    myShiFenShuJuBiaoLabel.textAlignment = NSTextAlignmentCenter;
    [_arrOfBaseView[0] addSubview:myShiFenShuJuBiaoLabel];
} // "天" TableView
/**
 *  周
 */
- (void)createZhouViewContainTabelView {
    self.myZhouSleepContainTableView = [[ZhouYueSleepContainTableView alloc] initWithFrame:CGRectMake(28, 10, screen_width - 28 * 2, screen_width - 28 * 2)];
    _myZhouSleepContainTableView.isZhou = YES;
    _myZhouSleepContainTableView.isSportVC = YES;
    _myZhouSleepContainTableView.backgroundColor = [UIColor clearColor];
    [_arrOfBaseView[1] addSubview:_myZhouSleepContainTableView];
    
    __weak AnotherSportVC *weakSelf = self;
    _myZhouSleepContainTableView.myReturnBlockOfMaxPageOfZhouOfSport = ^(NSInteger maxPgeeNum) {
        weakSelf.maxPageOfZhou = maxPgeeNum;
    };
    
    __weak NSMutableArray *weakArrOfBaseView = _arrOfBaseView;
    _myZhouSleepContainTableView.myReturnBlockOfThisDayStep = ^(NSString *strOfSetps){
        ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = strOfSetps;
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", [strOfSetps integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2]).text = [NSString stringWithFormat:@".1%lf", [strOfSetps integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            [[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4];
        }
    };
    
    __weak HMMCustomCircleView *weakMyHMMCustomCircleView = _myHMMCustomCircleView;
    _myZhouSleepContainTableView.myReturnBlockOfAllDaysSteps = ^(NSMutableArray *mutArr) {
        weakSelf.mutArrOfallDays = [NSMutableArray arrayWithArray:mutArr];
        if (weakSelf.mutArrOfallDays.count == 0) {
            weakSelf.mutArrOfallDays = [NSMutableArray arrayWithArray:@[@{@"":@"0"}]];
        }
        ((UILabel *)[weakMyHMMCustomCircleView viewWithTag:312001]).text = [weakSelf.mutArrOfallDays[0] allObjects][0];
        weakSelf.numOfAllDays = weakSelf.mutArrOfallDays.count;
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * (((170) - 13.63636) * 0.000693 + 0.00495)];
                
                ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * ((([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) - 13.63636) * 0.000693 + 0.00495)];
                
                ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", ([[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue]) * (((170) - 13.63636) * 0.000693 + 0.00495)];
            
            ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfallDays[self.pageOfCicle] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        }
        
        ((UILabel *)[[weakArrOfBaseView[0] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfallDays[self.pageOfCicle] allObjects][0] integerValue] / 10000.0];
//        NSLog(@"😍%@", weakSelf.mutArrOfallDays);
//       NSLog(@"😍%ld", weakSelf.numOfAllDays);
    };
    
    // 所有周数据
    _myZhouSleepContainTableView.myReturnBlockOfAllWeeksArr = ^(NSMutableArray *mutArr) {
        weakSelf.mutArrOfZhou = [NSMutableArray arrayWithArray:mutArr];
        
        if (mutArr.count == 0) {
            
        } else {
            if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
                if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                    ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
                } else {
                    ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
                }
            } else {
                ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            }
            ((UILabel *)[[weakArrOfBaseView[1] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfZhou[self.pageNumZhou] allObjects][0] integerValue] / 10000.0];
        }
        
    };
    
    // 周日历选择
    UIView *myZhouSlectedView = [[UILabel alloc] initWithFrame:CGRectMake(0, _myZhouSleepContainTableView.frame.origin.y + _myZhouSleepContainTableView.frame.size.height + 25, kScreenWidth, 30)];
    myZhouSlectedView.userInteractionEnabled = YES;
    myZhouSlectedView.tag = 31404;
    myZhouSlectedView.backgroundColor = kRandomColor(0.0);
    
    UIButton *myCalenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myCalenderBtn.frame = CGRectMake(20, 0, 20, 20);
    [myCalenderBtn setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    [myCalenderBtn addTarget:self action:@selector(movecreatedCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [myZhouSlectedView addSubview:myCalenderBtn];
    myZhouSlectedView.userInteractionEnabled = YES;
    
    [_arrOfBaseView[1] addSubview:myZhouSlectedView];
    
    if (kScreenHeight == 480) {
        _myZhouSleepContainTableView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        myZhouSlectedView.transform = CGAffineTransformMakeTranslation(0, -30);
    }
    
    // 中间选择按钮后的字样
    UILabel *myCenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 180 / 2.0, 0, 180, 20)];
    myCenterLabel.text = @"2016.02.01-2016.03.29";
    myCenterLabel.tag = 31403;
    myCenterLabel.adjustsFontSizeToFitWidth = YES;
    myCenterLabel.backgroundColor = kRandomColor(0.0f);
    myCenterLabel.textColor = kHexRGBAlpha(0xc1c1c1, 1);
    myCenterLabel.font = [UIFont boldSystemFontOfSize:11];
    [myZhouSlectedView addSubview:myCenterLabel];
    myCenterLabel.userInteractionEnabled = YES;
    myCenterLabel.textAlignment = NSTextAlignmentCenter;
    
    // 两侧的 btn
    self.leftBtnOfZhou = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtnOfZhou setBackgroundImage:[UIImage imageNamed:@"icon_lefting"] forState:UIControlStateNormal];
    _leftBtnOfZhou.backgroundColor = kRandomColor(0.0f);
    _leftBtnOfZhou.frame = CGRectMake(0, -5, 20, 30);
    _leftBtnOfZhou.contentMode = UIViewContentModeScaleAspectFit;
    [myCenterLabel addSubview:_leftBtnOfZhou];
    _leftBtnOfZhou.tag = 31401;
    [_leftBtnOfZhou addTarget:self action:@selector(leftBtnCick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtnOfZhou = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtnOfZhou setBackgroundImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    _rightBtnOfZhou.backgroundColor = kRandomColor(0.0f);
    _rightBtnOfZhou.contentMode = UIViewContentModeScaleAspectFit;
    _rightBtnOfZhou.frame = CGRectMake(myCenterLabel.frame.size.width - 20, -5, 20, 30);
    _rightBtnOfZhou.enabled = NO;
    [myCenterLabel addSubview:_rightBtnOfZhou];
    _rightBtnOfZhou.tag = 31402;
    [_rightBtnOfZhou addTarget:self action:@selector(rightBtnCick:) forControlEvents:UIControlEventTouchUpInside];
} // "周" TableView
- (void)leftBtnCick:(id)sender {
    if (self.mutArrOfZhou.count == 0) {
        _leftBtnOfZhou.enabled = NO;
        _rightBtnOfZhou.enabled = YES;
    } else {
        _rightBtnOfZhou.enabled = YES;
        NSLog(@"%ld", self.pageNumYue);
        self.pageNumZhou ++;
        if (self.pageNumZhou >= self.maxPageOfZhou - 1) {
            self.pageNumZhou = self.maxPageOfZhou - 1;
            ((UIButton *)sender).enabled = NO;
        }
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        }
        
        ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfZhou[self.pageNumZhou] allObjects][0] integerValue] / 10000.0];
    }
    
    [_myZhouSleepContainTableView refreshZhouTabelViewPositionPage:self.pageNumZhou];
} // 周左切换
- (void)rightBtnCick:(id)sender {
    if (self.mutArrOfZhou.count == 0) {
        _rightBtnOfZhou.enabled = NO;
        _leftBtnOfZhou.enabled = YES;
    } else {
        _leftBtnOfZhou.enabled = YES;
        self.pageNumZhou --;
        if (self.pageNumZhou <= 0) {
            self.pageNumZhou = 0;
            ((UIButton *)sender).enabled = NO;
            [_myZhouSleepContainTableView refreshZhouTabelViewPositionPage:self.pageNumZhou];
        }
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfZhou[self.pageNumZhou] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        }
        
        ((UILabel *)[[_arrOfBaseView[1] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfZhou[self.pageNumZhou] allObjects][0] integerValue] / 10000.0];
    }
    
    [_myZhouSleepContainTableView refreshZhouTabelViewPositionPage:self.pageNumZhou];
} // 周右切换

/**
 *  月
 */
- (void)createYueViewContainTabelView {
    self.myYueSleepContainTableView = [[ZhouYueSleepContainTableView alloc] initWithFrame:CGRectMake(28, 10, screen_width - 28 * 2, screen_width - 28 * 2)];
    _myYueSleepContainTableView.isZhou = NO;
    _myYueSleepContainTableView.isSportVC = YES;
    _myYueSleepContainTableView.mounthDay = 30;
    _myYueSleepContainTableView.backgroundColor = [UIColor clearColor];
    [_arrOfBaseView[2] addSubview:_myYueSleepContainTableView];
    
    __weak AnotherSportVC *weakSelf = self;
    _myYueSleepContainTableView.myReturnBlockOfMaxPageYueOfSportt = ^(NSInteger maxPgeeNum) {
        weakSelf.maxPageOfYue = maxPgeeNum;
    };
    
    __weak NSMutableArray *weakArrOfBaseView = _arrOfBaseView;
    _myYueSleepContainTableView.myReturnBlockOfThisDayStep = ^(NSString *strOfSetps){
        ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = strOfSetps;
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
               ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", [strOfSetps integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 1 + 1] viewWithTag:31201 * 1 + 2 + 1]).text = [NSString stringWithFormat:@"%.1lf", [strOfSetps integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            [[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4];
        }
    };
    
    // 所有月数据
    _myYueSleepContainTableView.myReturnBlockOfAllYueArr = ^(NSMutableArray *mutArr) {
        weakSelf.mutArrOfYue = [NSMutableArray arrayWithArray:mutArr];
        
        NSLog(@"%@", mutArr);
    
        if (mutArr.count == 0) {
            
        } else {
            if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
                if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                    ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
                } else {
                    ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
                }
            } else {
                ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            }
            ((UILabel *)[[weakArrOfBaseView[2] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfYue[self.pageNumYue] allObjects][0] integerValue] / 10000.0];
        }
    };
    
    // 月日历选择
    UIView *myZhouSlectedView = [[UILabel alloc] initWithFrame:CGRectMake(0, _myYueSleepContainTableView.frame.origin.y + _myYueSleepContainTableView.frame.size.height + 25, kScreenWidth, 30)];
    myZhouSlectedView.userInteractionEnabled = YES;
    myZhouSlectedView.backgroundColor = kRandomColor(0.0);
    
    UIButton *myCalenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myCalenderBtn.frame = CGRectMake(20, 0, 20, 20);
    [myCalenderBtn setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    [myCalenderBtn addTarget:self action:@selector(movecreatedCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [myZhouSlectedView addSubview:myCalenderBtn];
    
    [_arrOfBaseView[2] addSubview:myZhouSlectedView];
    
    if (kScreenHeight == 480) {
        _myYueSleepContainTableView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        myZhouSlectedView.transform = CGAffineTransformMakeTranslation(0, -30);
    }
    
    // 中间选择按钮后的字样
    UILabel *myCenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 180 / 2.0, 0, 180, 20)];
    myCenterLabel.text = @"2016.02.01-2016.03.29";
    myCenterLabel.adjustsFontSizeToFitWidth = YES;
    myCenterLabel.backgroundColor = kRandomColor(0.0f);
    myCenterLabel.textColor = kHexRGBAlpha(0xc1c1c1, 1);
    myCenterLabel.font = [UIFont boldSystemFontOfSize:11];
    [myZhouSlectedView addSubview:myCenterLabel];
    myCenterLabel.userInteractionEnabled = YES;
    myCenterLabel.textAlignment = NSTextAlignmentCenter;
    
    // 两侧的 btn
    self.leftBtnOfYue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtnOfYue setBackgroundImage:[UIImage imageNamed:@"icon_lefting"] forState:UIControlStateNormal];
    _leftBtnOfYue.backgroundColor = kRandomColor(0.0f);
    _leftBtnOfYue.frame = CGRectMake(0, -5, 20, 30);
    _leftBtnOfYue.contentMode = UIViewContentModeScaleAspectFit;
    [myCenterLabel addSubview:_leftBtnOfYue];
    [_leftBtnOfYue addTarget:self action:@selector(leftBtnCick1:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtnOfYue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtnOfYue setBackgroundImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    _rightBtnOfYue.backgroundColor = kRandomColor(0.0f);
    _rightBtnOfYue.contentMode = UIViewContentModeScaleAspectFit;
    _rightBtnOfYue.frame = CGRectMake(myCenterLabel.frame.size.width - 20, -5, 20, 30);
    [myCenterLabel addSubview:_rightBtnOfYue];
    _rightBtnOfYue.enabled = NO;
    [_rightBtnOfYue addTarget:self action:@selector(rightBtnCick1:) forControlEvents:UIControlEventTouchUpInside];
} // "月" TableView
- (void)leftBtnCick1:(id)sender {
    if (self.mutArrOfYue.count == 0) {
        _rightBtnOfYue.enabled = YES;
        _leftBtnOfYue.enabled = NO;
    } else {
        _rightBtnOfYue.enabled = YES;
        self.pageNumYue ++;
        _rightBtnOfYue.enabled = YES;
        if (self.pageNumYue >= self.maxPageOfYue - 1) {
            self.pageNumYue = self.maxPageOfYue - 1;
            _leftBtnOfYue.enabled = NO;
        }
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        }
        ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfYue[self.pageNumYue] allObjects][0] integerValue] / 10000.0];
        
        [_myYueSleepContainTableView refreshZhouTabelViewPositionPage:self.pageNumYue];
    }
} // 月左切换
- (void)rightBtnCick1:(id)sender {
    if (self.mutArrOfYue.count == 0) {
        _rightBtnOfYue.enabled = NO;
        _leftBtnOfYue.enabled = YES;
    } else {
        self.pageNumYue --;
        _leftBtnOfYue.enabled = YES;
        if (self.pageNumYue <= 0) {
            self.pageNumYue = 0;
            _rightBtnOfYue.enabled = NO;
        }
        
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] isEqualToString:@"Enter your height"]) {
                ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
            } else {
                ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * (([[[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"][3] allObjects][0] substringFromIndex:4] integerValue]) * 0.45/100.0)/1000.0];
            }
        } else {
            ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 3 + 1] viewWithTag:31201 * 3 + 2 + 3]).text = [NSString stringWithFormat:@"%.1lf", [([self.mutArrOfYue[self.pageNumYue] allObjects][0]) integerValue] * ((170) * 0.45/100.0)/1000.0];
        }
        ((UILabel *)[[_arrOfBaseView[2] viewWithTag:31201 * 2 + 1] viewWithTag:31201 * 2 + 2 + 2]).text = [NSString stringWithFormat:@"%.2lf", [[self.mutArrOfYue[self.pageNumYue] allObjects][0] integerValue] / 10000.0];
        
        [_myYueSleepContainTableView refreshZhouTabelViewPositionPage:self.pageNumYue];
    }
} // 月右切换

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isFromTagClick) {
        CGFloat widthOfSeperateView = (kScreenWidth - 30 * 6) / 3.0;
        CGFloat rateDistance = (widthOfSeperateView + 60) / 375;
        
        _mySelectedTag.selectedSegmentIndex = (scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth;
        _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance + 15 * _mySelectedTag.selectedSegmentIndex, 64 + 37, widthOfSeperateView, 1);
        if (kScreenHeight == 480) {
            _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance + 15 * _mySelectedTag.selectedSegmentIndex, 64 + 37, widthOfSeperateView, 1);
        } else if (kScreenHeight == 568) {
            _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance + 15 * _mySelectedTag.selectedSegmentIndex, 64 + 37, widthOfSeperateView, 1);
        } else if (kScreenHeight == 667) {
            _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance + 15 * 0, 64 + 37, widthOfSeperateView, 1);
        } else {
            _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance - 15 * _mySelectedTag.selectedSegmentIndex, 64 + 37, widthOfSeperateView, 1);
        }
        
        //       _mySelectedTag.selectedSegmentIndex = (scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth;
        //        NSLog(@"%lf", (scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth);
        if ((((scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth) > 1.4) && ((scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth) < 1.43) {
            [_myHMMCustomCircleView removeFromSuperview];
            _myHMMCustomCircleView = nil;
            [self createDynamicCircleView:YES];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

#pragma mark -
#pragma mark - UITableViewDataSource

#pragma mark -
#pragma mark - UITableViewDelegate


/**
 *  日历代理方法
 */
#pragma mark - Toolbar Items
- (void)modeChangedUsingControl:(id)sender
{
    [[self calendarView] setDisplayMode:[[self modePicker] selectedSegmentIndex]];
}

- (void)todayButtonTapped:(id)sender
{
    [[self calendarView] setDate:[NSDate date] animated:NO];
}

#pragma mark - CKCalendarViewDataSource
- (NSArray *)calendarView:(CKCalendarView *)CalendarView eventsForDate:(NSDate *)date
{
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        return [[self dataSource] calendarView:CalendarView eventsForDate:date];
    }
    return nil;
}

#pragma mark - CKCalendarViewDelegate
// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [[self delegate] calendarView:calendarView willSelectDate:date];
    }
}

- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:calendarView didSelectDate:date];
    }
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)calendarView didSelectEvent:(CKCalendarEvent *)event
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [[self delegate] calendarView:calendarView didSelectEvent:event];
    }
}

#pragma mark - Calendar View
- (CKCalendarView *)calendarView
{
    return _calendarView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
