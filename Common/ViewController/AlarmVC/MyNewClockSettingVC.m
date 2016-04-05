//
//  MyNewClockSettingVC.m
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "MyNewClockSettingVC.h"

#import "ClockSelectedView.h"

@interface MyNewClockSettingVC ()

@property (nonatomic, strong) NSMutableArray *mutArrOfWhichDayChoice; // 存储一周内第几天有被选中
@property (nonatomic, strong) NSMutableArray *mutArrOfSelectedTime; // 想要存储的时间

@property (nonatomic, assign) NSInteger selectedNumTabel;
//@property (nonatomic, assign) NSInteger shiNum; // 时
//@property (nonatomic, assign) NSInteger fenNum; // 分

@property (nonatomic, assign) NSInteger tanshuiNum;
@property (nonatomic, assign) NSInteger tanShuiShiJian;

@end

@implementation MyNewClockSettingVC

- (NSMutableArray *)mutArrOfWhichDayChoice {
    if (!_mutArrOfWhichDayChoice) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Clock%ld", self.numOfSelectedClock]]) {
            _mutArrOfWhichDayChoice = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Clock%ld", self.numOfSelectedClock]]];
        } else {
            _mutArrOfWhichDayChoice = [NSMutableArray arrayWithArray:@[@"1", @"1", @"1", @"1", @"1", @"1", @"1"]];
        } /// 重复日数
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"MyClockTanShui%ld", self.numOfSelectedClock]]) {
            _tanShuiShiJian = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"MyClockTanShui%ld", self.numOfSelectedClock]] integerValue];
        } else {
            _tanShuiShiJian = 0;
        } // 贪睡
    }
    return _mutArrOfWhichDayChoice;
}
- (NSMutableArray *)mutArrOfSelectedTime {
    if (!_mutArrOfSelectedTime) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"MyClockTime%ld", self.numOfSelectedClock]]) {
            _mutArrOfSelectedTime = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"MyClockTime%ld", self.numOfSelectedClock]]];
        } else {
            _mutArrOfSelectedTime = [NSMutableArray new];
            _mutArrOfSelectedTime = [NSMutableArray arrayWithArray:@[@"02", @"02"]];
        } // 闹钟时间
    }
    return _mutArrOfSelectedTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"选中的闹钟--->%ld", self.numOfSelectedClock);
//    NSLog(@"选中闹钟时间--->%@", self.mutArrOfSelectedTime);
//    NSLog(@"重复--->%@", self.mutArrOfWhichDayChoice);
//    NSLog(@"贪睡--->%ld", self.tanShuiShiJian);
    
    self.title = NSLocalizedString(@"设置闹钟", nil);
    [self createSelectedView]; // 创建选择按钮
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfWhichDayChoice forKey:[NSString stringWithFormat:@"Clock%ld", self.numOfSelectedClock]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfSelectedTime forKey:[NSString stringWithFormat:@"MyClockTime%ld", self.numOfSelectedClock]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", self.tanShuiShiJian] forKey:[NSString stringWithFormat:@"MyClockTanShui%ld", self.numOfSelectedClock]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *myTemoMutArr = [NSMutableArray new];
    [myTemoMutArr addObject:self.mutArrOfSelectedTime];
    [myTemoMutArr addObject:self.mutArrOfWhichDayChoice];
    [myTemoMutArr addObject:[NSString stringWithFormat:@"%ld", self.tanShuiShiJian]];
    self.myReturnBlockOfAllInfo(myTemoMutArr);
}

// 创建选择按钮
- (void)createSelectedView {
    
    UILabel *myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 45)];
    myTitleLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    myTitleLabel.backgroundColor = kRandomColor(0.0f);
    myTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    myTitleLabel.text = NSLocalizedString(@"设置闹钟", nil);
    myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myTitleLabel];
    
    
    ClockSelectedView *myView = [ClockSelectedView new];
    myView.selectedNum = 2;
