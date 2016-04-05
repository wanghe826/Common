//
//  SearchingWatchViewController.m
//  Common
//
//  Created by QFITS－iOS on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SearchingWatchViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "AppDelegate.h"

@interface SearchingWatchViewController ()
{
    UILabel* _topLabel;
    UILabel* _detailLabel;
    
    UIImageView* _backWatchView;
    UIImageView* _handView;
    UIButton* _connectBtn;
    
    
    __block BOOL _isPaired;
    __block BOOL _isSearched;
    __block BOOL _isConnected;
    __block BOOL _isAuthorized;
}

@end

@implementation SearchingWatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ApplicationDelegate stopReconnTimer];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ApplicationDelegate startReconnTimer];
}

- (void) initUI
{
    self.title = NSLocalizedString(@"蓝牙搜索", nil);
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    _topLabel.text = NSLocalizedString(@"正在搜索", nil);
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = RGBColor(0x00, 0x45, 0x8e);
    [_topLabel sizeToFit];
    [_topLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:_topLabel];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(self.view.mas_top).with.offset(80);
    }];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    _detailLabel.textColor = RGBColor(0xa2, 0xa2, 0xa2);
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.text = NSLocalizedString(@"点击连接并翻转手表，确定连接", nil);
    [_detailLabel sizeToFit];
    [_detailLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(_topLabel).with.offset(30);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(60);
    }];
    
    float size = 170;
    if(screen_height == 667)
    {
        size = 250;
    }
    else if(screen_height == 568)
    {
        size = 210;
    }
    else if(screen_height == 736)
    {
        size = 300;
    }
    _backWatchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    _backWatchView.image = [UIImage imageNamed:@"img_clock"];
    [self.view addSubview:_backWatchView];
    [_backWatchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size, size));
    }];
    
    _connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_connectBtn setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateNormal];
    [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_connectBtn setBackgroundImage:[UIImage imageNamed:@"btn_research_avr"] forState:UIControlStateNormal];
    [_connectBtn setBackgroundImage:[UIImage imageNamed:@"btn_research_sel"] forState:UIControlStateHighlighted];
    [_connectBtn addTarget:self action:@selector(beginSearchWatch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectBtn];
    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(53, 53));
    }];
    
    
}

#pragma override
- (void) babyDelegate
{
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(_baby) weakBaby = _baby;
    
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        if ([peripheralName isEqualToString:@"FAMAR"]) {
            return YES;
        }
        return NO;
    }];
    
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"信号是多少%d",[RSSI intValue]);
        NSLog(@"----device%@", peripheral);
        
        if(abs([RSSI intValue]<=80) && [peripheral.name isEqualToString:@"FAMAR"])
        {
            _isSearched = YES;
            [weakBaby cancelScan];     //停止扫描
            weakSelf.currentPeripheral = peripheral;
            weakBaby.having(weakSelf.currentPeripheral).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(_isConnected==NO)
                {
                    [weakSelf performSelectorOnMainThread:@selector(connFailed) withObject:nil waitUntilDone:YES];
                }
            });
        }
        
    }];
    
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        _isConnected = YES;
        NSLog(@"蓝牙连接成功");
        ApplicationDelegate.hasConnected = YES;
        [weakSelf connSuccess];
    }];
    
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [weakSelf connFailed];
        NSLog(@"蓝牙断开连接");
    }];
   
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic* ch in service.characteristics)
        {
            NSLog(@"---characteristic--%@", ch);
            [weakSelf.currentPeripheral setNotifyValue:YES forCharacteristic:ch];
            if([ch.UUID.UUIDString isEqualToString:CHANNEL_5.UUIDString])
            {
                [WriteData2BleUtil requestAuthorized:peripheral isForbid:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(_isAuthorized==NO)
                    {
                        [weakSelf performSelectorOnMainThread:@selector(connFailed) withObject:nil waitUntilDone:YES];
                    }
                });
            }
            
        }
    }];
    
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        long valueLength = characteristic.value.length;
        const char* recValue = (char*)[characteristic.value bytes];
        
        //授权成功
        if(valueLength==7 && recValue[0]=='$' && recValue[1]==0x04 && recValue[2]==0x02 && recValue[3]==0x0a && recValue[4]==0x01 && recValue[5]==0x13)
        {
            ApplicationDelegate.hasAuthorized = YES;
            [weakSelf savePreConnDevice:peripheral];
            [WriteData2BleUtil requestPaired:peripheral];
            [peripheral readValueForCharacteristic:[WriteData2BleUtil characteristicByUUID:peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_1]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(_isPaired==NO)
                {
                    [WriteData2BleUtil requestPaired:peripheral];
                }
            });
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        //配对成功
        if(valueLength==6 && recValue[0]=='$' && recValue[1]==0x03 && recValue[2]==0x01 && recValue[3]==0x1d && recValue[4]==0x01)
        {
            ApplicationDelegate.hasPaired = YES;
            _isPaired = YES;
        }
        NSLog(@"收到的数据是:%@", characteristic.value);
    }];
}

- (void) beginSearchWatch
{
    [_baby cancelAllPeripheralsConnection];
    _baby.scanForPeripherals().begin();
    self.currentPeripheral = nil;
    [self resetAllStatus];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!_isSearched)
        {
            [self performSelectorOnMainThread:@selector(searchFailed) withObject:nil waitUntilDone:YES];
        }
    });
}

- (void) searchSuccess
{
    
}

- (void) searchFailed
{
    
}

- (void) connSuccess
{
    
}

- (void) connFailed
{
    
}


- (void) resetAllStatus
{
    _isPaired = NO;
    _isSearched = NO;
    _isConnected = NO;
    _isAuthorized = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) savePreConnDevice:(CBPeripheral*)peripheral
{
    SMDeviceModel* model = [[SMDeviceModel alloc] init];
    model.identifier = peripheral.identifier.UUIDString;
    model.name = peripheral.name;
    NSData* data = [NSKeyedArchiver  archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:PreConnectedDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
