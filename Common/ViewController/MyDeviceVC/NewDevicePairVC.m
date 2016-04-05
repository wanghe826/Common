//
//  NewDevicePairVC.m
//  Common
//
//  Created by HuMingmin on 16/3/23.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

/***
 1. 连接页面的问题: 捕捉不到是否配对！！！！！！
 2. 有时候未发起配对命令也会受到该条命令！！！！！！
 ***/

#import "NewDevicePairVC.h"
#import "MJRefresh.h"

@interface NewDevicePairVC () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_array;
    NSMutableArray *_rssiArray;
    UITableView *_tableView;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfStatus;
@property (weak, nonatomic) IBOutlet UIImageView *toLeftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *toRightImgView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation NewDevicePairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设备配对", nil) ;
    [self initTableView];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(beginSearchWatch)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGes];
    
    [ApplicationDelegate stopReconnTimer];
    [self beginSearchWatch];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    ApplicationDelegate.isBLESpecial = YES;
}

- (void)beginSearchWatch {
    [self searchingWatchUI];
    [_baby cancelAllPeripheralsConnection];
    _baby.scanForPeripherals().begin();
}

- (void)loadNewData {
    [_baby cancelAllPeripheralsConnection];
    [_array removeAllObjects];
    [_rssiArray removeAllObjects];
    [self beginSearchWatch];
}