//    myView.huaDongLeDiJiGe = [self.mutArrOfSelectedTime[self.selectedNumTabel] integerValue];
    myView.tempArrOfHuaDongDiJiGe = [NSMutableArray arrayWithArray:self.mutArrOfSelectedTime];
//    NSLog(@"%@", self.mutArrOfSelectedTime);
    
    myView.frame = CGRectMake(0, 0 + 64 + 50, kScreenWidth, 225);
    myView.backgroundColor = kRandomColor(0.0f);
    
    if (kScreenHeight == 480) {
        myView.frame = CGRectMake(0, 0 + 64 + 50, kScreenWidth, 200);
    }
    
    NSMutableArray *myMutArr1 = [NSMutableArray new];
    for (NSInteger i = 0; i < 24 + 2 * 2; i ++) {
        if (i < 2 || i > 25) {
            [myMutArr1 addObject:@""];
        } else {
            [myMutArr1 addObject:[NSString stringWithFormat:@"%02ld", i - 2]];
        }
    }
    
    NSMutableArray *myMutArr2 = [NSMutableArray new];
    for (NSInteger i = 0; i < 60 + 2 * 2; i ++) {
        if (i < 2 || i > 61) {
            [myMutArr2 addObject:@""];
        } else {
            [myMutArr2 addObject:[NSString stringWithFormat:@"%02ld", i - 2]];
        }
    }
    
    myView.myLetfToRightEachNumMutArr = [NSMutableArray arrayWithArray:@[myMutArr1, myMutArr2]];
    
    __block NSInteger _selectedNumTabel;
    myView.myReturnBlockOfSelected = ^(NSInteger num) {
//        NSLog(@"选中%ld", num);
        self.selectedNumTabel = num;
    };
    myView.myReturnBlockOfSelectedOfInfo = ^(NSInteger num) {
//        NSLog(@"选中值:%ld", num);
        if (num <= 1 || num >= [myView.myLetfToRightEachNumMutArr[self.selectedNumTabel] count] - 2) {
            
        } else {
            if (self.selectedNumTabel == 0) {
                self.mutArrOfSelectedTime[self.selectedNumTabel] = myMutArr1[num];
            } else {
                self.mutArrOfSelectedTime[self.selectedNumTabel] = myMutArr2[num];
            }
            
        }
        // NSLog(@"aaa%ld", [myView.myLetfToRightEachNumMutArr[self.selectedNumTabel] count] - 2);
        
//        NSLog(@"%@", self.mutArrOfSelectedTime);
    };
    
    [self.view addSubview:myView];
    
    NSArray *testArr = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if (![currentLanguage isEqualToString:@"zh-Hans-US"]||![currentLanguage isEqualToString:@"zh-Hans"]) {
        testArr =  @[@"Sun.", @"Mon.", @"Tue.", @"Wed.", @"Thu.", @"  Fri  ", @"Sat."];
    }
    NSInteger distance = kScreenWidth / 16;
    for (NSInteger i = 0; i < 7; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = kRandomColor(0.0f);
        btn.frame = CGRectMake(distance + distance / 2.0 + distance * 2 * i, myView.frame.size.height + myView.frame.origin.y + 30 + 50 + 10, distance + 5, distance + 5);
        [self.view addSubview:btn];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.tag = 55 + i;
        [btn setTitle:testArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnSelectedClcik:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = btn.frame.size.width / 2.0;
        
        
        if (kScreenHeight == 480) {
            btn.transform = CGAffineTransformMakeTranslation(0, -20);
        }
        
        if ([self.mutArrOfWhichDayChoice[i] isEqualToString:@"0"]) {
            btn.layer.borderWidth = 2;
            [btn setTintColor:kHexRGBAlpha(0xffffff, 0.618)];
            btn.layer.borderColor = [kHexRGBAlpha(0xffffff, 0.618) CGColor];
            btn.selected = NO;
        } else if ([self.mutArrOfWhichDayChoice[i] isEqualToString:@"1"]) {
            btn.layer.borderWidth = 2;
            [btn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
            btn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];
            btn.selected = YES;
        }
    }
    
    // 重复设置
    UILabel *selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, myView.frame.size.height + myView.frame.origin.y + 30 + 5, 120, 30)];
    selectedLabel.text = NSLocalizedString(@"重复设置", nil);
    if (kScreenHeight == 480) {
        selectedLabel.transform = CGAffineTransformMakeTranslation(0, -20);
    }
    selectedLabel.font = [UIFont boldSystemFontOfSize:17];
    selectedLabel.textColor = kHexRGBAlpha(0xffffff, 1.0f);
    selectedLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:selectedLabel];
    
    UILabel *typeSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectedLabel.frame.size.width, myView.frame.size.height + myView.frame.origin.y + 30 + 5, kScreenWidth - selectedLabel.frame.size.width, 30)];
    typeSelectedLabel.tag = 3700 + 1;
    if (kScreenHeight == 480) {
        typeSelectedLabel.transform = CGAffineTransformMakeTranslation(0, -20);
    }
    typeSelectedLabel.adjustsFontSizeToFitWidth = YES;
