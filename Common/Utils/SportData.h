//
//  SportData.h
//  Common
//
//  Created by QFITS－iOS on 16/3/11.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;
@interface SportData : NSObject {
    int _allDataLength;
    CBPeripheral *_peripheral;
    NSDate *_nearDate;
    int _alreadyReceivedPckIndex;
    int _recIndex;
    int _sendIndex;
    
    NSMutableArray *_sportModelsBuffer;
    NSDateFormatter * _dateFormatter;
}

@property (assign, nonatomic) int oneDaySportData;

- (void) fetchAllSportDataLength;

@end
