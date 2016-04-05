//
//  ViewController.m
//  Common
//
//  Created by QFITS－iOS on 15/12/22.
//  Copyright © 2015年 Smartmovt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UILabel *_myStatusLabel;            // 连接状态
    UIImageView *_myImageViewOfLogo;    // logo
}

@property (nonatomic, strong) UICollectionView *myCollectionView;       // myCollectionView
@property (nonatomic, strong) NSMutableArray *mutArrOfTitleAndImage;    // 界面功能模块名称以及图片资源
@property (nonatomic, strong) NSMutableArray *mutArrOfVC;               // 界面数组
@property (nonatomic, assign) NSInteger whitchHomePageNum;              // 到底是哪一个首页样式

@end

@implementation ViewController

- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 14;
        flowLayout.minimumInteritemSpacing = 12;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        if (self.whitchHomePageNum == 2 || self.whitchHomePageNum == 6) {
            flowLayout.headerReferenceSize = CGSizeMake(20, 80);
            flowLayout.footerReferenceSize = CGSizeMake(20, 100);
        } else {
            flowLayout.headerReferenceSize = CGSizeMake(20, 55);
            flowLayout.footerReferenceSize = CGSizeMake(20, 47);
        }
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15 * 2, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
        _myCollectionView.bounces = NO;
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _myCollectionView;
} // 懒加载初始化 myCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = kHexRGBAlpha(0x030918, 1.0);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (ApplicationDelegate.isBLESpecial) {
        [ApplicationDelegate initialBLEDevice];
        [ApplicationDelegate startReconnTimer];
        ApplicationDelegate.isBLESpecial = NO;
    }
    
    [self.navigationController.navigationBar setHidden:YES];
    [self creatCollectionView]; // 创建 myCollectionView
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 改变状态栏颜色
    
    [ApplicationDelegate initialBLEDevice]; // 超级重要的一个步骤，不可以忽略，要不然会死的很惨。。。
    [self refreshConnStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshConnStatus) name:RefreshFirmwareBatteryAndVersion object:nil];
} // 视图将出现

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshFirmwareBatteryAndVersion object:nil];
} // 视图将消失

- (void)refreshConnStatus {
    if(ApplicationDelegate.hasConnected) {
        _myStatusLabel.text = NSLocalizedString(@"已连接", nil);
    } else {
        _myStatusLabel.text = NSLocalizedString(@"未连接", nil);
    }
} // 蓝牙状态刷新

