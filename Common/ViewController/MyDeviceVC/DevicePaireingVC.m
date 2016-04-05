//
//  DevicePaireingVC.m
//  Common
//
//  Created by Ling on 16/3/3.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

/***
1，连接页面的问题:   捕捉不到是否配对！！！！！！
2, 有时候未发起配对命令也会受到该条命令！！！！！！
 ***/

#import "DevicePaireingVC.h"
#import "MJRefresh.h"

@interface DevicePaireingVC () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_array;
    NSMutableArray *_rssiArray;
    UITableView *_tableView;
}
@property (weak, nonatomic) IBOutlet UILabel *labelOpenBle;
@property (weak, nonatomic) IBOutlet UIImageView *ivBottomLeftArrow;
@property (weak, nonatomic) IBOutlet UILabel *labelConnHint;
@property (weak, nonatomic) IBOutlet UILabel *labelConnStatus;
@property (weak, nonatomic) IBOutlet UIImageView *ivLeftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *ivConnStatus;
@property (weak, nonatomic) IBOutlet UIImageView *ivTopWatch;
@property (weak, nonatomic) IBOutlet UILabel *labelReconn;
@property (weak, nonatomic) IBOutlet UIImageView *ivBottomWatch;
@end

@implementation DevicePaireingVC

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
    [ApplicationDelegate startReconnTimer];
}
- (void) beginSearchWatch {
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

- (void) initTableView {
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
    actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [view addSubview:actView];
    
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_baby cancelScan];     //停止扫描
    NSString* status = [NSString stringWithFormat:@"%@ %@...." , NSLocalizedString(@"正在连接",nil) , [(CBPeripheral*)_array[indexPath.row] name]];
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
        NSLog(@"长度不一致");
        return NO;
    }
    
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
//    __weak typeof(_baby) weakBaby = _baby;
    
    // 设置查找设备的过滤器
//    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
//        if ([peripheralName isEqualToString:@"FAMAR"]) {
//            return YES;
//        }
//        return NO;
//    }];
    
    __weak typeof(_array) weakArray = _array;
    __weak typeof(_rssiArray) weakRssiArray = _rssiArray;
    __weak typeof(_tableView) weakTableView = _tableView;
    
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        // if(abs([RSSI intValue] <= 80 )) {
            if(![weakSelf checkThePeripheral:advertisementData]) {
                return ;
            }
            NSLog(@"信号是多少%d",[RSSI intValue]);
            NSLog(@"----device%@", peripheral);
            
            [weakTableView.mj_header endRefreshing];
            [weakRssiArray addObject:[NSString stringWithFormat:@"%d", [RSSI intValue]]];
            [weakArray addObject:peripheral];
            [weakTableView reloadData];
        // }
     
    }];
    
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"蓝牙连接成功");
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"连接成功",nil)];
        
        [WriteData2BleUtil checkC007:peripheral.name];
        ApplicationDelegate.hasConnected = YES;
        ApplicationDelegate.currentPeripheral = peripheral;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
        if(ApplicationDelegate.isC007) {
            [weakSelf savePreConnDevice:peripheral];
            
            ApplicationDelegate.hasAuthorized = YES;
            ApplicationDelegate.hasPaired = YES;
            
            [weakSelf authorizedSuccAndPairedSucc];
            // [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"蓝牙断开连接");
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"断开连接",nil)];
        [ApplicationDelegate resetBLEStatus];
        [weakSelf connFailedUI];
    }];
    
    
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *ch in service.characteristics) {
            NSLog(@"------>特征值:%@", ch);
            [peripheral setNotifyValue:YES forCharacteristic:ch];
            
            if(ApplicationDelegate.isC007) {
                 continue;
            } // C007不需要授权
            if([ch.UUID.UUIDString isEqualToString:CHANNEL_5.UUIDString]) {
                [WriteData2BleUtil requestAuthorized:peripheral isForbid:NO];
                [weakSelf connSuccessAndAuthorizedUI];         // 连接成功后开始请求授权
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在请求授权，请摇晃手表", nil)  ];
            }
        }
    }];
    
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        long valueLength = characteristic.value.length;
        const char *recValue = (char*)[characteristic.value bytes];
        
        // 授权成功
        if(valueLength==7 && recValue[0]=='$' && recValue[1]==0x04 && recValue[2]==0x02 && recValue[3]==0x0a && recValue[4]==0x01 && recValue[5]==0x13) {
            ApplicationDelegate.hasAuthorized = YES;
            [weakSelf savePreConnDevice:peripheral];
            [WriteData2BleUtil requestPaired:peripheral];       //授权成功后发起配对
            ApplicationDelegate.hasPaired = YES;
            [weakSelf authorizedSuccAndPairedSucc];
            
            [peripheral readValueForCharacteristic:[WriteData2BleUtil characteristicByUUID:peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_1]];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        //有时候未发起配对命令也会受到该条命令
        // 配对成功
//        if(valueLength==6 && recValue[0]=='$' && recValue[1]==0x03 && recValue[2]==0x01 && recValue[3]==0x1d && recValue[4]==0x01) {
//            [weakSelf authorizedSuccAndPairedSucc];
//            ApplicationDelegate->isPaired = YES;                // 配对成功
//        }

        NSLog(@"------>收到的数据是:%@", characteristic.value);
    }];
    
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"------>写入成功:%@", characteristic.value);
    }];
}

- (void)savePreConnDevice:(CBPeripheral*)peripheral {
    SMDeviceModel *model = [[SMDeviceModel alloc] init];
    model.identifier = peripheral.identifier.UUIDString;
    model.name = peripheral.name;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:PreConnectedDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma UI 相关代码
- (void) searchingWatchUI {
    self.labelReconn.hidden = YES;
    self.labelConnHint.hidden = YES;
    self.labelOpenBle.hidden = YES;
    self.ivBottomLeftArrow.hidden = YES;
    self.ivBottomWatch.hidden = YES;
    self.ivConnStatus.image = [UIImage imageNamed:@"img_searching_phone_bg"];
    self.labelConnStatus.text = NSLocalizedString(@"正在搜索设备...",nil);
}

- (void) connFailedUI {
    self.labelReconn.hidden = YES;
    self.labelOpenBle.hidden = NO;
    self.labelConnStatus.hidden = NO;
    self.labelConnStatus.text = NSLocalizedString(@"连接失败",nil);
    self.labelConnHint.hidden = NO;
    self.labelConnHint.text = NSLocalizedString(@"下拉页面重新连接",nil);
    self.labelReconn.hidden = YES;
    
    self.ivBottomWatch.hidden = NO;
    self.ivBottomLeftArrow.hidden = NO;
    
    self.ivConnStatus.image = [UIImage imageNamed:@"img_disconnected_phone_bg"];
}

- (void) connSuccessAndAuthorizedUI {
    self.labelConnStatus.hidden = YES;
    self.labelConnHint.hidden = NO;
    self.labelConnHint.text = NSLocalizedString(@"设备发出连接反馈时晃动设备进行确认",nil);
    self.labelReconn.hidden = NO;
}

- (void) authorizedSuccAndPairedSucc {
    self.labelConnStatus.hidden = NO;
    self.labelConnStatus.text = NSLocalizedString(@"配对成功",nil);
    self.labelConnHint.hidden = YES;
    self.labelOpenBle.hidden = YES;
    self.labelReconn.hidden = YES;
    self.ivBottomLeftArrow.hidden = YES;
    self.ivBottomWatch.hidden = YES;
    self.ivConnStatus.hidden = NO;
    self.ivConnStatus.image = [UIImage imageNamed:@"img_connected_phone_bg"];
}

@end