- (void)initTableView {
    _array = [NSMutableArray new];
    _rssiArray = [NSMutableArray new];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:NSLocalizedString(@"重新搜索手表",nil) forState:MJRefreshStateRefreshing];
    [header setTintColor:[UIColor whiteColor]];
    [header setTitle:NSLocalizedString(@"松开立即重新搜索所有设备",nil) forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _tableView.mj_header = header;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    _tableView.separatorColor = HexRGBAlpha(0x2a2a2a, 0.5f);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(kScreenHeight / 2.0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(@(screen_width));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2.0, kScreenWidth, 60)];
    view.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);
    [self.view addSubview:view];
    
    UILabel *labelS = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, kScreenWidth, 1)];
    labelS.backgroundColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    [view addSubview:labelS];
    
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 0, 20, 55)];
    [actView startAnimating];
    actView.tag = 329001;
    actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [view addSubview:actView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 80, 30)];
    label.text = NSLocalizedString(@"附近的设备", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = HexRGBAlpha(0x000000, 1.0f);
    [view addSubview:label];
}
#pragma tableViewDeleagt
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_array.count == 0) {
        return [UITableViewCell new];
    }
    
    static NSString *reuserId = @"tableViewId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserId];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);;
    cell.textLabel.text = [(CBPeripheral*)_array[indexPath.row] name];
    cell.textLabel.textColor = HexRGBAlpha(0x000000, 1.0f);
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.detailTextLabel.textColor = kHexRGBAlpha(0x2B979C, 1.0f);
    cell.detailTextLabel.text = _rssiArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [cell layoutSubviews];
    
    NSArray *arrOfSignals = @[@"icon_signal_low", @"icon_signal_mid", @"icon_signal_high"];
    
    if ([_rssiArray[indexPath.row] integerValue] >= -60) {
        cell.imageView.image = [UIImage imageNamed:arrOfSignals[2]];
    } else if (([_rssiArray[indexPath.row] integerValue] <= -60) && [_rssiArray[indexPath.row] integerValue] >= -80) {
        cell.imageView.image = [UIImage imageNamed:arrOfSignals[1]];
    } else {
        cell.imageView.image = [UIImage imageNamed:arrOfSignals[0]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_baby cancelScan];     // 停止扫描
    NSString *status = [NSString stringWithFormat:@"正在连接%@中...", [(CBPeripheral*)_array[indexPath.row] name]];
    [SVProgressHUD showWithStatus:NSLocalizedString(status, @"") maskType:SVProgressHUDMaskTypeGradient];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    _baby.having(_array[indexPath.row]).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


- (BOOL) checkThePeripheral:(NSDictionary*)advertisementData {
    if(![advertisementData objectForKey:@"kCBAdvDataManufacturerData"]) {
        return NO;
    }
    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    if(data.length != 5) {
//        NSLog(@"长度不一致");
        return NO;
    }
    
    if ([[advertisementData objectForKey:@"kCBAdvDataLocalName"] isEqualToString:@"T-WATCH"]) {
        return NO;
    } // 过滤天霸
    
    Byte *bytes = (Byte*)[data bytes];
    //    if(!(bytes[0]==0x50) && (bytes[1]==0x30) && (bytes[2]==0x30) && (bytes[3]==0x30) && (bytes[4]==0x31))
    if(!(bytes[0] == 0x50) && (bytes[1] == 0x30) && (bytes[2] == 0x30)) {
        return NO;
    }
    
    return YES;
}

#pragma 蓝牙相关代码
// override
- (void)babyDelegate {
    __weak typeof(self) weakSelf = self;
    __weak typeof(_baby) weakBaby = _baby;
    
    __weak typeof(_array) weakArray = _array;
    __weak typeof(_rssiArray) weakRssiArray = _rssiArray;
    __weak typeof(_tableView) weakTableView = _tableView;
    
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        //if(abs([RSSI intValue] <= 80 )) {
            if ([RSSI intValue] > 0) {
                return ;
            }else if(![weakSelf checkThePeripheral:advertisementData]) {
                return ;
            }
            // NSLog(@"信号是多少:%d",[RSSI intValue]);
            // NSLog(@"------>device:%@", peripheral);
            
            [weakTableView.mj_header endRefreshing];
            [weakRssiArray addObject:[NSString stringWithFormat:@"%d", [RSSI intValue]]];
            [weakArray addObject:peripheral];
        
        
        for (NSInteger i = 0; i < weakRssiArray.count; i ++) {
            if ([weakRssiArray[i] intValue] < [RSSI intValue]) {
                [weakRssiArray exchangeObjectAtIndex:i withObjectAtIndex:weakRssiArray.count - 1];
            }
        }
        
            [weakTableView reloadData];
        //}
    }];
    
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"蓝牙连接成功！！！");
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"连接成功",nil)];
    }];
    
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"蓝牙断开连接");
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"断开连接",nil)];
        [ApplicationDelegate resetBLEStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
        [weakSelf connFailedUI];
    }];
    
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *ch in service.characteristics) {
            NSLog(@"------>特征值:%@", ch);
            [peripheral setNotifyValue:YES forCharacteristic:ch];
            ApplicationDelegate.currentPeripheral = peripheral;

            if([ch.UUID.UUIDString isEqualToString:CHANNEL_5.UUIDString]) {
                if (ApplicationDelegate.isBLESpecial) {
                    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:PreConnectedDeviceKey];
                    if(!data) return;
                    SMDeviceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    CBPeripheral *peripheral = nil;
                    if(model) {
                        NSString *uuidString = model.identifier;
                        NSArray *peripherals = [weakBaby.centralManager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:uuidString]]];
                        if(peripherals && peripherals.count != 0) {
                            peripheral = peripherals[0];
                        }
                    }
                    [WriteData2BleUtil requestAuthorized:peripheral isForbid:YES];
                } else {
                    [WriteData2BleUtil requestAuthorized:peripheral isForbid:NO];
                }
                
                
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在请求授权，请摇晃手表", nil)  ];
            }
            
            [weakSelf connSuccessAndAuthorizedUI];
        }
    }];
    
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        long valueLength = characteristic.value.length;
        const char *recValue = (char*)[characteristic.value bytes];
        
        // 授权成功
        if(valueLength==7 && recValue[0]=='$' && recValue[1]==0x04 && recValue[2]==0x02 && recValue[3]==0x0a && recValue[4]==0x01 && recValue[5]==0x13) {
            
            [weakSelf savePreConnDevice:peripheral];
            [WriteData2BleUtil requestPaired:peripheral];       // 授权成功后发起配对
            [weakSelf authorizedSuccAndPairedSucc];
            
            [weakSelf sendSwitchSrate];
            
            ApplicationDelegate.hasConnected = YES;
            ApplicationDelegate.hasAuthorized = YES;
            ApplicationDelegate.hasPaired = YES;
            
            [peripheral readValueForCharacteristic:[WriteData2BleUtil characteristicByUUID:peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_1]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
            // [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [WriteData2BleUtil requestVersionBatteryAndSyncSwitch:peripheral]; // 请求电量和版本号
            
            [WriteData2BleUtil checkC007:peripheral.name];
        }
        
//        // 有时候未发起配对命令也会受到该条命令
//        // 配对成功
//        if(valueLength==6 && recValue[0]=='$' && recValue[1]==0x03 && recValue[2]==0x01 && recValue[3]==0x1d && recValue[4]==0x01) {
//            // [weakSelf authorizedSuccAndPairedSucc];
//        }
        
        [weakSelf processReceiveBLEData:characteristic.value];
        NSLog(@"------>收到的数据是:%@", characteristic.value);
    }];
    
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"------>写入成功:%@", characteristic.value);
    }];
}