- (void)requestHomePageData {
    if (self.whitchHomePageNum == 1) {
        self.mutArrOfTitleAndImage =  [NSMutableArray arrayWithArray:@[@{@"icon_persona":NSLocalizedString(@"个人", nil)},
                                                                       @{@"icon_about":NSLocalizedString(@"关于", nil)},
                                                                       @{@"icon_equipment":NSLocalizedString(@"我的设备", nil)},
                                                                       @{@"icon_remind":NSLocalizedString(@"智能提醒", nil)},
                                                                       @{@"icon_alarm-clock":NSLocalizedString(@"智能闹钟", nil)},
                                                                       @{@"icon_school":NSLocalizedString(@"智能校时", nil)},
                                                                       @{@"icon_motion":NSLocalizedString(@"运动", nil)},
                                                                       @{@"icon_sleep":NSLocalizedString(@"睡眠", nil)},
                                                                       @{@"icon_photograph":NSLocalizedString(@"拍照", nil)},
                                                                       @{@"icon_mountain":NSLocalizedString(@"登山/潜水", nil)},
                                                                       @{@"icon_heart-rate":NSLocalizedString(@"心率", nil)},
                                                                       @{@"icon_health-reminder":NSLocalizedString(@"健康提醒", nil)}]];
        self.mutArrOfVC = [NSMutableArray arrayWithArray:@[[PersonalInformationVC new],
                                                           [SystemSettingViewController new],
                                                           [MyDeviceVC new],
                                                           [SmartRemindingViewController new],
                                                           [MyNewClockVC new],
                                                           [TimingVC new],
                                                           [AnotherSportVC new],
                                                           [SleepVC new],
                                                           [HMMTakePicVC new],
                                                           [MountainAndDivingVC new],
                                                           [HeartBeatsVC new],
                                                           [HealthVC new]]];

    } else if (self.whitchHomePageNum == 2) {
        self.mutArrOfTitleAndImage =  [NSMutableArray arrayWithArray:@[@{@"icon_persona":NSLocalizedString(@"个人", nil)},
                                                                       @{@"icon_about":NSLocalizedString(@"关于", nil)},
                                                                       @{@"icon_motion":NSLocalizedString(@"运动", nil)},
                                                                       @{@"icon_sleep":NSLocalizedString(@"睡眠", nil)},
                                                                       @{@"icon_school":NSLocalizedString(@"智能校时", nil)},
                                                                       @{@"icon_equipment":NSLocalizedString(@"我的设备", nil)},
                                                                       @{@"icon_photograph":NSLocalizedString(@"拍照", nil)},
                                                                       @{@"icon_uv":NSLocalizedString(@"紫外线", nil)}]];
        self.mutArrOfVC = [NSMutableArray arrayWithArray:@[[PersonalInformationVC new],
                                                           [SystemSettingViewController new],
                                                           [AnotherSportVC new],
                                                           [SleepVC new],
                                                           [TimingVC new],
                                                           [MyDeviceVC new],
                                                           [HMMTakePicVC new],
                                                           [UltravioletRaysVC new]]];
    } else if (self.whitchHomePageNum == 3) {
        self.mutArrOfTitleAndImage =  [NSMutableArray arrayWithArray:@[@{@"icon_persona":NSLocalizedString(@"个人", nil)},
                                                                       @{@"icon_about":NSLocalizedString(@"关于", nil)},
                                                                       @{@"icon_school":NSLocalizedString(@"智能校时", nil)},
                                                                       @{@"icon_equipment":NSLocalizedString(@"我的设备", nil)},
                                                                       @{@"icon_motion":NSLocalizedString(@"运动", nil)},
                                                                       @{@"icon_alarm-clock":NSLocalizedString(@"智能闹钟", nil)},
                                                                       @{@"icon_remind":NSLocalizedString(@"智能提醒", nil)},
                                                                       @{@"icon_sleep":NSLocalizedString(@"睡眠", nil)},
                                                                       @{@"icon_health-reminder":NSLocalizedString(@"健康提醒", nil)},
                                                                       @{@"icon_photograph":NSLocalizedString(@"拍照", nil)}]];
        self.mutArrOfVC = [NSMutableArray arrayWithArray:@[[PersonalInformationVC new],
                                                           [SystemSettingViewController new],
                                                           [TimingVC new],
                                                           [MyDeviceVC new],
                                                           [AnotherSportVC new],
                                                           [MyNewClockVC new],
                                                           [SmartRemindingViewController new],
                                                           [SleepVC new],
                                                           [HealthVC new],
                                                           [HMMTakePicVC new],]];

    } else if (self.whitchHomePageNum == 4) {
        self.mutArrOfTitleAndImage =  [NSMutableArray arrayWithArray:@[@{@"icon_persona":NSLocalizedString(@"个人", nil)},
                                                                       @{@"icon_about":NSLocalizedString(@"关于", nil)},
                                                                       @{@"icon_remind":NSLocalizedString(@"智能提醒", nil)},
                                                                       @{@"icon_alarm-clock":NSLocalizedString(@"智能闹钟", nil)},
                                                                       @{@"icon_school":NSLocalizedString(@"智能校时", nil)},
                                                                       @{@"icon_motion":NSLocalizedString(@"运动", nil)},
                                                                       @{@"icon_equipment":NSLocalizedString(@"我的设备", nil)},
                                                                       @{@"icon_photograph":NSLocalizedString(@"健康提醒", nil)},
                                                                       @{@"icon_sleep":NSLocalizedString(@"睡眠", nil)},
                                                                       @{@"icon_mountain":NSLocalizedString(@"紫外线", nil)},
                                                                       @{@"icon_health-reminder":NSLocalizedString(@"拍照", nil)}]];
        self.mutArrOfVC = [NSMutableArray arrayWithArray:@[[PersonalInformationVC new],
                                                           [SystemSettingViewController new],
                                                           [SmartRemindingViewController new],
                                                           [MyNewClockVC new],
                                                           [TimingVC new],
                                                           [AnotherSportVC new],
                                                           [MyDeviceVC new],
                                                           [HMMTakePicVC new],
                                                           [SleepVC new],
                                                           [UltravioletRaysVC new],
                                                           [HMMTakePicVC new]]];
    } else if (self.whitchHomePageNum == 5) {
        self.mutArrOfTitleAndImage =  [NSMutableArray arrayWithArray:@[@{@"icon_persona":NSLocalizedString(@"个人", nil)},
                                                                       @{@"icon_about":NSLocalizedString(@"关于", nil)},
                                                                       @{@"icon_remind":NSLocalizedString(@"智能提醒", nil)},
                                                                       @{@"icon_alarm-clock":NSLocalizedString(@"智能闹钟", nil)},
                                                                       @{@"icon_school":NSLocalizedString(@"智能校时", nil)},
                                                                       @{@"icon_motion":NSLocalizedString(@"运动", nil)},
                                                                       @{@"icon_equipment":NSLocalizedString(@"我的设备", nil)},
                                                                       @{@"icon_photograph":NSLocalizedString(@"拍照", nil)},
                                                                       @{@"icon_sleep":NSLocalizedString(@"睡眠", nil)},
                                                                       @{@"icon_mountain":NSLocalizedString(@"登山/潜水", nil)},
                                                                       @{@"icon_health-reminder":NSLocalizedString(@"健康提醒", nil)}]];
        self.mutArrOfVC = [NSMutableArray arrayWithArray:@[[PersonalInformationVC new],
                                                           [SystemSettingViewController new],
                                                           [SmartRemindingViewController new],
                                                           [MyNewClockVC new],
                                                           [TimingVC new],
                                                           [AnotherSportVC new],
                                                           [MyDeviceVC new],
                                                           [HMMTakePicVC new],
                                                           [SleepVC new],
                                                           [MountainAndDivingVC new],
                                                           [HealthVC new]]];
    } else if (self.whitchHomePageNum == 6) {
        self.mutArrOfTitleAndImage =  [NSMutableArray arrayWithArray:@[@{@"icon_persona":NSLocalizedString(@"个人", nil)},
                                                                       @{@"icon_about":NSLocalizedString(@"关于", nil)},
                                                                       @{@"icon_equipment":NSLocalizedString(@"我的设备", nil)},
                                                                       @{@"icon_remind":NSLocalizedString(@"智能提醒", nil)},
                                                                       @{@"icon_alarm-clock":NSLocalizedString(@"智能闹钟", nil)},
                                                                       @{@"icon_school":NSLocalizedString(@"智能校时", nil)},
                                                                       @{@"icon_motion":NSLocalizedString(@"运动", nil)},
                                                                       @{@"icon_photograph":NSLocalizedString(@"拍照", nil)}]];
        self.mutArrOfVC = [NSMutableArray arrayWithArray:@[[PersonalInformationVC new],
                                                           [SystemSettingViewController new],
                                                           [MyDeviceVC new],
                                                           [SmartRemindingViewController new],
                                                           [MyNewClockVC new],
                                                           [TimingVC new],
                                                           [AnotherSportVC new],
                                                           [HMMTakePicVC new]]];
    }
} // 界面类型

