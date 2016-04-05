//
//  SMDeviceModel.m
//  Common
//
//  Created by QFITS－iOS on 16/1/9.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SMDeviceModel.h"

@implementation SMDeviceModel
-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.rssi = [aDecoder decodeObjectForKey:@"rssi"];
    }
    return (self);
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_identifier forKey:@"identifier"];
    [aCoder encodeObject:_rssi forKey:@"rssi"];
}

-(NSString*) description {
    return self.name;
}
@end
