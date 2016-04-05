//
//  CustomViewUtil.m
//  Common
//
//  Created by QFITS－iOS on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "CustomViewUtil.h"

@implementation CustomViewUtil

+ (UIView*)autoTimingSelectorView {
    return [[[NSBundle mainBundle] loadNibNamed:@"AutoTimingSelectorView" owner:nil options:nil] lastObject];
}

+ (UIView*)timeZoneLabelView:(CGRect)frame {
    UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"TimeZoneLabel" owner:nil options:nil] lastObject];
    view.frame = frame;
    return view;
}

+ (UIView*)connectFailedView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ConnectFailedView" owner:nil options:nil] lastObject];
}

+ (UIView*)requestAuthorizedView {
   return [[[NSBundle mainBundle] loadNibNamed:@"RequestAuthorizedView" owner:nil options:nil] lastObject];
}

@end
