//
//  SportData.m
//  Common
//
//  Created by QFITS－iOS on 16/3/11.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SportData.h"
#import "SportModel.h"
#import "MyFMDBUtil.h"
#import "WriteData2BleUtil.h"

@interface SportData ()

@property (nonatomic, assign) BOOL stopNow;

@end

@implementation SportData

- (instancetype) init {
    self = [super init];
    if(self) {
        _peripheral = ApplicationDelegate.currentPeripheral;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _sportModelsBuffer = [NSMutableArray new];
        
        [self createBLEOberserv];
    }
    return self;
}

- (void)fetchAllSportDataLength {
    if(!_peripheral)  return;
    Byte bytes[6] = {'$', 0x03, 0x02, 0x06, 0x02, 0x08};
    
    Byte bytesC007[9] = {'#', 0x01, 0x03, 0x31, 0x81, 0x02, 0x07, 0x01, 0xaa};
    
    NSData *data = [NSData dataWithBytes:bytes length:6];
    if(ApplicationDelegate.isC007) {
        data = [NSData dataWithBytes:bytesC007 length:9];
    }
    
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:_peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"------>请求运动数据:%@",  data);
    [_peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在同步数据，请稍后", nil) maskType:SVProgressHUDMaskTypeGradient];
}

- (void)createBLEOberserv {
    __weak typeof(self) weakSelf = self;
    // 收到数据
    [ApplicationDelegate.babyBluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        [self processRecData:characteristic.value withPeripheral:peripheral];
        
        NSLog(@"------>收到数据👺%@", characteristic.value);
        // 收到第三个通道发过来的运动数据
         if([characteristic.UUID.UUIDString isEqualToString:CHANNEL_3.UUIDString]) {
             if (weakSelf.stopNow) {
                 
             } else {
                 [self assemableSportData:(Byte*)[characteristic.value bytes]];
                 
             }
         }
        
        ApplicationDelegate.hasPaired = YES;
    }];
    
    // 断开连接
    [ApplicationDelegate.babyBluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        _recIndex = 0;
        _sendIndex = 0;
        [ApplicationDelegate resetBLEStatus];
        ApplicationDelegate.babyBluetooth.having(peripheral).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }];
    
    // 连接上
    [ApplicationDelegate.babyBluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
    }];
    
    // 发现特征
    [ApplicationDelegate.babyBluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic* characteristic  in service.characteristics) {
            if([[characteristic.UUID UUIDString] isEqualToString:CHANNEL_5.UUIDString]) {
                [WriteData2BleUtil requestAuthorized:peripheral isForbid:YES];
                ApplicationDelegate.hasPaired = YES;
            }
        }
    }];
}

- (void)processRecData:(NSData*)data withPeripheral:(CBPeripheral*)peripheral {
    if(!data) return;
    Byte *recBytes = (Byte*)[data bytes];
    
    // 收到C007的运动数据
    if(recBytes[0]==0x23 && recBytes[1]==0x01 && recBytes[2]==0x07 && recBytes[3]==0x13 && recBytes[4]==0x81 && recBytes[5]==0x80 && recBytes[6]==0x07 && recBytes[7]==0x01) {
        int i = (int)recBytes[8];
        int j = (int)recBytes[9];
        int length = (j<<8) + i;            // 总共有多少个计步包
        self.oneDaySportData = length;
        NSLog(@"------>一共有多少步:%d", length);
    }
    
    // 收到的数据包总长度
    if(recBytes[0]==0x24 && recBytes[1]==0x05 && recBytes[2]==0x02 && recBytes[3]==0x06 && recBytes[4]==0x12) {
        int i = (int)recBytes[5];
        int j = (int)recBytes[6];
        int length = (j<<8) + i;            // 总共有多少个计步包
        NSLog(@"一共有几个计步包:%d", length);
        _allDataLength = length;
        
        if(length <= 16 && length > 0)  {
            [self requestSportsData:0];
        } else if(length> 16) {
            [self readyRequestDownloadSportsData];
        } else {
        }
    }
    
    // 授权成功
     if(recBytes[0]==0x24 && recBytes[1]==4 && recBytes[2]==0x02 && recBytes[3]==0x0a && recBytes[4]==0x01 && recBytes[5]==0x13) {
         [WriteData2BleUtil requestVersionBatteryAndSyncSwitch:peripheral];
     }
    
    // 获取到电量和版本号
    if(recBytes[0]==0x24 && recBytes[1]==0x0c && recBytes[2]==0x02 && recBytes[3]==0x1c && recBytes[4]==0x01) {
        [self requestSportsData:0];
    }
}