- (void)creatCollectionView {
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"WhichWatch"]) {
        self.whitchHomePageNum = 1;
    } else {
        self.whitchHomePageNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"WhichWatch"];
    }
    
    [self requestHomePageData];
    
    if (_myCollectionView) {
        [_myCollectionView removeFromSuperview];
        _myCollectionView = nil;
        
        [self.view addSubview:self.myCollectionView];
        [self.myCollectionView registerClass:[HomeSelectedCell class] forCellWithReuseIdentifier:@"HomeSelectedCell"];
        self.myCollectionView.backgroundColor = [UIColor clearColor];
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 15, 0, 15);
        [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(padding);
        }];
        _myCollectionView.transform = CGAffineTransformMakeTranslation(0, 20);
    } else {
        [self.view addSubview:self.myCollectionView];
        [self.myCollectionView registerClass:[HomeSelectedCell class] forCellWithReuseIdentifier:@"HomeSelectedCell"];
        self.myCollectionView.backgroundColor = [UIColor clearColor];
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 15, 0, 15);
        
       if (kScreenHeight == 480) {
            _myCollectionView.transform = CGAffineTransformMakeTranslation(0, 20);
        } else if (kScreenHeight == 568) {
            
        } else if (kScreenHeight == 736) {
            
        }
        
        [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(padding);
        }];
        
        _myStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 30, kScreenWidth, 20)];
        _myStatusLabel.text = [NSString stringWithFormat:@"未连接-->您当前是首界面样式第%ld个", _whitchHomePageNum];
        _myStatusLabel.numberOfLines = 2;
        _myStatusLabel.textColor = kHexRGBAlpha(0xc0b2b2, 1.0f);
        _myStatusLabel.textAlignment = NSTextAlignmentCenter;
        _myStatusLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.view addSubview:_myStatusLabel];
        
        _myImageViewOfLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 44)];
        _myImageViewOfLogo.image = [UIImage imageNamed:@"ing_logo"];
        _myImageViewOfLogo.contentMode = UIViewContentModeCenter;
        [self.view addSubview:_myImageViewOfLogo];
    }
} // 创建 myCollectionView

