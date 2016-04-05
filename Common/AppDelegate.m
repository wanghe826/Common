//
//  AppDelegate.m
//  Common
//
//  Created by QFITS－iOS on 15/12/22.
//  Copyright © 2015年 Smartmovt. All rights reserved.
//

#import "AppDelegate.h"
#import "MyFMDBUtil.h"
#import "ViewController.h"

#import <CoreTelephony/CTCallCenter.h> // 电话
#import <CoreTelephony/CTCall.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initSomeAttributes];
    [self startReConnPreDevice];    // 重连设备
    [MyFMDBUtil createTable];
    [self initialBLEDevice];        // 初始化蓝牙设备
    
    return YES;
}

- (void)initSomeAttributes {
    self.babyBluetooth = [BabyBluetooth shareBabyBluetooth];
    
    [[NSBundle mainBundle] pathForResource:@"proj" ofType:@"plist"];
    self.projDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"proj" ofType:@"plist"]];
}

- (void)initialBLEDevice {
    __weak typeof(self) weakSelf = self;
    
    [self.babyBluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"AppDelegate->收到连接成功的通知！！！");
        
        [WriteData2BleUtil checkC007:peripheral.name];
        if(weakSelf.isC007) {
            NSLog(@"AppDelegate->isC007！！！");
            if (_productSeries != nil) {
                NSLog(@"AppDelegate->这是cOO1系列。。。");
            }
        } else {
            NSLog(@"AppDelegate->notC007！！！");
        }

        weakSelf.currentPeripheral = peripheral;
//        [weakSelf stopReconnTimer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
    }]; // 连接成功的通知
    
    [self.babyBluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"AppDelegate->收到蓝牙断开的通知！！！");
        
        [weakSelf.babyBluetooth cancelAllPeripheralsConnection];
        [weakSelf resetBLEStatus];
        [weakSelf startReconnTimer];
        [weakSelf playCustomizedSound];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
       
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"myDeviceSave0"]){
        }
    }]; // 断开连接的通知
    
    [self.babyBluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *ch in service.characteristics) {
            NSLog(@"AppDelegate->DiscovererCh:%@", ch);
            [peripheral setNotifyValue:YES forCharacteristic:ch];
            
            if(weakSelf.isC007) {
                if([ch.UUID.UUIDString isEqualToString:CHANNEL_5.UUIDString]) {
                    [WriteData2BleUtil requestAuthorized:peripheral isForbid:YES];
                }
            } else {
                if([ch.UUID.UUIDString isEqualToString:CHANNEL_5.UUIDString]) {
                    [WriteData2BleUtil requestAuthorized:peripheral isForbid:YES];
                }
            }
        }
    }];
    
    [self.babyBluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"AppDelegate->FROM MCU : %@", characteristic.value);
        
        long valueLength = characteristic.value.length;
        const char* recValue = (char*)[characteristic.value bytes];
        
        // 授权成功
        if(valueLength == 7 && recValue[0] == '$' && recValue[1] == 0x04 && recValue[2] == 0x02 && recValue[3] == 0x0a && recValue[4] == 0x01 && recValue[5] == 0x13) {
            weakSelf.hasAuthorized = YES;
            weakSelf.hasPaired = YES;
            weakSelf.hasConnected = YES;
            [WriteData2BleUtil requestPaired:peripheral];
            
            [WriteData2BleUtil requestVersionBatteryAndSyncSwitch:peripheral]; // 请求电量和版本号
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizedSuccess object:nil];
        }
        
//        [weakSelf stopReconnTimer];
        [weakSelf processReceiveBLEData:characteristic.value];
    }]; // 收到蓝牙发送的命令
    
    [self.babyBluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        switch (central.state) {
            case CBCentralManagerStatePoweredOn:
                NSLog(@"AppDelegate->设备打开了");
                [weakSelf resetBLEStatus];
                [weakSelf startReconnTimer];
                break;
            case CBCentralManagerStatePoweredOff:
                NSLog(@"AppDelegate->设备关闭了");
                [weakSelf resetBLEStatus];
//                [weakSelf stopReconnTimer];
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"AppDelegate->设备不支持");
                break;
            default:
                break;
        }
    }];
}

