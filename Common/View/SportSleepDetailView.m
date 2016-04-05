//
//  SportSleepDetailView.m
//  Common
//
//  Created by QFITS－iOS on 16/2/29.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SportSleepDetailView.h"

@implementation SportSleepDetailView


+ (instancetype) detailViewWithFrame:(CGRect)frame
{
    SportSleepDetailView* view = (SportSleepDetailView*)[[[NSBundle mainBundle] loadNibNamed:@"SportSleepDetail" owner:nil options:nil] lastObject];
    view.frame = frame;
    return view;
}

- (void)awakeFromNib
{
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}



@end
