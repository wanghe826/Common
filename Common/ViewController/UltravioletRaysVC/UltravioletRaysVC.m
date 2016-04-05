//
//  UltravioletRaysVC.m
//  Common
//
//  Created by HuMingmin on 16/3/1.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "UltravioletRaysVC.h"

#import "MutilColorCirclr.h"                // 渐变色的圆环
#import "UltravioletDetailCell.h"           // 下方详情显示自定义 cell

@interface UltravioletRaysVC () <UITableViewDataSource, UITableViewDelegate>
{
    UILabel* _myNumLabel;
    UIImageView* _myBlackView;
}

@property (nonatomic, strong) UITableView *myTableView;                     // 显示下方详情的 UITableView
@property (nonatomic, strong) MutilColorCirclr *myMutilColorCirclrView;     // 创建渐变色的圆环

@end

@implementation UltravioletRaysVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialNavigationbar]; // 重写并初始化 Nav
//    [self createLikeNav]; // 创建类似NavView
    [self createMutilColorCirclrView]; // 创建渐变色的圆环
    [self createDetailTabelView]; // 创建显示下方详情的 UITableView
    
    [self createShareBtn];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(ApplicationDelegate.isC007){
        
    }
    [WriteData2BleUtil requestUVData:ApplicationDelegate.currentPeripheral];

    

}

- (void) babyDelegate
{
    __weak typeof(_myNumLabel) weakLabel = _myNumLabel;
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        Byte* recBytes = (Byte*)[characteristic.value bytes];
        if(characteristic.value.length>5 && recBytes[0]==0x24 && recBytes[1]==12 && recBytes[2]==0x02 && recBytes[3]==0x1a && recBytes[4]==0x02)
        {
            
            NSNumber* hour = [NSNumber numberWithInt:recBytes[5]];
            NSNumber* min = [NSNumber numberWithInt:recBytes[6]];
            NSNumber* second = [NSNumber numberWithInt:recBytes[7]];
            
            int i = (int)recBytes[8];
            int j = (int)recBytes[9];
            int vis1 = (j<<8) + i;
            NSNumber* vis = [NSNumber numberWithInt:vis1];
            
            i = (int)recBytes[10];
            j = (int)recBytes[11];
            int ir1 = (j<<8) + i;
            NSNumber* ir = [NSNumber numberWithInt:ir1];
            
            i = (int)recBytes[12];
            j = (int)recBytes[13];
            int uv1 = (j<<8) + i;
            int uv = uv1/100;
            weakLabel.text = [NSString stringWithFormat:@"%d", uv];
            
            _myBlackView.transform = CGAffineTransformIdentity;
            
            _myBlackView.transform = CGAffineTransformMakeRotation((uv-1) * 2 * M_PI/12 + M_PI/12);
        }
    }];
}

//- (CGAffineTransform) CGAffineTransformRotateAroundPoint:(float)centerX
//                                             withCenterY:(float)centerY
//                                                   withX:(float)x
//                                                   withY:(float)y
//                                               withAngle:(float)angle
//{
//    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
//    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
//    
//    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
//    trans = CGAffineTransformRotate(trans,angle);
//    trans = CGAffineTransformTranslate(trans,-x, -y);
//    return trans;
//}

