//
//  CustomViewUtil.h
//  Common
//
//  Created by QFITS－iOS on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomViewUtil : NSObject
+ (UIView*)autoTimingSelectorView;
+ (UIView*)timeZoneLabelView:(CGRect)frame;
+ (UIView*)connectFailedView;
+ (UIView*)requestAuthorizedView;
@end
