//
//  ZhouYueSleepContainTableView.h
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlockOfMaxPageOfZhouOfSport)(NSInteger maxPage);
typedef void(^ReturnBlockOfMaxPageYueOfSport)(NSInteger maxPage);
typedef void(^ReturnBlockOfThisDayStep)(NSString *strOfSteps);
typedef void(^ReturnBlockOfAllDaysSteps)(NSMutableArray *mutArr); // 回传所有步数
typedef void(^ReturnBlockOfAllWeeksArr)(NSMutableArray *mutArr); // 返回所有周的 Arr
typedef void(^ReturnBlockOfAllYueArr)(NSMutableArray *mutArr); // 返回所有月数的 Arr

@interface ZhouYueSleepContainTableView : UIView

@property (nonatomic, assign) BOOL isZhou; // 判断是周还是月

@property (nonatomic, assign) NSInteger mounthDay; // 该月份的天数

@property (nonatomic, strong) NSMutableArray *mySleepData1; // 睡眠需要传入的数据😄
@property (nonatomic, strong) NSMutableArray *mySleepData2; // 睡眠需要传入的数据😄

@property (nonatomic, assign) BOOL isSportVC; // 是否是运动界面
@property (nonatomic, strong) NSMutableArray *myAllDayArr; // 其实只要所有天数的数据

- (void)refreshZhouTabelViewPositionPage:(NSInteger)pageNum; // 刷新数据位置

@property (nonatomic, copy) ReturnBlockOfMaxPageOfZhouOfSport myReturnBlockOfMaxPageOfZhouOfSport; // 返回最大数据页数、周
@property (nonatomic, copy) ReturnBlockOfMaxPageYueOfSport myReturnBlockOfMaxPageYueOfSportt; // 返回最大数据页数、月
@property (nonatomic, copy) ReturnBlockOfThisDayStep myReturnBlockOfThisDayStep; // 返回选择的天数的步数

@property (nonatomic, copy) ReturnBlockOfAllDaysSteps myReturnBlockOfAllDaysSteps; // 回传所有步数

@property (nonatomic, copy) ReturnBlockOfAllWeeksArr myReturnBlockOfAllWeeksArr; // 返回所有周的 Arr
@property (nonatomic, copy) ReturnBlockOfAllYueArr myReturnBlockOfAllYueArr; // 返回所有月的 Arr
@end
