//
//  Constants.h
//  Common
//
//  Created by QFITS－iOS on 15/12/22.
//  Copyright © 2015年 Smartmovt. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#ifdef __OBJC__

// 连接相关的数据持久化 键
#define PreConnectedDeviceKey @"PreConnectedDeviceKey"

// 华唛通道
#define TOUCHUAN_COMMAND_SERVICE_UUID            [CBUUID UUIDWithString:@"0000a800-0000-1000-8000-00805f9b34fb"]

#define CHANNEL_1 [CBUUID UUIDWithString:@"0000A801-0000-1000-8000-00805F9B34FB"] // 配对通道等
#define CHANNEL_2 [CBUUID UUIDWithString:@"0000A802-0000-1000-8000-00805F9B34FB"] // 不需要BLE处理，直接传给MCU/授权
#define CHANNEL_3 [CBUUID UUIDWithString:@"0000A803-0000-1000-8000-00805F9B34FB"] // 运动数据
#define CHANNEL_4 [CBUUID UUIDWithString:@"0000A804-0000-1000-8000-00805F9B34FB"] // OTA MCU
#define CHANNEL_5 [CBUUID UUIDWithString:@"0000A805-0000-1000-8000-00805F9B34FB"] // OTA BLE

//App提醒key常量
/*
#define RemindQQ @"RemindQQ"
#define RemindWx @"RemindWx"
#define RemindWb @"RemindWb"
#define RemindTencentWb @"RemindTencentWb"
#define RemindSkype @"RemindSkype"
#define RemindFacebook @"RemindFacebook"
#define RemindTwitter @"RemindTwitter"
#define RemindWhatsApp @"RemindWhatsApp"
#define RemindLine @"RemindLine"
#define RemindMsg @"RemindMsg"
#define RemindCall @"RemindCall"
#define RemindCalendar @"RemindCalendar"
 */

//智能校时常量
#define AutoTimingSwitchStatus @"AutoTimingSwitchStatus"


//notification 常量
#define RefreshFirmwareBatteryAndVersion @"RefreshFirmwareBatteryAndVersion"
#define AuthorizedSuccess @"AuthorizedSuccess"


#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define ApplicationDelegate     ((AppDelegate *)([UIApplication sharedApplication].delegate))


// #pragma mark - 颜色相关
#define kRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kRandomColor(a) [UIColor colorWithRed:(arc4random_uniform(256))/255.0f green:(arc4random_uniform(256))/255.0f blue:(arc4random_uniform(256))/255.0f alpha:(a)]
#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

// #pragma mark - 屏幕宽高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width // 屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height // 屏幕高度

// #pragma mark - C语言打印 printf
#ifdef DEBUG
#define kPrintf(Format, ...) fprintf(stderr, "所在文件:%s 行数:%d 打印内容:%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:Format, ##__VA_ARGS__] UTF8String]);
#else
#define kPrintf(Format, ...) nil
#endif

// #pragma mark - OC语言打印 NSLog
#ifdef DEBUG
#define kLog(Format, ...) NSLog(@"所在文件:%s 行数:%d 打印内容:%@\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,[NSString stringWithFormat:Format, ##__VA_ARGS__])
#else
#define kLog(Format, ...)  ((void)0)
#endif

// APP 常量引入
#define kSedentarySave @"kSedentarySave"
#define kSedentarySave @"kNedication"
#define kNewHealth @"kNewHealth"

// #pragma mark - 头文件引入
#import <Masonry.h>
#import "AppDelegate.h"
#import "WriteData2BleUtil.h"
#import "SMDeviceModel.h"
#import "SMPlaySound.h"
#import "CustomViewUtil.h"
#import "SVProgressHUD.h"
#import "FetchSportDataUtil.h"
#import "NSArray+Swizzle.h"

// 首页头文件
#import <HealthKit/HealthKit.h>
#import "MyFMDBUtil.h"
#import "SportModel.h"

#import "SmartRemindingViewController.h"//提示
#import "SystemSettingViewController.h"//设置
#import "MyDeviceVC.h" // 我的设备
#import "HealthVC.h"//健康提醒

#import "TimingVC.h" // 校时
//#import "PersonalVC.h" // 个人
#import "PersonalInformationVC.h"  //个人
#import "AlarmVC.h" // 闹钟
#import "SleepVC.h" // 睡眠界面
#import "UltravioletRaysVC.h" // 紫外线
#import "MountainAndDivingVC.h" // 爬山和潜水
#import "HeartBeatsVC.h" // 心率
#import "HMMTakePicVC.h" // 拍照
#import "MyNewClockVC.h" // 新闹钟
#import "AnotherSportVC.h" // Another 运动

#import "HomeSelectedCell.h" // 首页界面 myCollectionView 的 自定义 cell

#endif


#endif /* Constants_h */
