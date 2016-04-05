//
//  DaySleepContainTableView.h
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaySleepContainTableView : UIView // 睡眠界面中包涵柱状图的自定义 View

@property (assign, nonatomic) BOOL labelHidden;
@property (assign, nonatomic) NSUInteger row;
@property (assign, nonatomic) NSUInteger column;

@property (nonatomic, assign) BOOL isLabelOuter; // label 显示是否在外面
@property (nonatomic, assign) BOOL isSportVC; // 是否是运动界面

@end