- (void)startReConnPreDevice {
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:PreConnectedDeviceKey];
    
    if(!data) {
        NSLog(@"AppDelegate->暂时未发现上一个连接设备，请等待。。。");
        return;
    }
    
    NSLog(@"AppDelegate->发现上一个连接设备了，恭喜你！！！");
    SMDeviceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    CBPeripheral *peripheral = nil;
    if(model) {
        NSString *uuidString = model.identifier;
        NSArray *peripherals = [self.babyBluetooth.centralManager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:uuidString]]];
        if(peripherals && peripherals.count != 0) {
            peripheral = peripherals[0];
        }
    }
    _reconnPreDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(reConnPreDevice:) userInfo:peripheral repeats:YES];
    [_reconnPreDeviceTimer fire];
}

- (void)reConnPreDevice:(NSTimer *)timer {
    if(self.hasConnected) {
        NSLog(@"AppDelegate->已经连接了。。。");
        return;
    }
    
    CBPeripheral *peripheral = [timer userInfo];
    if(!peripheral) {
        NSLog(@"AppDelegate->peripheral为空,不重连");
        return;
    }
    
    NSLog(@"AppDelegate->开始重连");
    [self.babyBluetooth cancelAllPeripheralsConnection];
    self.babyBluetooth.having(peripheral).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

- (void)startReconnTimer {
    NSLog(@"AppDelegate->开始重连定时器！！！");
    if(_reconnPreDeviceTimer){
        [_reconnPreDeviceTimer setFireDate:[NSDate distantPast]];
    } else{
        [self startReConnPreDevice];
    }
}

- (void)stopReconnTimer {
    NSLog(@"AppDelegate->停止重连定时器！！！");
    if(_reconnPreDeviceTimer){
        [_reconnPreDeviceTimer setFireDate:[NSDate distantFuture]];
        [_reconnPreDeviceTimer invalidate];
        _reconnPreDeviceTimer = nil;
    }
}

- (void)resetBLEStatus {
    self.currentPeripheral = nil;
    
    self.firmwareVersion = nil;
    self.firmwareBattery = 0;
    
    self.hasAuthorized = NO;
    self.hasPaired = NO;
    self.hasConnected = NO;
    self.isC007 = NO;
}

- (void)processReceiveBLEData:(NSData *)data {
    if(!data) return;
    Byte *bytes = (Byte *)[data bytes];

    // 查找手机的命令
    if((data.length>=6 && bytes[0]=='$' && bytes[1]==0x03 && bytes[2]==0x02 && bytes[3]==0x13 && bytes[4]==0x01 && bytes[5]==0x14) || (bytes[0]==0x23 && bytes[1]==0x01 && bytes[2]==0x04 && bytes[3]==0x013 && bytes[4]==0x87 && bytes[5]==0x08 && bytes[6]==0x01 && bytes[7]==0x01 && bytes[8]==0x01)) [self playCustomizedSound];
    
    // 获取到了电量和版本号
    if(bytes[0]==0x24 && bytes[1]==0x0c && bytes[2]==0x02 && bytes[3]==0x1c && bytes[4]==0x01) {
        Byte version[8] = {bytes[5], bytes[6], bytes[7],bytes[8],bytes[9],bytes[10],bytes[11],bytes[12]};
        NSString* str = [[NSString alloc] initWithBytes:version length:8 encoding:NSUTF8StringEncoding];
        int battery = (int)bytes[13];
        
        self.firmwareBattery = battery;
        self.firmwareVersion = str;
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFirmwareBatteryAndVersion object:nil];
        NSLog(@"AppDelegate->电量是多少:%d", battery);
        NSLog(@"AppDelegate->版本号是多少:%@", str);
    }
    
    // 链接上10S告诉APP我已经链接上了 用于检测是否正确发现服务
    if(bytes[0]==0x24 && bytes[1]==0x04 && bytes[2]==0x02 && bytes[3]==0x1a && bytes[4]==0x01 && bytes[5]==0x02) [WriteData2BleUtil tellMCUAlreadyFindCharacteristic:self.currentPeripheral];
}

- (void)playCustomizedSound {
    SMPlaySound *sound = [[SMPlaySound alloc] init];
    [sound playAlertSound];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.smartmovt.common.Common" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Common" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Common.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
