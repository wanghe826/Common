//
//  SearchingWatchViewController.h
//  Common
//
//  Created by QFITS－iOS on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "CustomViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SearchTimeout 15
#define ConnectTimeout 15

@interface SearchingWatchViewController : CustomViewController
@property (nonatomic, strong) CBPeripheral* currentPeripheral;
@end
