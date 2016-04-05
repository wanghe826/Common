//
//  SleepVC.m
//  Common
//
//  Created by HMM－MACmini on 16/2/25.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SleepVC.h" // 睡眠界面

#import "HMMCustomCircleView.h" // 自定义彩色圆环界面
#import "DaySleepContainTableView.h" // 睡眠界面中包涵柱状图的自定义 View
#import "ZhouYueSleepContainTableView.h" // 周月中包涵柱状图的自定义 View

@interface SleepVC () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CKCalendarViewDataSource, CKCalendarViewDelegate>

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

@end

@implementation SleepVC

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
    
    self.title = NSLocalizedString(@"睡眠", nil);
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
        [shareButton setFrame:CGRectMake(screen_width - 77, 10, 25, 25)];
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
    
    // 控制位置的一个 View
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 320) / 2.0, 0, kScreenWidth, 300 + 64 + 30)];
    blankView.backgroundColor = [UIColor clearColor];
    [myAllViewLike addSubview:blankView];
    
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
        [self createDynamicCircleView];
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
        [_myScrollViewOfViewchange addSubview:baseView];
        
        [self.arrOfBaseView addObject:baseView];
    } // 创建三个测试 UIView
    
    [self createDynamicCircleView]; // 创建动态圆环
    [self createFirstViewContainTabelView]; // 睡眠界面中包涵柱状图的自定义 View
    [self createZhouYueViewContainTabelView1];
    [self createZhouYueViewContainTabelView2];
    [self createDetailInfoDisplay:0]; // 创建下方详情显示控件0
    [self createDetailInfoDisplay:1]; // 创建下方详情显示控件1
    [self createDetailInfoDisplay:2]; // 创建下方详情显示控件2
    [self createCalendarView]; // 创建日历点击控件