//    typeSelectedLabel.font = [UIFont boldSystemFontOfSize:17];
    typeSelectedLabel.font = [UIFont boldSystemFontOfSize:15];
    typeSelectedLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    typeSelectedLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:typeSelectedLabel];
    
    
    
    
     NSMutableString *mySleectedStra = [NSMutableString new];
    NSArray *testArraaa = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    for (NSInteger i = 0; i < 7; i ++) {
        if ([self.mutArrOfWhichDayChoice[i] isEqualToString:@"1"]) {
            [mySleectedStra appendString:[testArraaa[i] substringFromIndex:1]];
            [mySleectedStra appendString:@"/"];
        }
    }
    if (mySleectedStra.length == 2) {
        mySleectedStra = [NSMutableString stringWithString:[mySleectedStra substringToIndex:1]];
        [mySleectedStra insertString:@"" atIndex:0];
    } else if (mySleectedStra.length == 14) {
        mySleectedStra = [NSMutableString stringWithString:NSLocalizedString(@"每天", nil)];
    } else {
        if (mySleectedStra.length != 0) {
            mySleectedStra = [NSMutableString stringWithString:[mySleectedStra substringToIndex:mySleectedStra.length - 1]];
            [mySleectedStra insertString:@"" atIndex:0];
        }
    }
        typeSelectedLabel.text = mySleectedStra;
    
    
    if (![currentLanguage isEqualToString:@"zh-Hans-US"]||![currentLanguage isEqualToString:@"zh-Hans"]) {

        if ([mySleectedStra containsString:@"一"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"一" withString:@"Mon." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"二"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"二" withString:@"Tue." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"三"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"三" withString:@"Wed." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"四"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"四" withString:@"Thur." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"五"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"五" withString:@"Fri." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"六"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"六" withString:@"Sat." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"日"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"日" withString:@"Sun." options:NSCaseInsensitiveSearch range:range];
        }
        typeSelectedLabel.text = mySleectedStra;
    }
    

    
    // 贪睡时间
    UILabel *myTanShuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, myView.frame.size.height + myView.frame.origin.y + 30 + 50 + distance + 10 + 20 + 5, kScreenWidth - 20, 30)];
    myTanShuiLabel.backgroundColor = kRandomColor(0.0f);
    myTanShuiLabel.text = NSLocalizedString(@"贪睡时间", nil);
    if (kScreenHeight == 480) {
        myTanShuiLabel.transform = CGAffineTransformMakeTranslation(0, -20);
    }
    myTanShuiLabel.font = [UIFont boldSystemFontOfSize:17];
    myTanShuiLabel.textColor = kHexRGBAlpha(0xffffff, 1.0f);
    myTanShuiLabel.userInteractionEnabled = YES;
    [self.view addSubview:myTanShuiLabel];
    // 贪睡时间显示
    UILabel *myTanShuiInfoNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100, myTanShuiLabel.frame.origin.y, 80, myTanShuiLabel.frame.size.height)];
    myTanShuiInfoNum.backgroundColor = kRandomColor(0.0f);
    myTanShuiInfoNum.tag = 3700 + 9;
