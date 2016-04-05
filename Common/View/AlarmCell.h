//
//  AlarmCell.h
//  Common
//
//  Created by HMM－MACmini on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnBlockStarTime) (void);
typedef void (^returnBlockStopTime) (void);

@interface AlarmCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *mutArr; // 存放下方选项单位
@property (nonatomic, strong) NSMutableArray *mutArrOfAllInfo;
@property (nonatomic, copy) NSString *strOfImageName;
@property (nonatomic, copy) NSString *strOfSubTitle;
@property (nonatomic, assign) NSInteger numOfSection;
@property (nonatomic, strong) returnBlockStarTime myReturnBlockStarTime;
@property (nonatomic, strong) returnBlockStopTime myReturnBlockStopTime;

- (void)refreshUI:(NSInteger)section; // 刷新 UI Cell

@end