- (void)processReceiveBLEData:(NSData *)data {
    if(!data) return;
    Byte *bytes = (Byte *)[data bytes];

    sleep(0.1);
    
    // 获取到了电量和版本号
    if(bytes[0]==0x24 && bytes[1]==0x0c && bytes[2]==0x02 && bytes[3]==0x1c && bytes[4]==0x01) {
        Byte version[8] = {bytes[5], bytes[6], bytes[7],bytes[8],bytes[9],bytes[10],bytes[11],bytes[12]};
        NSString* str = [[NSString alloc] initWithBytes:version length:8 encoding:NSUTF8StringEncoding];
        int battery = (int)bytes[13];
        
        ApplicationDelegate.firmwareBattery = battery;
        ApplicationDelegate.firmwareVersion = str;
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
        NSLog(@"电量是多少:%d", battery);
        NSLog(@"版本号是多少:%@", str);
    }
}

- (void)savePreConnDevice:(CBPeripheral*)peripheral {
    SMDeviceModel *model = [[SMDeviceModel alloc] init];
    model.identifier = peripheral.identifier.UUIDString;
    model.name = peripheral.name;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:PreConnectedDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 发送消息状态
- (void)sendSwitchSrate {
    for (NSInteger i = 0; i < 6; i ++) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"stateSave%ld", i]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [WriteData2BleUtil syncAppRemindSwitch:ApplicationDelegate.currentPeripheral];
}


#pragma UI 相关代码
- (void) searchingWatchUI {
    self.toLeftImgView.hidden = YES;
    self.toRightImgView.hidden = NO;
    self.imageViewOfStatus.image = [UIImage imageNamed:@"img_searching_phone_bg"];
    
    self.label1.hidden = NO;
    self.label2.hidden = NO;
    self.label1.text = @"设备发出连接反馈时";
    self.label2.text = @"晃动设备进行确认";
}

- (void) connFailedUI {
    self.toLeftImgView.hidden = NO;
    self.toRightImgView.hidden = NO;
    self.imageViewOfStatus.image = [UIImage imageNamed:@"img_disconnected_phone_bg"];
    
    self.label1.hidden = YES;
    self.label2.hidden = NO;
    self.label2.text = @"连接失败！";
}

- (void) connSuccessAndAuthorizedUI {
    self.toLeftImgView.hidden = NO;
    self.toRightImgView.hidden = YES;
    self.imageViewOfStatus.image = [UIImage imageNamed:@"img_searching_phone_bg"];
    
    self.label1.hidden = YES;
    self.label2.hidden = NO;
    self.label2.text = @"正在连接设备...";
}

- (void) authorizedSuccAndPairedSucc {
    self.toLeftImgView.hidden = NO;
    self.toRightImgView.hidden = NO;
    self.imageViewOfStatus.image = [UIImage imageNamed:@"img_connected_phone_bg"];
    
    self.label1.hidden = YES;
    self.label2.hidden = NO;
    self.label2.text = @"配对成功";
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