//    myTanShuiInfoNum.text = @"0分钟";
    if (kScreenHeight == 480) {
        myTanShuiInfoNum.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    myTanShuiInfoNum.text = [NSString stringWithFormat:@"%ld%@", self.tanShuiShiJian, NSLocalizedString(@"分钟", nil)];
    myTanShuiInfoNum.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    myTanShuiInfoNum.font = [UIFont boldSystemFontOfSize:16];
    myTanShuiInfoNum.userInteractionEnabled = YES;
    [self.view addSubview:myTanShuiInfoNum];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClcik:)];
    [myTanShuiLabel addGestureRecognizer:tapGes];
    UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClcik:)];
    [myTanShuiLabel addGestureRecognizer:tapGes];
    [myTanShuiInfoNum addGestureRecognizer:tapGes1];
}
- (void)tapClcik:(id)sender {
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = kHexRGBAlpha(0x000000, 0.4);
    backView.tag = 3700 + 2;
    [[UIApplication sharedApplication].windows[1] addSubview:backView];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapClcik:)];
    [backView addGestureRecognizer:tapGesA];
    
    UILabel *myTitleLabelOfTanshui = [[UILabel alloc] initWithFrame:CGRectMake(0, 1000, kScreenWidth, 60)];
    myTitleLabelOfTanshui.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);
    myTitleLabelOfTanshui.text = [NSString stringWithFormat:@"     %@", NSLocalizedString(@"贪睡时间", nil)];
    myTitleLabelOfTanshui.font = [UIFont systemFontOfSize:16];
    myTitleLabelOfTanshui.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    myTitleLabelOfTanshui.tag = 3700 + 5;
    [[UIApplication sharedApplication].windows[1] addSubview:myTitleLabelOfTanshui];
    [UIView animateWithDuration:0.25f animations:^{
        myTitleLabelOfTanshui.frame = CGRectMake(0, kScreenHeight / 2.0, kScreenWidth, 60);
    }];
    UIView *labrlOfSperateView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1000, kScreenWidth, 1)];
    labrlOfSperateView1.tag = 3700 + 6;
    labrlOfSperateView1.backgroundColor = kHexRGBAlpha(0xd9d9d9, 1.0f);
    [[UIApplication sharedApplication].windows[1] addSubview:labrlOfSperateView1];
    [UIView animateWithDuration:0.25f animations:^{
        labrlOfSperateView1.frame = CGRectMake(0, kScreenHeight / 2.0 + myTitleLabelOfTanshui.frame.size.height - 1, kScreenWidth, 1);
    }];
    
    ClockSelectedView *myClockSelectedViewA = [[ClockSelectedView alloc] initWithFrame:CGRectMake(0, 1000, kScreenWidth, kScreenHeight / 2.0 - 60 - 60)];
    myClockSelectedViewA.backgroundColor  = kHexRGBAlpha(0xffffff, 1.0f);
    myClockSelectedViewA.tag = 3700 + 3;
    [[UIApplication sharedApplication].windows[1] addSubview:myClockSelectedViewA];
    [UIView animateWithDuration:0.25f animations:^{
        myClockSelectedViewA.frame = CGRectMake(0, kScreenHeight / 2.0 + 60, kScreenWidth, kScreenHeight / 2.0 - 60 - 60);
    }];
    
    myClockSelectedViewA.selectedNum = 1;
    NSMutableArray *myMutArr1 = [NSMutableArray new];
    for (NSInteger i = 0; i < 5 + 2 * 2; i ++) {
        if (i < 2 || i > 6) {
            [myMutArr1 addObject:@""];
        } else {
            if (i == 2) {
                [myMutArr1 addObject:@"0"];
            }
            [myMutArr1 addObject:[NSString stringWithFormat:@"%ld", i + 1]];
        }
    }
    
    myClockSelectedViewA.tempArrOfHuaDongDiJiGe = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%ld", _tanShuiShiJian]]]; // 😜
    myClockSelectedViewA.isSingle = YES;
    
    myClockSelectedViewA.myLetfToRightEachNumMutArr = [NSMutableArray arrayWithArray:@[myMutArr1]];
    

    myClockSelectedViewA.myReturnBlockOfSelected = ^(NSInteger num) {
        NSLog(@"选中%ld", num);
    };
    myClockSelectedViewA.myReturnBlockOfSelectedOfInfo = ^(NSInteger num) {
        NSLog(@"选中值:%ld", num);
        self.tanShuiShiJian = num;
    };
    
    self.tanShuiShiJian = [myMutArr1[self.tanShuiShiJian] integerValue];
    
    UILabel *myFenzhongLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + 40, 1000, 50, 20)];
    myFenzhongLabel.backgroundColor = kRandomColor(0.0f);
    myFenzhongLabel.text = NSLocalizedString(@"分钟", nil);
    myFenzhongLabel.tag = 3700 + 4;
    [[UIApplication sharedApplication].windows[1] addSubview:myFenzhongLabel];
    [UIView animateWithDuration:0.25f animations:^{
        myFenzhongLabel.frame = CGRectMake(kScreenWidth / 2.0 + 40, myClockSelectedViewA.frame.origin.y + myClockSelectedViewA.frame.size.height / 2.0 - 10, 50, 20);
    }];
    
    
    UIView *labrlOfSperateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10000, kScreenWidth, 1)];
    labrlOfSperateView2.tag = 3700 + 7;
    labrlOfSperateView2.backgroundColor = kHexRGBAlpha(0xd9d9d9, 1.0f);
    [[UIApplication sharedApplication].windows[1] addSubview:labrlOfSperateView2];
    [UIView animateWithDuration:0.25f animations:^{
        labrlOfSperateView2.frame = CGRectMake(0, myClockSelectedViewA.frame.size.height + myClockSelectedViewA.frame.origin.y - 1, kScreenWidth, 1);
    }];
    
    UIView *btnViewView = [[UIView alloc] initWithFrame:CGRectMake(0, 1000, kScreenWidth, 60)];
    btnViewView.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);
    btnViewView.tag = 3700 + 8;
    [[UIApplication sharedApplication].windows[1] addSubview:btnViewView];
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.backgroundColor = kRandomColor(0.0f);
    [btnSave setTitleColor:kHexRGBAlpha(0x000000, 1.0f) forState:UIControlStateNormal];
    [btnSave setTitle:@"OK" forState:UIControlStateNormal];