#pragma mark
#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutArrOfTitleAndImage.count;
} // 行数

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeSelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSelectedCell" forIndexPath:indexPath];
    cell.backgroundColor = kHexRGBAlpha(0x2d66a1, 0.0f);
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 20;
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = [kHexRGBAlpha(0x495368, 1.0) CGColor];
    cell.strOfTitle = [self.mutArrOfTitleAndImage[indexPath.row] objectForKey:[self.mutArrOfTitleAndImage[indexPath.row] allKeys][0]];
    cell.strOfImageName = [self.mutArrOfTitleAndImage[indexPath.row] allKeys][0];
    
    if (self.whitchHomePageNum == 1) {
        if (indexPath.row == 6 || indexPath.row == 9) {
            cell.isSpecial = YES;
        } else {
            cell.isSpecial = NO;
        }
    } else if (self.whitchHomePageNum == 2 || self.whitchHomePageNum == 6) {
        if (indexPath.row == 2 || indexPath.row == 5) {
            cell.isSpecial = YES;
        } else {
            cell.isSpecial = NO;
        }
    } else if (self.whitchHomePageNum == 3) {
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7) {
            cell.isSpecial = YES;
        } else {
            cell.isSpecial = NO;
        }
    } else {
        if (indexPath.row == 5 || indexPath.row == 8) {
            cell.isSpecial = YES;
        } else {
            cell.isSpecial = NO;
        }
    }
    
    return cell;
} // cell

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize mySizeSmall = CGSizeMake((kScreenWidth - 14 * 2 - 14 * 2) / 3.0, (kScreenHeight - 47 - 64 - 15 * 4) / 5.0);
    CGSize mySizeMid = CGSizeMake((kScreenWidth - 14 * 2 - 14) / 2.0, (kScreenHeight - 47 - 64 - 15 * 4) / 5.0);
    CGSize mySizeBig = CGSizeMake((kScreenWidth - 14 * 2 - 14 * 2) / 3.0 * 2 + 14, (kScreenHeight - 47 - 64 - 15 * 4) / 5.0);
    
    if (self.whitchHomePageNum == 1) {
        // 首页1
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 8) {
            return mySizeSmall;
        } else if (indexPath.row == 6 || indexPath.row == 9) {
            return mySizeBig;
        } else {
            return mySizeMid;
        }
    } else if (self.whitchHomePageNum == 2 || self.whitchHomePageNum == 6) {
        // 首页2
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
            return mySizeSmall;
        } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5) {
            return mySizeBig;
        } else {
            return mySizeMid;
        }
    } else if (self.whitchHomePageNum == 3) {
        // 首页3
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 6) {
            return mySizeSmall;
        } else if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7) {
            return mySizeBig;
        } else {
            return mySizeMid;
        }
    } else {
        // 首页4、5
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7) {
            return mySizeSmall;
        } else if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 8) {
            return mySizeBig;
        } else {
            return mySizeMid;
        }
    }
} // cell 的 CGSize

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:self.mutArrOfVC[indexPath.row] animated:YES];
} // 选中 cell

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
