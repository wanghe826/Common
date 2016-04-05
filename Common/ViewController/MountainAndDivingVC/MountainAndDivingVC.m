//
//  MountainAndDivingVC.m
//  Common
//
//  Created by HuMingmin on 16/3/2.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "MountainAndDivingVC.h"

#import "MountainVC.h" // 登山界面
#import "DivingVC.h" // 潜水界面

@interface MountainAndDivingVC ()

@property (nonatomic, strong) CKCalendarView *calendarView; // 日历
@property (nonatomic, strong) UISegmentedControl *modePicker;
@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation MountainAndDivingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialNavigationbar]; // 重写并初始化 Nav
    [self createFirstView]; // 创建登山潜水一级界面
    [self createCalendar:nil]; // 创建日历
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createShareBtn];
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

- (void) initialNavigationbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    self.title = NSLocalizedString(@"登山/潜水", nil);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
}
- (void) settingAction {
    
}

- (void) shareAction {
    
}

/**
 *  创建登山潜水一级界面
 */
- (void)createFirstView {
    // 天气预报 Views 模块
    NSArray *testArr1 = @[@"icon_cloudy_en", @"icon_sunny_en", @"icon_rain_en"];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        testArr1 = @[@"icon_cloudy", @"icon_sunny", @"icon_rain"];
    }
    UIImageView *myImageViewOfWeatherPic = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - (kScreenWidth / 3.0) / 2.0, 64 + 30, kScreenWidth / 3.0, kScreenWidth / 3.0)];
    myImageViewOfWeatherPic.image = [UIImage imageNamed:testArr1[arc4random_uniform(1)]];
    myImageViewOfWeatherPic.transform = CGAffineTransformMakeScale(0.85, 0.85);
    myImageViewOfWeatherPic.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:myImageViewOfWeatherPic];
    
    // 天气详情 Label
    NSArray *testArr2 = @[@"110.0kPa", @"44℃", @"100m"];
    NSArray *testArr3 = @[@"Pressure", @"Temperature", @"Elevation"];
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        testArr3 = @[@"气压", @"温度", @"海拔"];
    }
    for (NSInteger i = 0; i < 2; i ++) {
        for (NSInteger j = 0; j < 3; j ++) {
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 3.0 * j, (myImageViewOfWeatherPic.frame.size.height + myImageViewOfWeatherPic.frame.origin.y) + 18 + (30 - 5) * i + 10, kScreenWidth / 3.0, 30)];
            myLabel.backgroundColor = kRandomColor(0.0);
            [self.view addSubview:myLabel];
            myLabel.adjustsFontSizeToFitWidth = YES;
            myLabel.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                myLabel.text = testArr2[j];
                myLabel.textColor = kHexRGBAlpha(0x425784, 1.0f);
                myLabel.font = [UIFont boldSystemFontOfSize:18];
            } else {
                myLabel.text = testArr3[j];
                myLabel.textColor = kHexRGBAlpha(0x2e3c5b, 1.0f);
                myLabel.font = [UIFont boldSystemFontOfSize:15];
            }
            
            if (j == 0) {
                myLabel.transform = CGAffineTransformMakeTranslation(15, 0);
            } else if (j == 2) {
                myLabel.transform = CGAffineTransformMakeTranslation(-15, 0);
            }
        }
    }
    
    // 创建爬山潜水的点击 Button
    NSArray *testArr4 = @[@"btn_mountaineering", @"btn_diving"];
    NSArray *arrOfSelectedLabelText = @[@"Mountaineering", @"Diving"];
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        arrOfSelectedLabelText = @[@"登山", @"潜水"];
    }
    for (NSInteger i = 0; i < 2; i ++) {
        UIImageView *myImageViewOfBackBtn = [[UIImageView alloc] initWithFrame:CGRectMake((2 * kScreenWidth / 4.0) * i + kScreenWidth / 4.0 / 2.0, (myImageViewOfWeatherPic.frame.size.height + myImageViewOfWeatherPic.frame.origin.y) + 200 - 10, kScreenWidth / 4.0, kScreenWidth / 4.0)];
        myImageViewOfBackBtn.image = [UIImage imageNamed:@"ing_rectangle"];
        [self.view addSubview:myImageViewOfBackBtn];
        myImageViewOfBackBtn.userInteractionEnabled = YES;
        
        // 登山、潜水选择按钮
        UIButton *mySelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mySelectedBtn setImage:[UIImage imageNamed:testArr4[i]] forState:UIControlStateNormal];
        mySelectedBtn.frame = CGRectMake(15, 15, myImageViewOfBackBtn.frame.size.width - 30, myImageViewOfBackBtn.frame.size.height - 30);
        [myImageViewOfBackBtn addSubview:mySelectedBtn];
        mySelectedBtn.tag = 20 + i;
        [mySelectedBtn addTarget:self action:@selector(mySelectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 文字说明
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(myImageViewOfBackBtn.frame.origin.x + myImageViewOfBackBtn.frame.size.width / 2.0 - 120 / 2.0, myImageViewOfBackBtn.frame.size.height + 20 + myImageViewOfBackBtn.frame.origin.y + 10 - 10, 120, 24)];
        myLabel.backgroundColor = kRandomColor(0.0f);
        myLabel.textColor = kHexRGBAlpha(0xffffff, 1.0f);
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.text = arrOfSelectedLabelText[i];
        [self.view addSubview:myLabel];
        if (kScreenHeight == 480) {
            myLabel.transform = CGAffineTransformMakeTranslation(0, -100);
        }
        
        // 日历选择按钮
        UIButton *myCalenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [myCalenderBtn setImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
        myCalenderBtn.frame = CGRectMake(myImageViewOfBackBtn.frame.origin.x + myImageViewOfBackBtn.frame.size.width / 2.0 - 26 / 2.0, myImageViewOfBackBtn.frame.size.height + 20 + myImageViewOfBackBtn.frame.origin.y + 10 + 20, 26, 24);
        [self.view addSubview:myCalenderBtn];
        [myCalenderBtn addTarget:self action:@selector(movecreatedCalendar:) forControlEvents:UIControlEventTouchUpInside];
        myCalenderBtn.alpha = 0.8;
        
        if (kScreenHeight == 480) {
            myImageViewOfBackBtn.transform = CGAffineTransformMakeTranslation(0, -80);
            myCalenderBtn.transform = CGAffineTransformMakeTranslation(0, -100);
        }
    }
    
}
- (void)mySelectedBtnClick:(id)sender {
    if ([sender tag] == 20) {
        [self.navigationController pushViewController:[MountainVC new] animated:YES];
    } else {
        [self.navigationController pushViewController:[DivingVC new] animated:YES];
    }
}
- (void)movecreatedCalendar:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.view viewWithTag:100].transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  创建日历
 */