//    [btnSave setBackgroundImage:[UIImage imageNamed:@"ing_rectangle"] forState:UIControlStateNormal];
    btnSave.frame = CGRectMake(0, 0, kScreenWidth / 2.0, 40);
    btnSave.center = CGPointMake(kScreenWidth / 2.0, 30);
    [btnViewView addSubview:btnSave];
    [btnSave addTarget:self action:@selector(btnSaveComfire:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.25f animations:^{
        btnViewView.frame = CGRectMake(0, kScreenHeight - 60, kScreenWidth, 60);
    }];
}
- (void)btnSaveComfire:(id)sender {
    [self dismissTapClcik:nil];
    
    if (self.tanShuiShiJian <= 2) {
        self.tanShuiShiJian = 0;
    } else if (self.tanShuiShiJian >= 8) {
        self.tanShuiShiJian = 7;
    }
    ((UILabel *)([self.view viewWithTag:3700 + 9])).text = [NSString stringWithFormat:@"%ld%@", self.tanShuiShiJian, NSLocalizedString(@"分钟", nil)];
    
}
- (void)dismissTapClcik:(id)sender {
    [UIView animateWithDuration:0.25f animations:^{
        [[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 3].transform = CGAffineTransformMakeTranslation(0, 1000);
        [[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 4].transform = CGAffineTransformMakeTranslation(0, 1000);
        [[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 5].transform = CGAffineTransformMakeTranslation(0, 1000);
        [[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 6].transform = CGAffineTransformMakeTranslation(0, 1000);
        [[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 7].transform = CGAffineTransformMakeTranslation(0, 1000);
        [[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 8].transform = CGAffineTransformMakeTranslation(0, 1000);
    } completion:^(BOOL finished) {
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 2] removeFromSuperview];
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 3] removeFromSuperview];
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 4] removeFromSuperview];
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 5] removeFromSuperview];
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 6] removeFromSuperview];
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 7] removeFromSuperview];
        [[[UIApplication sharedApplication].windows[1] viewWithTag:3700 + 8] removeFromSuperview];
    }];
}
- (void)btnSelectedClcik:(id)sender {
    UIButton *btn = sender;

    if (btn.selected == YES) {
        btn.selected = NO;
        [btn setTintColor:kHexRGBAlpha(0xffffff, 0.618)];
        btn.layer.borderColor = [kHexRGBAlpha(0xffffff, 0.618) CGColor];
        
        
    } else {
        btn.selected = YES;
        [btn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
        btn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];

    }
    
    for (NSInteger i = 0; i < 7; i ++) {
        NSInteger btnState = [[self.view viewWithTag:55 + i] state];
        if (btnState == 0 || btnState == 1) {
            self.mutArrOfWhichDayChoice[i] = @"0";
        } else if (btnState == 4 || btnState == 5) {
            self.mutArrOfWhichDayChoice[i] = @"1";
        }
    }

    
    NSMutableString *mySleectedStra = [NSMutableString new];
    NSArray *testArraaa = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    for (NSInteger i = 0; i < 7; i ++) {
        if ([self.mutArrOfWhichDayChoice[i] isEqualToString:@"1"]) {
            [mySleectedStra appendString:[testArraaa[i] substringFromIndex:1]];
            [mySleectedStra appendString:@"/"];
        }
    }

    if (mySleectedStra.length == 2) {
        mySleectedStra = [NSMutableString stringWithString:[mySleectedStra substringToIndex:1]];
        [mySleectedStra insertString:@"周" atIndex:0];
    } else if (mySleectedStra.length == 14) {
        mySleectedStra = [NSMutableString stringWithString:NSLocalizedString(@"每天", nil)];
    } else {
        if (mySleectedStra.length != 0) {
            mySleectedStra = [NSMutableString stringWithString:[mySleectedStra substringToIndex:mySleectedStra.length - 1]];
            [mySleectedStra insertString:@"周" atIndex:0];
        }
    }
    ((UILabel *)[self.view viewWithTag:3700 + 1]).text = mySleectedStra;

    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if (![currentLanguage isEqualToString:@"zh-Hans-US"]||![currentLanguage isEqualToString:@"zh-Hans"]) {
        
        if ([mySleectedStra containsString:@"一"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"一" withString:@"Mon." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"二"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"二" withString:@"Tue." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"三"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"三" withString:@"Wed." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"四"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"四" withString:@"Thur." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"五"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"五" withString:@"Fri." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"六"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"六" withString:@"Sat." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"日"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"日" withString:@"Sun." options:NSCaseInsensitiveSearch range:range];
        }
        if (mySleectedStra.length != 0) {
            if ([mySleectedStra isEqualToString:NSLocalizedString(@"每天", nil)]) {
                ((UILabel *)[self.view viewWithTag:3700 + 1]).text = mySleectedStra;
            } else {
                ((UILabel *)[self.view viewWithTag:3700 + 1]).text = [mySleectedStra substringFromIndex:1];
            }
        } else {
           ((UILabel *)[self.view viewWithTag:3700 + 1]).text = mySleectedStra;
        }
        
    }
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
