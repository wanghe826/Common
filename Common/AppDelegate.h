//
//  AppDelegate.h
//  Common
//
//  Created by QFITS－iOS on 15/12/22.
//  Copyright © 2015年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BabyBluetooth.h"

#define AuthorizedTimeout 15
#define PairedTimeout 10

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    @public
        NSTimer *_reconnPreDeviceTimer;
}
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) BabyBluetooth *babyBluetooth;
@property (nonatomic, strong) CBPeripheral *currentPeripheral;

@property (nonatomic, strong) NSString *firmwareVersion;
@property (nonatomic, assign) NSUInteger firmwareBattery;

@property (nonatomic, assign) BOOL hasAuthorized;
@property (nonatomic, assign) BOOL hasPaired;
@property (nonatomic, assign) BOOL hasConnected;
@property (nonatomic, assign) BOOL isC007;

@property (nonatomic, strong) NSDictionary *projDic;        // 项目对照表
@property (nonatomic, strong) NSString *productSeries;      // 产品系列

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, assign) BOOL isBLESpecial; // 是否是连接蓝牙界面，然后退出情况


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)startReconnTimer;
- (void)stopReconnTimer;
- (void)resetBLEStatus;
- (void)initialBLEDevice;
- (void)processReceiveBLEData:(NSData *)data;
- (void)playCustomizedSound;

@end

