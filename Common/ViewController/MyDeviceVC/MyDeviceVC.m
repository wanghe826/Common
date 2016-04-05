//
//  MyDeviceVC.m
//  Common
//
//  Created by HMM－MACmini on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "MyDeviceVC.h"
#import "DevicePaireingVC.h"
#import "NewDevicePairVC.h"

@interface MyDeviceVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView; // 自定义手写 UITableView
@property (nonatomic, strong) NSMutableArray *mutArrOfData; // 数据源

@property (nonatomic, strong) UIView *headerViewOfSectionOne; // 头视图
@property (nonatomic, strong) UIImageView *deviceImageView; // 设备头像
@property (nonnull, strong) UILabel *labelTitleOfSectionOne; // 头标题

@property (nonatomic, strong) UISwitch *mySwitch;

@property (nonatomic, strong) NSArray *arrOfDeviceImage; // 设备图片
@end

@implementation MyDeviceVC

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.frame = self.view.bounds;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.estimatedRowHeight = 60;
        _myTableView.sectionFooterHeight = 0.5f;
        _myTableView.sectionHeaderHeight = 0.5f;
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    return _myTableView;
} // 懒加载初始化 UITableView

- (NSMutableArray *)mutArrOfData {
    if (!_mutArrOfData) {
        _mutArrOfData = [NSMutableArray new];
        _mutArrOfData = [NSMutableArray arrayWithArray:@[@{@"icon_lost.png、icon_lost.png、":NSLocalizedString(@"智能防丢                 ",nil)},@{@"icon_search、icon_search、": NSLocalizedString(@"搜索设备                 ",nil)}]];
    }
    return _mutArrOfData;
} // 懒加载初始化 mutArrOfData
- (NSArray *)arrOfDeviceImage {
    if (!_arrOfDeviceImage) {
        _arrOfDeviceImage = @[@"c002a", @"c002d" ,@"c003", @"c005a", @"c006", @"c007a", @"c007b"];
    }
    return _arrOfDeviceImage;
}

- (UISwitch *)mySwitch {
    if (!_mySwitch) {
        
    }
    return _mySwitch;
} //懒加载初始化 mySwitch

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = NSLocalizedString(@"我的设备",nil);
    [self creatMyTableView]; // 创建 myTableView
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"WhichWatch"]) {
        
    } else {
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    [self.navigationController.navigationBar setHidden:NO];
    
    [self refreshConnStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshConnStatus) name:RefreshFirmwareBatteryAndVersion object:nil];
    
    
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"收到蓝牙断开的通知！！！");
        
        // [weakSelf.babyBluetooth cancelAllPeripheralsConnection];
        [ApplicationDelegate resetBLEStatus];
        [ApplicationDelegate playCustomizedSound];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
        
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:PreConnectedDeviceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }]; // 断开连接的通知
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshFirmwareBatteryAndVersion object:nil];
}

- (void)refreshConnStatus {
    if(ApplicationDelegate.hasConnected) {
        _deviceImageView.image = [UIImage imageNamed:self.arrOfDeviceImage[3]];
        _labelTitleOfSectionOne.text = @"智芯手表";
        
        self.mutArrOfData = [NSMutableArray arrayWithArray:@[@{@"icon_lost.png、icon_lost.png、":NSLocalizedString(@"智能防丢                 ",nil)},@{@"icon_dismatch、icon_dismatch、":NSLocalizedString(@"解除绑定                 ",nil)}]];
        [self.myTableView reloadData];
    } else {
        _deviceImageView.image = [UIImage imageNamed:@"icon_logo"];
        
        self.mutArrOfData = [NSMutableArray arrayWithArray:@[@{@"icon_lost.png、icon_lost.png、":NSLocalizedString(@"智能防丢                 ",nil)},@{@"icon_search、icon_search、": NSLocalizedString(@"搜索设备                 ",nil)}]];
        [self.myTableView reloadData];
    }
} // 蓝牙状态刷新

