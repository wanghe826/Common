//
//  SMDeviceModel.h
//  Common
//
//  Created by QFITS－iOS on 16/1/9.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDeviceModel : NSObject<NSCoding>
@property (strong, nonatomic) NSString *identifier;             //uuid
@property (strong, nonatomic) NSString *name;                   //name
@property (strong, nonatomic) NSNumber *rssi;                   //信号强度
@end
