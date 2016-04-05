//
//  BackgroundCharView.h
//  Common
//
//  Created by QFITS－iOS on 16/2/29.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundChartView : UIView

@property (assign, nonatomic) BOOL labelHidden;
@property (assign, nonatomic) NSUInteger row;
@property (assign, nonatomic) NSUInteger column;

@property (nonatomic, assign) BOOL isLabelOuter; // label 显示是否在外面

@end