- (void) createShareBtn
{
    UIButton* shareButton = [self.navigationController.navigationBar viewWithTag:1090];
    if(shareButton) {
        shareButton.hidden = NO;
    }
    else {
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
- (void)initialNavigationbar {
    self.title = NSLocalizedString(@"UV", nil);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
}
- (void) settingAction {
}

- (void) shareAction {
}

/**
 *  创建类似NavView
 */
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
    myTitleLabel.text = @"紫外线";
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

/**
 *  创建渐变色的圆环
 */
- (void)createMutilColorCirclrView {
    self.myMutilColorCirclrView = [[MutilColorCirclr alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    _myMutilColorCirclrView.center = CGPointMake(self.view.center.x, self.view.center.y - 70);
    [self.view addSubview:_myMutilColorCirclrView];
    _myMutilColorCirclrView.alpha = 0.618;
    _myMutilColorCirclrView.backgroundColor = HexRGBAlpha(0xffffff, 0.0f);
    
    
    // 创建白色盘
    UIView *myWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    myWhiteView.backgroundColor = kHexRGBAlpha(0xffffff, 1.0);
    myWhiteView.center = _myMutilColorCirclrView.center;
    myWhiteView.clipsToBounds = YES;
    myWhiteView.layer.cornerRadius = myWhiteView.frame.size.width / 2.0;
    [self.view addSubview:myWhiteView];
    
    UIView *mySubWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    mySubWhiteView.backgroundColor = HexRGBAlpha(0xeaeaea, 1.0f);
    mySubWhiteView.center = _myMutilColorCirclrView.center;
    mySubWhiteView.clipsToBounds = YES;
    mySubWhiteView.layer.cornerRadius = mySubWhiteView.frame.size.width / 2.0;
    [self.view addSubview:mySubWhiteView];
    
    _myNumLabel = [[UILabel alloc] initWithFrame:mySubWhiteView.bounds];
    _myNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(12) + 1];
    _myNumLabel.textColor = HexRGBAlpha(0xe9ca3a, 1.0f);
    _myNumLabel.font = [UIFont boldSystemFontOfSize:78];
    _myNumLabel.textAlignment = NSTextAlignmentCenter;
    [mySubWhiteView addSubview:_myNumLabel];
    
    _myBlackView = [[UIImageView alloc] initWithFrame:myWhiteView.frame];
    _myBlackView.image = [UIImage imageNamed:@"icon_spot"];
//    _myBlackView.center = self.view.center;
    [self.view addSubview:_myBlackView];
//    _myBlackView.backgroundColor = [UIColor blackColor];
    
    
    // 数字
    UIView *bifCicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    bifCicleView.backgroundColor = HexRGBAlpha(0xffffff, 0.0f);
    bifCicleView.center = myWhiteView.center;
    [self.view addSubview:bifCicleView];
    
    CGFloat r = (250 / 2.0) - 10;
    for (NSInteger i = 0; i < 12; i ++) {
        CGPoint centerFloat = CGPointMake(r + r * cos(30 * i * M_PI / 180), 0 + r * sin(30 * i * M_PI / 180));
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(centerFloat.x, centerFloat.y, 20, 20)];
        label.backgroundColor = kRandomColor(0.0f);
        label.text = [NSString stringWithFormat:@"%d", (i + 1 + 3) % 13];
        if ([label.text isEqualToString:@"0"] || [label.text isEqualToString:@"1"] || [label.text isEqualToString:@"2"]) {
            label.text = [NSString stringWithFormat:@"%d", (i + 1 + 3) % 13 + 1];
        }
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kHexRGBAlpha(0xe9ca3a, 0.9);
        label.transform = CGAffineTransformMakeTranslation(0, 112);
        [bifCicleView addSubview:label];
    }
    
    if (kScreenHeight == 480) {
        _myMutilColorCirclrView.transform = CGAffineTransformMakeTranslation(0, 25);
        myWhiteView.transform = CGAffineTransformMakeTranslation(0, 25);
        mySubWhiteView.transform = CGAffineTransformMakeTranslation(0, 25);
        bifCicleView.transform = CGAffineTransformMakeTranslation(0, 25);
    } else if (kScreenHeight == 568) {
        
    } else if (kScreenHeight == 667) {
        _myMutilColorCirclrView.transform = CGAffineTransformMakeTranslation(0, -40);
        myWhiteView.transform = CGAffineTransformMakeTranslation(0, -40);
        mySubWhiteView.transform = CGAffineTransformMakeTranslation(0, -40);
        bifCicleView.transform = CGAffineTransformMakeTranslation(0, -40);
    } else {
        _myMutilColorCirclrView.transform = CGAffineTransformMakeTranslation(0, -40);
        myWhiteView.transform = CGAffineTransformMakeTranslation(0, -40);
        mySubWhiteView.transform = CGAffineTransformMakeTranslation(0, -40);
        bifCicleView.transform = CGAffineTransformMakeTranslation(0, -40);
    }

    
    [self displayInfoViews]; // 显示信息判断 Views
}
- (void)displayInfoViews {
    NSArray *arrOfImageNamesNol = @[@"icon_glass_avr", @"icon_hat_avr", @"icon_shirt_avr", @"icon_umbrella_avr"];
    NSArray *arrOfImageNamesSel = @[@"icon_glass_sel", @"icon_hat_sel", @"icon_shirt_sel", @"icon_umbrella_sel"];
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.center.x - 60 + 30 * i, _myMutilColorCirclrView.frame.size.height + _myMutilColorCirclrView.frame.origin.y, 30, 30);
        btn.backgroundColor = kRandomColor(0.0);
        [btn setImage:[UIImage imageNamed:arrOfImageNamesNol[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arrOfImageNamesSel[i]] forState:UIControlStateSelected];
        [self.view addSubview:btn];
        
        if (i % 2 == 0) {
            btn.selected = YES;
        }
        
        if (kScreenHeight == 480) {
            btn.transform = CGAffineTransformMakeTranslation(0, -30);
        }
    }
    
    UILabel *infoDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _myMutilColorCirclrView.frame.size.height + _myMutilColorCirclrView.frame.origin.y + 40 - 15, kScreenWidth, 30)];
    infoDetailLabel.text = @"Vibration alerts will be issued when UV beyond 5";
    infoDetailLabel.textAlignment = NSTextAlignmentCenter;
    infoDetailLabel.textColor = HexRGBAlpha(0xd1d1d1, 1.0);
    infoDetailLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.view addSubview:infoDetailLabel];
    
    if (kScreenHeight == 480) {
        infoDetailLabel.transform = CGAffineTransformMakeTranslation(0, -30);
    }
    
} // // 显示信息判断 Views

/**
 *  创建显示下方详情的 UITableView
 */
- (void)createDetailTabelView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight * (3.0 / 4.0), kScreenWidth, kScreenHeight * (1.0 / 4.0)) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.myTableView];
}

#pragma mark - 
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
} // cell Num
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UltravioletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UltravioletDetailCell"];
    if (!cell) {
        cell = [[UltravioletDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UltravioletDetailCell"];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / 3.0;
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
