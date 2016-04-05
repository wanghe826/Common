//
//  NSArray+Swizzle.m
//  Common
//
//  Created by QFITS－iOS on 16/3/17.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "NSArray+Swizzle.h"

@implementation NSArray (Swizzle)

- (id) myLastObject
{
    id ret = [self myLastObject];
    return ret;
}
@end