// 组装计步数据并插入到数据库
- (void)assemableSportData:(Byte*)recbytes {
    //01 00 00 ff ff 02 00 00 00 00 00 00 00 00 00 00 00 00 00 27
    int i = recbytes[1];
    int j = recbytes[2];

    int packageIndex = (j<<8) + i;  //包序号
    
#warning 处理收到多个重复的包的 bug
    if(packageIndex != 0 && packageIndex == _alreadyReceivedPckIndex) return;
    _alreadyReceivedPckIndex = packageIndex;
    
    if(packageIndex == 0){
        _nearDate = [NSDate date];
        
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        NSUInteger minute = 5;
        if(comps.minute % 5) {
            minute = comps.minute - comps.minute%5;
            comps.minute = minute;
            
            _nearDate = [calendar dateFromComponents:comps];
        }
        NSLog(@"------>第一个时间是:%@", _nearDate);
        
    }
    NSLog(@"------>收到的包序号是:%d", packageIndex);
    
    _recIndex = packageIndex;
    
    int countOfFullPck = 0;
    for(int i = 0; i < 16; i += 2) {
        if(recbytes[3+i]!=0xff && recbytes[4+i]!=0xff) {
            countOfFullPck++;
        } else {
            break;
        }
    }
    
    NSDate *tmpDate = _nearDate;
    
    for(int i = 0,j = 0; i < 16; i += 2){
        // 异常情况---
        if(recbytes[3] == 0xff && recbytes[4] == 0xff) {                 // 1.开始有空包
            int lengthOfNullPackage = (int)recbytes[5] + ((int)(recbytes[6])<<8);
            
            _nearDate = [_nearDate dateByAddingTimeInterval:-1*lengthOfNullPackage*300];
            ++packageIndex;
            [self requestNexPackage:packageIndex];
            return;
        }
    
        // 正常情况---
        int low = (int)(recbytes[4+i]);
        int pck = (int)recbytes[3+i] + (low<<8);
        
        if(i > 0){
            if(recbytes[3+i]==0xff && recbytes[4+i]==0xff) {         // 2.中间有空包
                int nullPackage = i/2;
                _nearDate = [_nearDate dateByAddingTimeInterval:-1*nullPackage*300];
                ++packageIndex;
                [self requestNexPackage:packageIndex];
                return;
            }
        }
        
        SportModel *model = [[SportModel alloc] init];
        if(_nearDate){
            //            NSDate* date = [tmpDate dateByAddingTimeInterval:-60*5*(7-j)];
            NSDate *date = [tmpDate dateByAddingTimeInterval:-60*5*(countOfFullPck-1-j)];
            
            NSString *dateStr = [_dateFormatter stringFromDate:date];
            model.sportTime = [dateStr substringToIndex:dateStr.length-3];
        }
        model.sportData = pck;
        NSLog(@"------>计步时间:%@", model.sportTime);
        
        [_sportModelsBuffer addObject:model];
        
        ++j;
    }
    _nearDate = [_nearDate dateByAddingTimeInterval:-60*5*8];
    
    ++packageIndex;
    [self requestNexPackage:packageIndex];
}

- (void)requestNexPackage:(int)packageIndex {
    if(packageIndex < _allDataLength) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"-df-s-df-a-sdf-a-sfd-a-fa-sd-fa-");
            [self requestSportsData:packageIndex];
            
            // 超时处理
            int tmp = _recIndex;
            float timeOut = 1.5 * 2;
            if(_allDataLength <= 16) {
                timeOut = 2.0 * 2;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOut * NSEC_PER_SEC)), dispatch_get_global_queue(0,0), ^{
                if(_recIndex == tmp) {
                    [self requestSportsData:_sendIndex];
                }
            });
        });
    } else if (packageIndex >= _allDataLength) { // _allDataLength - 400
        Byte clear[6] = {'$', 0x03, 0x02, 0x03, 0x05, 0x08};
        NSData *clearData = [NSData dataWithBytes:clear length:6];
        CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:_peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//        [_peripheral writeValue:clearData forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
        for(SportModel *model in _sportModelsBuffer) {
            [MyFMDBUtil insertData:model withUUID:ApplicationDelegate.currentPeripheral.identifier.UUIDString];
        }
        [SVProgressHUD dismiss];
        self.stopNow = YES;
    }
}

- (void)requestSportsData:(int)packageIndex {
    if(!_peripheral) return;
    Byte low = (Byte)(packageIndex&0xff);
    Byte big =  (Byte)((packageIndex>>8)&0xff);
    Byte checkSum = 0x06 + 0x03 + big + low;
    Byte bytes[8] = {'$', 0x05, 0x02, 0x06, 0x03, low, big, checkSum};
    NSData *data = [NSData dataWithBytes:bytes length:8];
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:_peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_1];
    [_peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
} // 请求哪一个‘节点’的数据

// 运动数据上传准备------->BLE断开修改连接间隔
-(void)readyRequestDownloadSportsData {
    Byte bytes[6] = {'$', 0x03, 0x02, 0x06, 0x01, 0x07};
    NSData *data = [NSData dataWithBytes:bytes length:6];
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:_peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_1];
    [_peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

- (void) dealloc {
}

@end
