//
//  WriteData2BleUtil.h
//  Common
//
//  Created by QFITS－iOS on 16/1/8.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteData2BleUtil : NSObject
#pragma mark - 发送命令到蓝牙的工具方法
+ (void)requestAuthorized:(CBPeripheral*)peripheral isForbid:(BOOL)isForbid; // 请求授权

+ (void)requestPaired:(CBPeripheral*)peripheral; // 请求配对

+ (NSData *)BLENotiflyType:(BOOL)type startTime:(NSDate*)startTime endTime:(NSDate*)endDate;

+ (void)syncAppRemindSwitch:(CBPeripheral*)peripheral; // 同步App提醒开关

+ (void)forbidLost:(CBPeripheral*)peripheral withStatus:(BOOL)status; // 防丢

+ (void)controlHandle:(CBPeripheral*)peripheral withStatus:(BOOL)flag; // 停止或者开始走针(YES表示开始，NO表示停止)

+ (void)adjustTime:(CBPeripheral*)peripheral withHour:(NSUInteger)hour withMinute:(NSUInteger)minute withSecond:(NSUInteger)second; // 校时

+ (void)asyncWorldTime:(CBPeripheral*)peripheral; // 同步世界时间

+ (void)cameInTakePhotoVc:(CBPeripheral*)peripheral withStatus:(BOOL)flag; // 是否在拍照界面

+ (void)requestVersionBatteryAndSyncSwitch:(CBPeripheral*)peripheral; // 请求电量和版本号

+ (void)requestAlarmWithIndex:(NSUInteger)index withPeripheral:(CBPeripheral*)peripheral; // 请求闹钟

+ (void)tellMCUAlreadyFindCharacteristic:(CBPeripheral*)peripheral; // 告诉MCU发现了服务

+ (CBCharacteristic*)characteristicByUUID:(CBPeripheral*)peripheral svUUID:(CBUUID*)serviceUUID chUUID:(CBUUID*)characteristicUUID; // 根据服务 uuid 和特征 uuid 获取特征

+ (void)requestUVData:(CBPeripheral*)peripheral;

#pragma mark - C007校时
+ (void)controlDate:(CBPeripheral*)peripheral withYear:(NSUInteger)year withMonth:(NSUInteger)month withDay:(NSUInteger)day; // c007日期设置

+ (void)sendAllSeconds: (CBPeripheral*)peripheral withSeconds:(int)allSeconds;

+ (void)stopAll:(CBPeripheral*)peripheral;

// +(void) actionAll:(CBPeripheral*)peripheral;

+ (void)stopOrStartHandler:(CBPeripheral*)peripheral withStatus:(BOOL)status withIndex:(int)index; // C007 小盘

// + (void)requestUVData:(CBPeripheral*)periphral;

+ (BOOL) checkC007:(NSString*)str;



// hmm
+ (void)goIntoTiming:(CBPeripheral *)peripheral withSatus:(BOOL)isGetIn; // 是否进入校时
@end
