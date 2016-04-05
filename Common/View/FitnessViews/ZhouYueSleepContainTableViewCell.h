//
//  ZhouYueSleepContainTableViewCell.h
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhouYueSleepContainTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isZhou; // 判断是周还是月

@property (nonatomic, assign) NSInteger mounthDay; // 该月份的天数

@property (nonatomic, strong) NSMutableArray *mutArrOfT; // 传入数据
@property (nonatomic, strong) NSIndexPath *myIndex; // 传入位置
@property (nonatomic, assign) BOOL isSportVC; // 是否是运动界面

- (void)refreshUI:(NSIndexPath *)indexPath; // 刷新 UI 操作
- (void)refreshUIA:(NSIndexPath *)indexPathA; // 刷新 UI 操作

@end
