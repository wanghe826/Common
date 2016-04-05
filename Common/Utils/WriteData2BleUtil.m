//
//  WriteData2BleUtil.m
//  Common
//
//  Created by QFITS－iOS on 16/1/8.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "WriteData2BleUtil.h"
#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation WriteData2BleUtil

+ (void)requestAuthorized:(CBPeripheral*)peripheral isForbid:(BOOL)isForbid {
    Byte authorize[7] = {'$', 4, 0x02, 0x0A, 0x01, 0x03, 0x0e};
    if(isForbid == YES) {
        authorize[5] = 0x04;
        authorize[6] = 0x0f;
    }
    NSData *authorizedData = [NSData dataWithBytes:authorize length:7];
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    if(!ch) return;
    NSLog(@"请求授权======>MCU:%@", authorizedData);
    [peripheral writeValue:authorizedData forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}


+ (void)forbidLost:(CBPeripheral *)peripheral withStatus:(BOOL)status {
    UInt8 buf[7];
    if(status) {
        buf[0] = 0x24;
        buf[1] = 0x04;
        buf[2] = 0x02;
        buf[3] = 0x03;
        buf[4] = 0x04;
        buf[5] = 0x01;
        buf[6] = 0x08;
    } else {
        buf[0] = 0x24;
        buf[1] = 0x04;
        buf[2] = 0x02;
        buf[3] = 0x03;
        buf[4] = 0x04;
        buf[5] = 0x02;
        buf[6] = 0x09;
    }
    NSData *data = [NSData dataWithBytes:buf length:7];
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    if(!ch) return;
    NSLog(@"防丢======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)requestPaired:(CBPeripheral*)peripheral{
    Byte ergan[7] = {'$', 0x04, 0x01, 0x0d, 0x01, 0x01, 0xf};
    NSData *pairedData = [NSData dataWithBytes:ergan length:7];
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:peripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_1];
    if(!ch) return;
    NSLog(@"请求配对======>MCU:%@", pairedData);
    [peripheral writeValue:pairedData forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

// 勿扰模式
+ (NSData *)BLENotiflyType:(BOOL)type startTime:(NSDate*)startTime endTime:(NSDate*)endDate {
    UInt8 int0 = 0x24;
    UInt8 int1=0x08;
    UInt8 int2=0x02;
    UInt8 contentType = 0x04;
    
    UInt8 flag = 0x02;
    if(type) {
        flag = 0x01;
    }
    
    UInt8 int3, int4, int6, int7;
    if (type) {
        NSCalendar* calendar = [ NSCalendar currentCalendar];
        
        NSCalendarUnit unit = NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
        
        NSDateComponents *components = [calendar
                                        components:
                                        unit
                                        fromDate:startTime];
        int3 = [components hour];
        int4 = [components minute];
        
        components = [calendar
                      components:
                      unit
                      fromDate:endDate];
        
        int6=[components hour];
        int7=[components minute];
        
    }else{
        int3 = 0x00;
        int4 = 0x00;
        
        int6 = 0x00;
        int7 = 0x00;
    }
    
    // 华唛勿扰模式增加
    int3 = 0x00;
    int4 = 0x01;
    int6 = 0x00;
    int7 = 0x00;
    
    UInt8 int9 = (0x04 + 0x03 + int3 + int4 + int6 + int7 + flag) & 0xFF;        // w07校验和
    
    UInt8 dataBuf[11] = {int0, int1, int2,contentType, 0x03, int3,int4,int6,int7, flag,int9};
    NSData *data = [NSData dataWithBytes:dataBuf length:11];
    

    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:ApplicationDelegate.currentPeripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"同步勿扰开关======>MCU:%@", data);
    [ApplicationDelegate.currentPeripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
    return data;
}

+ (void)syncAppRemindSwitch:(CBPeripheral*)peripheral {
    /*
     w07
     0 ：QQ0001
     1 ：微信0002
     2 ：腾讯微博0004
     3 ：Skype0008
     4 ：新浪微博0010
     5 ：Facebook0020
     6 ：Twitter0040
     7 ：What Sapp0080
     8 ：Line0100            ------>华唛改为陌陌
     9 ：其他0200
     10：电话0400
     11：短信0800
     12：未接来电1000
     13：日历事件2000
     14：Reserved
     15：其他
     */
    
    NSUserDefaults *userDefts = [NSUserDefaults standardUserDefaults];
    
    UInt8 int0 = 0x24;
    UInt8 int1 = 0x05;
    UInt8 int2 = 0x02;
    
    UInt8 call = 0;
    UInt8 sms = 0;
    UInt8 weibo = 0;
    UInt8 skype = 0;
    UInt8 weichar = 0;
    UInt8 tentweibo = 0;
    UInt8 line = 0;
    UInt8 qq = 0;
    
    UInt8 fackBook = 0;
    UInt8 twitter = 0;
    UInt8 whatsapp = 0;
    UInt8 other = 0;
    
    UInt8 missedCall = 0;
    UInt8 calentEvent = 0;
    UInt8 reserved = 0;
    UInt8 otherother = 0;
    
    UInt8 momo = 0;
    
    if([userDefts boolForKey:@"stateSave5"]){                   // QQ
        qq = 1;
    }
    if([userDefts boolForKey:@"stateSave4"]){                   // 微信
        weichar = 1;
    }
    if([userDefts boolForKey:@"stateAdditionSave1"]){           // 腾讯微博
        tentweibo = 1;
    }
    
//    if([userDefts boolForKey:RemindSkype]){                   // Skype
//        skype = 1;
//    }
    
    if([userDefts boolForKey:@"stateAdditionSave0"]){           // 新浪微博
        weibo = 1;
    }
    if([userDefts boolForKey:@"stateAdditionSave4"]){           // Facebook
        fackBook = 1;
    }
    if([userDefts boolForKey:@"stateAdditionSave5"]){           // Twitter
        twitter = 1;
    }
    if([userDefts boolForKey:@"stateAdditionSave7"]){           // whatsapp
        whatsapp = 1;
    }
    
    if([userDefts boolForKey:@"stateAdditionSave9"]){           // Line
        line = 1;
    }
    
//    if([UserDefaultsUtils boolValueWithKey:OtherRemindStatus]){         // Other
//        other = 1;
//    }
    
    if([userDefts boolForKey:@"stateSave3"]){                   // 电话提醒
        call = 1;
    }
    
    if([userDefts boolForKey:@"stateSave2"]){                   // 短信提醒
        sms = 1;
    }
    
//    if([userDefts boolForKey:RemindCall]){                    // 未接来电
//        missedCall = 1;
//    }

//    if([userDefts boolForKey:RemindCalendar]){                // 日历事件
//        calentEvent = 1;
//    }
    
//    if([UserDefaultsUtils boolValueWithKey:ReservedStatus]){            // Reserved
//        reserved = 1;
//    }

//    if([UserDefaultsUtils boolValueWithKey:LineRemindStatus])
//    {
//        momo = 1;
//    }
    // 其他
    reserved = 0;
    calentEvent = 1;
    
    UInt8 int5 = (whatsapp<<7) + (twitter<<6) + (fackBook<<5) + (weibo<<4) + (skype<<3) + (tentweibo<<2) + (weichar<<1) + qq;
    UInt8 int6 = (otherother<<7) + (reserved<<6) + (calentEvent<<5) + (missedCall<<4) + (sms<<3) + (call<<2) + (other<<1) + momo;
    
    UInt8 checkSum = 0x03 + 0x06 + int6 + int5;
    UInt8 dataBuf[8] = {int0, int1, int2, 0x03, 0x06, int5, int6, checkSum};
    
    UInt8 dataBufC007[11] = {'#',0x01, 0x05, 0x31, 0x81, 0x01, 0x05, 0x01, int5,int6, 0xaa};
    
    NSData *data = [NSData dataWithBytes:dataBuf length:8];
    if(ApplicationDelegate.isC007){
        data = [NSData dataWithBytes:dataBufC007 length:11];
    }
    
    CBPeripheral *p = nil;
    if(!peripheral) {
        p = ApplicationDelegate.currentPeripheral;
    }
    else {
        p = peripheral;
    }
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"同步信息提醒开关======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
    return;
}

+ (void)controlHandle:(CBPeripheral*)peripheral withStatus:(BOOL)flag {
//    Byte bytes[6];
//    bytes[0] = 0x24;
//    bytes[1] = 0x03;
//    bytes[2] = 0x02;
//    bytes[3] = 0x05;
//    bytes[4] = 0x01;
//    bytes[5] = 0x06;
//    if(flag) {
//        bytes[4] = 0x02;
//        bytes[5] = 0x07;
//    }
//    // c007 大表盘停针
//    Byte c007Bytes[11] = {'#', 0x01, 0x05, 0x31, 0x81, 0x04, 0x02,0x04, 0xff, 0x04, 0xaa};
//    if(flag) {
//        // c007大表盘走针
//        c007Bytes[8] = 0xf0;
//    }
//    else {
//        c007Bytes[8] = 0xff;
//    }
//    
//    if([ApplicationDelegate.productSeries isEqualToString:@"F003"]) {
//        c007Bytes[9] = 0x03;
//    }
//
//    
//    NSData *data = [NSData dataWithBytes:bytes length:6];
//    if(ApplicationDelegate.isC007)  {
//        data = [NSData dataWithBytes:c007Bytes length:11];
//    }
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p){
//        NSLog(@"外设是空的！！！");
//        return  ;
//    }
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    NSLog(@"走针或者停针======>MCU:%@", data);
//    if(!ch) {
//        return;
//    }
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)sendAllSeconds:(CBPeripheral*)peripheral withSeconds:(int)allSeconds {
//    Byte bytes[12] = {'#', 0x01, 0x06, 0x31, 0x81, 0x01, 0x02, 0x02, 0x04};
//    bytes[10] = allSeconds>>8;
//    bytes[9] = (UInt8)allSeconds;
//    bytes[11] = 0xaa;
//
//    NSData *data = [NSData dataWithBytes:bytes length:12];
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p) return;
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    NSLog(@"走针或者停针======>MCU:%@", data);
//    if(!ch) {
//        return;
//    }
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
} // 发送所有秒数

+ (void)adjustTime:(CBPeripheral*)peripheral withHour:(NSUInteger)hour withMinute:(NSUInteger)minute withSecond:(NSUInteger)second {
    UInt8 u8_hour = (UInt8)hour;
    UInt8 u8_minute = (UInt8)minute;
    UInt8 u8_second = (UInt8)second;
    NSLog(@"hour:%ld,,min:%ld,,sec%ld", hour, minute, second);
    UInt8 checkSum = u8_hour + u8_minute + u8_second + 0x03 + 0x05;
    UInt8 buf[9] = {'$', 0x06, 0x02, 0x05, 0x03, u8_hour, u8_minute, u8_second, checkSum};
    NSData *data = [NSData dataWithBytes:buf length:9];
    
//    UInt8 c007Buf[12] = {'#', 0x01, 0x06, 0x31, 0x81, 0x01, 0x01, 0x01, u8_hour, u8_minute, u8_second, 0xaa};
//    NSData *data = [NSData dataWithBytes:buf length:9];
//    if(ApplicationDelegate.isC007) {
//        data = [NSData dataWithBytes:c007Buf length:12];
//    }
    
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:ApplicationDelegate.currentPeripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    if(!ch) return;
    NSLog(@"校时======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
} // 调整时间

+ (void)asyncWorldTime:(CBPeripheral*)peripheral {
//    NSDate* date = [NSDate date];
//    NSDateComponents *components = [[NSCalendar currentCalendar]
//                                    components:
//                                    NSCalendarUnitDay |
//                                    NSCalendarUnitMonth|
//                                    NSCalendarUnitYear|
//                                    NSCalendarUnitHour|
//                                    NSCalendarUnitMinute|
//                                    kCFCalendarUnitSecond
//                                    fromDate:date];
//    
//    UInt8 day = (UInt8)[components day];
//    UInt8 month = (UInt8)[components month];
//    
//    BOOL isDstOn = NO;          // 是否有夏令时
//    UInt8 hour = (UInt8)[components hour] + (isDstOn ? 1 : 0);
//    UInt8 min = (UInt8)[components minute];
//    UInt8 sec = (UInt8)[components second];
//    //    UInt8 pYear = (UInt8)timeParamConvert([components year] % 100);
//    UInt8 pYear = (UInt8)([components year] % 100);
//    
//    NSString* city = @"HKG";        // 默认设置HongKong
//    NSInteger len = city.length > 3 ?3 :city.length;
//    UInt8 charCity[3] = {0};
//    for (int i = 0; i < len; i++) {
//        charCity[i] = (UInt8)[city characterAtIndex:i];
//    }
//    UInt8 timeZone = 0x01;
//    UInt8 checkSum = 0x04 + 0x01 +  pYear + month + day + hour + min + sec + timeZone;
//    UInt8 buf[13] = {'$', 0x0a, 0x02, 0x04, 0x01, pYear, month, day, hour, min, sec, timeZone, checkSum};
//    NSData* data = [NSData dataWithBytes:buf length:13];
//    
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p) return;
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    NSLog(@"同步世界时======>MCU:%@", data);
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
} // 同步世界时间

+ (void)cameInTakePhotoVc:(CBPeripheral*)peripheral withStatus:(BOOL)flag {
    NSData *data;
    if(flag) {
        UInt8 dataBuf[] = {0x24, 0x04, 0x02, 0x03, 0x02, 0x01, 0x06};
        data = [NSData dataWithBytes:dataBuf length:7];
    } else {
        UInt8 dataBuf[] = {0x24, 0x04, 0x02, 0x03, 0x02, 0x02, 0x07};
        data = [NSData dataWithBytes:dataBuf length:7];
    }
    
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"进入或者退出拍照======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)requestVersionBatteryAndSyncSwitch:(CBPeripheral*)peripheral {
    Byte battery[7] = {'$', 4, 0x02, 0x0c, 0x01, 0x01,0x0e};
    NSData *batteryData = [NSData dataWithBytes:battery length:7];
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"查询电量和版本号======>MCU:%@", batteryData);
    [peripheral writeValue:batteryData forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
    
} // 获取电量以及版本

+ (void)tellMCUAlreadyFindCharacteristic:(CBPeripheral*)peripheral {
    Byte bytes[7] = {'$',4, 0x02, 0x0a, 0x01, 0x02, 0x0d};
    NSData *data = [NSData dataWithBytes:bytes length:7];
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
#warning 崩溃过。。。
    NSLog(@"告诉MCU发现了服务======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)requestAlarmWithIndex:(NSUInteger)index withPeripheral:(CBPeripheral*)peripheral {
    Byte byte[7] = {'$', 0x04, 0x02, 0x09, 0x02};
    if(index == 1){
        byte[5] = 0x01;
        byte[6] = 0x0c;
    }else if (index == 2){
        byte[5] = 0x02;
        byte[6] = 0x0d;
    }else{
        byte[5] = 0x03;
        byte[6] = 0x0e;
    }
    NSData *data = [NSData dataWithBytes:byte length:7];
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"请求闹钟n======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)requestUVData:(CBPeripheral*)peripheral {
    Byte dataByte[7] = {'$', 0x04, 0x02, 0x0a, 0x02, 0x01, 0x0d};
    NSData *data = [NSData dataWithBytes:dataByte length:7];
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    NSLog(@"请求UV======>MCU:%@", data);
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

// C007校时
+ (void)controlDate:(CBPeripheral*)peripheral withYear:(NSUInteger)year withMonth:(NSUInteger)month withDay:(NSUInteger)day
{
//    Byte bytes[13] = {'#', 0x01, 0x06, 0x31, 0x81, 0x01, 0x01, 0x02};
////    bytes[8] = (UInt16)year;
////    bytes[9] = (UInt16)month;
////    bytes[10] = (UInt16)day;
////    bytes[11] = 0xaa;
//    bytes[8] = 0xe0;
//    bytes[9] = 0x07;
//    bytes[10] = (UInt16)month;
//    bytes[11] = (UInt16)day;
//    bytes[12] = 0xaa;
//    
//    NSData *data = [NSData dataWithBytes:bytes length:13];
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p) return;
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    if(!ch) return;
//    NSLog(@"C007设置日期n======>MCU:%@", data);
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)stopAll:(CBPeripheral*)peripheral {
//    Byte bytes[11] = {'#', 0x01, 0x05, 0x31, 0x81, 0x04, 0x02, 0x04, 0xe0, 0x01, 0xaa};
//    NSData *data = [NSData dataWithBytes:bytes length:11];
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p) return;
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    if(!ch) return;
//    NSLog(@"C007停小针n======>MCU:%@", data);
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)actionAll:(CBPeripheral*)peripheral {
//    Byte bytes[11] = {'#', 0x01, 0x05, 0x31, 0x81, 0x04, 0x02, 0x04, 0xe0, 0x00, 0xaa};
//    NSData *data = [NSData dataWithBytes:bytes length:11];
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p) return;
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    if(!ch) return;
//    NSLog(@"C007开小针n======>MCU:%@", data);
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

// C007 停针或者走针
+ (void)stopOrStartHandler:(CBPeripheral*)peripheral withStatus:(BOOL)status withIndex:(int)index {
//    Byte bytes[11] = {0x23, 0x01, 0x05, 0x31, 0x81, 0x04, 0x02, 0x04, 0xFF, 0X02, 0xaa};
//    if(status) {
//       bytes[8] = 0xf0;
//    } else {
//       bytes[8] = 0xff;
//    }
//    
//    switch (index) {
//        case 1:
//            bytes[9] = 0x01;
//            break;
//        case 2:
//            bytes[9] = 0x02;
//            break;
//        case 3:
//            bytes[9] = 0x03;
//        default:
//            break;
//    }
//    
//    NSData *data = [NSData dataWithBytes:bytes length:11];
//    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
//    if(!p) return;
//    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
//    if(!ch) return;
//    NSLog(@"C007小盘停针n======>MCU:%@", data);
//    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

+ (void)goIntoTiming:(CBPeripheral *)peripheral withSatus:(BOOL)isGetIn {
    Byte bytes[6];
    bytes[0] = 0x24;
    bytes[1] = 0x03;
    bytes[2] = 0x02;
    bytes[3] = 0x05;
    NSData *data = nil;
    if (isGetIn) {
        bytes[4] = 0x01;
        bytes[5] = 0x06;
    } else {
        bytes[4] = 0x02;
        bytes[5] = 0x07;
    }
    data = [NSData dataWithBytes:bytes length:6];
    CBPeripheral *p = peripheral ? peripheral : ApplicationDelegate.currentPeripheral;
    if(!p) return;
    CBCharacteristic *ch = [WriteData2BleUtil characteristicByUUID:p svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    if(!ch) return;
    
    [peripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
    if (isGetIn) {
        NSLog(@"进入校时！！！发送命令：%@", data);
    } else {
        NSLog(@"退出校时！！！发送命令：%@", data);
    }
    /*
     0x24 0x03 0x02 0x05 0x01 0x06  进入校针模式   APP-MCU
     0x24 0x03 0x02 0x01 0xaa 0xab     成功收到命令
     
     0x24 0x03 0x02 0x05 0x02 0x07   退出校针模式  APP-MCU
     0x24 0x03 0x02 0x01 0xaa 0xab     成功收到命令
     */
} // 是进入了校时？

+ (CBCharacteristic*)characteristicByUUID:(CBPeripheral*)peripheral svUUID:(CBUUID*)serviceUUID chUUID:(CBUUID*)characteristicUUID {
    if(!peripheral)  return nil;
    
    for (CBService* service in peripheral.services) {
        if([service.UUID.UUIDString isEqualToString:serviceUUID.UUIDString])  {
            for (CBCharacteristic*ch in service.characteristics) {
                if([ch.UUID.UUIDString isEqualToString:characteristicUUID.UUIDString]) {
                    return ch;
                }
            }
        }
    }
    return nil;
}

+ (BOOL)checkC007:(NSString*)str {    
    NSString *objects = [ApplicationDelegate.projDic objectForKey:str];
    if(!objects) {
        if ([str isEqualToString:@"FAMAR"] || [str isEqualToString:@"T-WATCH"]) {
            ApplicationDelegate.productSeries = str;
            ApplicationDelegate.isC007 = NO;
            [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"WhichWatch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return NO;
        }
    } else {
        NSInteger index = 1;
        if([[objects substringToIndex:0] isEqualToString:@"H"]) index = 1;
     
        else if([objects containsString:@"C002"] || [objects containsString:@"C003"])  index = 2;
        
        else if ([objects isEqualToString:@"C004"] || [objects isEqualToString:@"C006"] || [objects isEqualToString:@"C007"]) index = 3;
        
        else if([objects isEqualToString:@"C005"]) index = 4;
        
        else if([objects isEqualToString:@"C007"] || [objects isEqualToString:@"F003"]) index = 5;
        
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"WhichWatch"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        ApplicationDelegate.productSeries = objects;
        ApplicationDelegate.isC007 = YES;
        return YES;
    }
    
    ApplicationDelegate.productSeries = nil;
    ApplicationDelegate.isC007 = NO;
    return NO;
} // 检查是否是 c007 代表的心协议
@end