- (void)createCalendar:(id)semder {
    
    UIView *myAllViewLike = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    myAllViewLike.tag = 100;
    myAllViewLike.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myAllViewLike];
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 320) / 2.0, 0, kScreenWidth, 350)];
    blankView.backgroundColor = [UIColor clearColor];
    [myAllViewLike addSubview:blankView];
    
    if (kScreenHeight == 667) {
        blankView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.185, 1.185), 0, 20);
    } else if (kScreenHeight == 736) {
        blankView.transform = CGAffineTransformTranslate(CGAffineTransformTranslate(CGAffineTransformMakeScale(1.3, 1.3), 0, 20), 8, 10);
    }
    
    /* Prepare the events array */
    [self setEvents:[NSMutableArray new]];
    
    /* Calendar View */
    [self setCalendarView:[CKCalendarView new]];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    [self calendarView].transform = CGAffineTransformMakeTranslation(0, 64);
    
    [blankView addSubview:[self calendarView]];
    
    [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    [[self calendarView] setDisplayMode:CKCalendarViewModeMonth animated:NO];
    
    UIButton *myBaseViewDis = [UIButton buttonWithType:UIButtonTypeCustom];
    myBaseViewDis.frame = CGRectMake(0, blankView.frame.size.height, kScreenWidth, kScreenHeight);
    myBaseViewDis.tag = 101;
    myBaseViewDis.backgroundColor = [UIColor clearColor];
    [myAllViewLike addSubview:myBaseViewDis];
    [myBaseViewDis addTarget:self action:@selector(tapMyBaseView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self calendarView].returnClickBlock = ^(NSInteger index, NSInteger num) {
        [UIView animateWithDuration:1.0f animations:^{
            [self calendarView].transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
        }];
    };
}
- (void)tapMyBaseView:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.view viewWithTag:100].transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
    
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