- (void)creatMyTableView {
    [self.view addSubview:self.myTableView];
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    _myTableView.separatorInset = UIEdgeInsetsMake(20, 30, 20, 30);
    UIEdgeInsets padding = UIEdgeInsetsMake(-15, 0, 0, 0);
    
#if 0
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top); // with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
#else
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
#endif
    
} // 创建 myTableView

#pragma mark - 事件处理
- (void)mySwitchChange:(UISwitch *)sender {
    if(!ApplicationDelegate.hasConnected) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请连接手表",nil)];
        sender.on = !sender.on;
        return ;
    }
  
    [WriteData2BleUtil forbidLost:ApplicationDelegate.currentPeripheral withStatus:sender.on];
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:[NSString stringWithFormat:@"myDeviceSave%ld",(long)sender.tag]];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
} // row
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutArrOfData.count;
} // section

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier]; // 用TableSampleIdentifier表示需要重用的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    } // 如果如果没有多余单元，则需要创建新的单元
    
    cell.imageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringToIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@"、"].location]];
    
    cell.textLabel.text = [[self.mutArrOfData[indexPath.section]objectForKey:[self.mutArrOfData[indexPath.section]allKeys][0]]substringToIndex:21];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = kHexRGBAlpha(0xffffff, 1.0f);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view1 = [[UIView alloc]initWithFrame:cell.frame];
    view1.backgroundColor = HexRGBAlpha(0x040b1d, 1);
    cell.backgroundView = view1;
    
    UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
    selectView.backgroundColor = HexRGBAlpha(0x060e24, 1);
    cell.selectedBackgroundView = selectView;
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        
        if (self.mySwitch) {
            
        } else {
            self.mySwitch = [UISwitch new];
        }
        _mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _mySwitch.tintColor = kRandomColor(0.0f);
        _mySwitch.alpha = 1;
        _mySwitch.tag = 8888;
        _mySwitch.frame = CGRectMake(kScreenWidth - 65, 5, 80, 35);
        [_mySwitch addTarget:self action:@selector(mySwitchChange:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:_mySwitch];
        [_mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(5, kScreenWidth - 65, 0, 15));
        }];
        
        BOOL state = [[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"myDeviceSave%ld",(long)[_mySwitch tag]]];
        _mySwitch.on = state;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"智能防丢", nil);
    }
    
    return cell;
} // cell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
} // row height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 155;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return nil;
    }
    self.headerViewOfSectionOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,180)];
    
    self.deviceImageView = [[UIImageView alloc] init];
    [self refreshConnStatus];
    _deviceImageView.frame = CGRectMake((kScreenWidth - 74)/2,35,74, 74);
    [_headerViewOfSectionOne addSubview:_deviceImageView];

    self.labelTitleOfSectionOne = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_deviceImageView.frame) - 5, kScreenWidth, 50)];
    _labelTitleOfSectionOne.text = NSLocalizedString(@"打开设备蓝牙并靠近手机",nil);
    _labelTitleOfSectionOne.textColor = HexRGBAlpha(0xFFFFFF, 1.0f);
    _labelTitleOfSectionOne.adjustsFontSizeToFitWidth = YES;
    _labelTitleOfSectionOne.numberOfLines = 2;
    _labelTitleOfSectionOne.font = [UIFont systemFontOfSize:16];
    _labelTitleOfSectionOne.textAlignment = NSTextAlignmentCenter;
    [_headerViewOfSectionOne addSubview:_labelTitleOfSectionOne];
    
    return self.headerViewOfSectionOne;
} // header view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    if(ApplicationDelegate.hasConnected) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
    } else {
        if (indexPath.section == 1) {
            NewDevicePairVC *deviceVc = [[NewDevicePairVC alloc] init];
            [self.navigationController pushViewController:deviceVc animated:YES];
        }
    }
} // selected cell


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