//    [self createLikeNav]; // 创建类似NavView
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
    myTitleLabel.text = NSLocalizedString(@"睡眠", nil);
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
}
- (void)createDynamicCircleView {
    _myHMMCustomCircleView = [[HMMCustomCircleView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - (240 * _rateOfDevice) / 2.0, 25 * _rateOfDevice, 240 * _rateOfDevice, 240 * _rateOfDevice)];
    _myHMMCustomCircleView.personOf = 80;
    _myHMMCustomCircleView.totle = 100;
    [_myHMMCustomCircleView startAnimating];
    
    [_arrOfBaseView[0] addSubview:_myHMMCustomCircleView];
    
    [self createCentenViews]; // 创建中心子视图
}
- (void)createCentenViews {
    
    CGFloat insideWidth = _myHMMCustomCircleView.frame.size.width;
    CGFloat insderheight = _myHMMCustomCircleView.frame.size.height;
    
    // 显示总时长的字样
    UILabel *myHourLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 40 - (18), insderheight / 2.0 - 20, 40, 40)];
    myHourLable.text = @"10";
    myHourLable.font = [UIFont boldSystemFontOfSize:30];
    myHourLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
    [_myHMMCustomCircleView addSubview:myHourLable];
    
    // “时”
    UILabel *labelOfShi = [[UILabel alloc] initWithFrame:CGRectMake(myHourLable.frame.size.width - 3, myHourLable.frame.size.height / 2.0 - 5, myHourLable.frame.size.width / 2.0 - 5, myHourLable.frame.size.height / 2.0)];
    labelOfShi.text =  NSLocalizedString(@"时", nil) ;
    labelOfShi.font = [UIFont boldSystemFontOfSize:15];
    labelOfShi.textColor = HexRGBAlpha(0xececec, 1.0);
    [myHourLable addSubview:labelOfShi];
    
    // 显示分长的字样
    UILabel *myMinLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 + 20 - (18), insderheight / 2.0 - 20, 40, 40)];
    myMinLable.text = @"36";
    myMinLable.font = [UIFont boldSystemFontOfSize:30];
    myMinLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
    [_myHMMCustomCircleView addSubview:myMinLable];
    
    // “分”
    UILabel *labelOfFen = [[UILabel alloc] initWithFrame:CGRectMake(myMinLable.frame.size.width - 3, myMinLable.frame.size.height / 2.0 - 5, myMinLable.frame.size.width / 2.0 - 5, myMinLable.frame.size.height / 2.0)];
    labelOfFen.text = NSLocalizedString(@"分", nil);
    labelOfFen.adjustsFontSizeToFitWidth = YES;
    labelOfFen.font = [UIFont boldSystemFontOfSize:15];
    labelOfFen.textColor = HexRGBAlpha(0xececec, 1.0);
    [myMinLable addSubview:labelOfFen];
    
    // “总睡眠时间”
    UILabel *labelOfTotleTime = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 140 / 2.0, insderheight / 2.0 - 40, 140, 25)];
    labelOfTotleTime.text = NSLocalizedString(@"总睡眠时间", nil);
    labelOfFen.adjustsFontSizeToFitWidth = YES;
    labelOfTotleTime.font = [UIFont boldSystemFontOfSize:15];
    
    labelOfTotleTime.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
    labelOfTotleTime.textAlignment = NSTextAlignmentCenter;
    [_myHMMCustomCircleView addSubview:labelOfTotleTime];
    
    // 目标
    UILabel *labelOfTarget = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 120 / 2.0, insderheight / 2.0 - 40 + 60, 120, 25)];
    labelOfTarget.text = [NSString stringWithFormat:@"%@：%@%@", NSLocalizedString(@"目标", nil), @"10000", NSLocalizedString(@"时", nil)];
    labelOfTarget.font = [UIFont boldSystemFontOfSize:15];
    labelOfTarget.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
    labelOfTarget.textAlignment = NSTextAlignmentCenter;
    [_myHMMCustomCircleView addSubview:labelOfTarget];
    
    // 百分比
    UILabel *labelOfPerson = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40 + 80, 100, 25)];
    labelOfPerson.text = [NSString stringWithFormat:@"%.0f%%", 67 / 100.0 * 100];
    labelOfPerson.font = [UIFont boldSystemFontOfSize:15];
    labelOfPerson.textColor = HexRGBAlpha(0xf5532d, 1.0);
    labelOfPerson.textAlignment = NSTextAlignmentCenter;
    [_myHMMCustomCircleView addSubview:labelOfPerson];
    
}
- (void)createDetailInfoDisplay:(NSInteger)whichViewNum {
//    140 * _rateOfDevice
    
    NSArray *arrOfType = @[@{@"icon_deep_sleep":NSLocalizedString(@"深睡时间", nil)}, @{@"icon_light_sleep":NSLocalizedString(@"浅睡时间", nil)}, @{@"btn_wake":NSLocalizedString(@"醒着时间", nil)}];
    
    CGFloat distance = kScreenWidth / 3.0;
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *myBottomDetialView = [[UIView alloc] initWithFrame:CGRectMake(distance * i, (_myScrollViewOfViewchange.frame.size.height - ((140 - 50) * _rateOfDevice)) - (30 + 20 - 25)  * _rateOfDevice, distance, (140 - 50) * _rateOfDevice + (30 + 20)  * _rateOfDevice)];
//        myBottomDetialView.backgroundColor = kRandomColor(1.0);
        [_arrOfBaseView[whichViewNum] addSubview:myBottomDetialView];
        
        UIImageView *myImageViewBase = [[UIImageView alloc] initWithFrame:CGRectMake(distance / 4.0, 0, distance / 2.0, myBottomDetialView.frame.size.height / 3.0)];
        myImageViewBase.contentMode = UIViewContentModeScaleAspectFit;
        myImageViewBase.image = [UIImage imageNamed:[arrOfType[i] allKeys][0]];
        [myBottomDetialView addSubview:myImageViewBase];
        
        CGFloat insideWidth = myBottomDetialView.frame.size.width;
        CGFloat insderheight = myBottomDetialView.frame.size.height;
        
        // 显示总时长的字样 like
        UILabel *myHourLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 40 - (18) + 15 * _rateOfDevice + 5, insderheight / 2.0 - 20, 40, 40)];
        myHourLable.text = @"10";
        myHourLable.adjustsFontSizeToFitWidth = YES;
        myHourLable.font = [UIFont boldSystemFontOfSize:26];
        myHourLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
        [myBottomDetialView addSubview:myHourLable];
        
        // “时” like
        UILabel *labelOfShi = [[UILabel alloc] initWithFrame:CGRectMake(myHourLable.frame.size.width - 10 * _rateOfDevice, myHourLable.frame.size.height / 2.0 - 5, myHourLable.frame.size.width / 2.0 - 5, myHourLable.frame.size.height / 2.0)];
        labelOfShi.text = NSLocalizedString(@"时", nil);
        labelOfShi.font = [UIFont boldSystemFontOfSize:12];
        labelOfShi.textColor = HexRGBAlpha(0xececec, 1.0);
        [myHourLable addSubview:labelOfShi];
        
        // 显示分长的字样 like
        UILabel *myMinLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 + 20 - (18) + 5 * _rateOfDevice - 5, insderheight / 2.0 - 20, 40, 40)];
        myMinLable.text = @"36";
        myMinLable.font = [UIFont boldSystemFontOfSize:26];
        myMinLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
        [myBottomDetialView addSubview:myMinLable];
        
        // “分” like
        UILabel *labelOfFen = [[UILabel alloc] initWithFrame:CGRectMake(myMinLable.frame.size.width - 8 * _rateOfDevice, myMinLable.frame.size.height / 2.0 - 5, myMinLable.frame.size.width / 2.0 - 5, myMinLable.frame.size.height / 2.0)];
        labelOfFen.text = NSLocalizedString(@"分", nil);
        labelOfFen.adjustsFontSizeToFitWidth = YES;
        labelOfFen.font = [UIFont boldSystemFontOfSize:12];
        labelOfFen.textColor = HexRGBAlpha(0xececec, 1.0);
        [myMinLable addSubview:labelOfFen];
        
        // 类型 like
        UILabel *labelOfTarget = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40 + 60 - 10, 100, 25)];
        labelOfTarget.text = [arrOfType[i] allObjects][0];
        labelOfTarget.font = [UIFont boldSystemFontOfSize:12];
        labelOfTarget.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
        labelOfTarget.textAlignment = NSTextAlignmentCenter;
        labelOfTarget.adjustsFontSizeToFitWidth = YES;
        [myBottomDetialView addSubview:labelOfTarget];
    }
} // 创建下方详细信息接口
- (void)createFirstViewContainTabelView {
    DaySleepContainTableView *myDaySleepContainTableView = [[DaySleepContainTableView alloc] initWithFrame:CGRectMake(28, _myHMMCustomCircleView.frame.origin.y + _myHMMCustomCircleView.frame.size.height + 15 * _rateOfDevice, kScreenWidth - 28 * 2, kScreenHeight - 64 - (25 * _rateOfDevice) - _myHMMCustomCircleView.frame.size.height - (40 * _rateOfDevice) - ((140 + 30) * _rateOfDevice))];
    myDaySleepContainTableView.backgroundColor = [UIColor clearColor];
    
    // 参数
    myDaySleepContainTableView.row = 7;
    myDaySleepContainTableView.column = 7;
    
    [_arrOfBaseView[0] addSubview:myDaySleepContainTableView];
    
    // “时分数据表”
    UILabel *myShiFenShuJUBiaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, myDaySleepContainTableView.frame.origin.y + myDaySleepContainTableView.frame.size.height, kScreenWidth, 20)];
    myShiFenShuJUBiaoLabel.text = NSLocalizedString(@"时分数据表", nil);
    myShiFenShuJUBiaoLabel.textColor = kHexRGBAlpha(0xffffff, 0.4f);
    myShiFenShuJUBiaoLabel.font = [UIFont boldSystemFontOfSize:11];
    myShiFenShuJUBiaoLabel.textAlignment = NSTextAlignmentCenter;
    [_arrOfBaseView[0] addSubview:myShiFenShuJUBiaoLabel];
}
- (void)createZhouYueViewContainTabelView1 {
    ZhouYueSleepContainTableView * myZhouYueSleepContainTableView = [[ZhouYueSleepContainTableView alloc] initWithFrame:CGRectMake(28, 10, screen_width - 28 * 2, screen_width - 28 * 2)];
    myZhouYueSleepContainTableView.isZhou = YES;
    myZhouYueSleepContainTableView.backgroundColor = [UIColor clearColor];
    [_arrOfBaseView[1] addSubview:myZhouYueSleepContainTableView];
    
    // 周日历选择
    UIView *myZhouSlectedView = [[UILabel alloc] initWithFrame:CGRectMake(0, myZhouYueSleepContainTableView.frame.origin.y + myZhouYueSleepContainTableView.frame.size.height + 25, kScreenWidth, 30)];
    myZhouSlectedView.userInteractionEnabled = YES;
    myZhouSlectedView.backgroundColor = kRandomColor(0.0);
   
    UIButton *myCalenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myCalenderBtn.frame = CGRectMake(20, 0, 20, 20);
    [myCalenderBtn setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    [myCalenderBtn addTarget:self action:@selector(movecreatedCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [myZhouSlectedView addSubview:myCalenderBtn];
    
    [_arrOfBaseView[1] addSubview:myZhouSlectedView];
    
    if (kScreenHeight == 480) {
        myZhouYueSleepContainTableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        myZhouSlectedView.transform = CGAffineTransformMakeTranslation(0, -30);
    }
    
    // 中间选择按钮后的字样
    UILabel *myCenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 130 / 2.0, 0, 130, 20)];
    myCenterLabel.text = @"2016.02.01-2016.03.29";
    myCenterLabel.adjustsFontSizeToFitWidth =YES;
    myCenterLabel.backgroundColor = kRandomColor(0.0f);
    myCenterLabel.textColor = kHexRGBAlpha(0xc1c1c1, 1);
    myCenterLabel.font = [UIFont boldSystemFontOfSize:11];
    [myZhouSlectedView addSubview:myCenterLabel];
    myCenterLabel.textAlignment = NSTextAlignmentCenter;
    // 两侧的 btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_lefting"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = kRandomColor(0.0f);
    leftBtn.frame = CGRectMake(-10 - 5 - 10, -5, 20, 30);
    leftBtn.contentMode = UIViewContentModeScaleAspectFit;
    [myCenterLabel addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnCick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = kRandomColor(0.0f);
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    rightBtn.frame = CGRectMake(myCenterLabel.frame.size.width + 5, -5, 20, 30);
    [myCenterLabel addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnCick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)leftBtnCick:(id)sender {
    
}
- (void)rightBtnCick:(id)sender {
    
}
- (void)createZhouYueViewContainTabelView2 {
    ZhouYueSleepContainTableView * myZhouYueSleepContainTableView = [[ZhouYueSleepContainTableView alloc] initWithFrame:CGRectMake(28, 10, screen_width - 28 * 2, screen_width - 28 * 2)];
    myZhouYueSleepContainTableView.isZhou = NO;
    myZhouYueSleepContainTableView.mounthDay = 30;
    myZhouYueSleepContainTableView.backgroundColor = [UIColor clearColor];
    [_arrOfBaseView[2] addSubview:myZhouYueSleepContainTableView];
    
    // 周日历选择
    UIView *myZhouSlectedView = [[UILabel alloc] initWithFrame:CGRectMake(0, myZhouYueSleepContainTableView.frame.origin.y + myZhouYueSleepContainTableView.frame.size.height + 25, kScreenWidth, 30)];
    myZhouSlectedView.userInteractionEnabled = YES;
    myZhouSlectedView.backgroundColor = kRandomColor(0.0);
    
    UIButton *myCalenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myCalenderBtn.frame = CGRectMake(20, 0, 20, 20);
    [myCalenderBtn setBackgroundImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    [myCalenderBtn addTarget:self action:@selector(movecreatedCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [myZhouSlectedView addSubview:myCalenderBtn];
    
    [_arrOfBaseView[2] addSubview:myZhouSlectedView];
    
    if (kScreenHeight == 480) {
        myZhouYueSleepContainTableView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        myZhouSlectedView.transform = CGAffineTransformMakeTranslation(0, -30);
    }
    
    
    // 中间选择按钮后的字样
    UILabel *myCenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 130 / 2.0, 0, 130, 20)];
    myCenterLabel.text = @"2016.02.01-2016.03.29";
    myCenterLabel.adjustsFontSizeToFitWidth =YES;
    myCenterLabel.backgroundColor = kRandomColor(0.0f);
    myCenterLabel.textColor = kHexRGBAlpha(0xc1c1c1, 1);
    myCenterLabel.font = [UIFont boldSystemFontOfSize:11];
    [myZhouSlectedView addSubview:myCenterLabel];
    myCenterLabel.textAlignment = NSTextAlignmentCenter;
    // 两侧的 btn
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_lefting"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = kRandomColor(0.0f);
    leftBtn.frame = CGRectMake(-10 - 5 - 10, -5, 20, 30);
    leftBtn.contentMode = UIViewContentModeScaleAspectFit;
    [myCenterLabel addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnCick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_righting"] forState:UIControlStateNormal];
    rightBtn.backgroundColor = kRandomColor(0.0f);
    rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    rightBtn.frame = CGRectMake(myCenterLabel.frame.size.width + 5, -5, 20, 30);
    [myCenterLabel addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnCick:) forControlEvents:UIControlEventTouchUpInside];
}

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
        
//        _mySelectedTag.selectedSegmentIndex = (scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth;
//        NSLog(@"%lf", (scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth);
        if ((((scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth) > 1.4) && ((scrollView.contentOffset.x + kScreenWidth / 2.0) / kScreenWidth) < 1.43) {
            [_myHMMCustomCircleView removeFromSuperview];
            _myHMMCustomCircleView = nil;
            [self createDynamicCircleView];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat widthOfSeperateView = (kScreenWidth - 30 * 6) / 3.0;
//    CGFloat rateDistance = (widthOfSeperateView + 60) / 375;
    
//    _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance, 64 + 37, widthOfSeperateView, 1);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (!decelerate) {
//        CGFloat widthOfSeperateView = (kScreenWidth - 30 * 6) / 3.0;
//        CGFloat rateDistance = (widthOfSeperateView + 60) / 375;
//        
//        _seperateView.frame = CGRectMake(30 + scrollView.contentOffset.x * rateDistance, 64 + 37, widthOfSeperateView, 1);
//    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

#pragma mark -
#pragma mark - UITableViewDelegate


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
