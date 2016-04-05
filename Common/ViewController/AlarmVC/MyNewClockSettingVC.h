//
//  MyNewClockSettingVC.h
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "CustomViewController.h"

typedef void(^ReturnBlockOfAllInfo)(NSMutableArray *arrOfInfo);

@interface MyNewClockSettingVC : CustomViewController

@property (nonatomic, assign) NSInteger numOfSelectedClock; // 选中的闹钟
@property (nonatomic, strong) ReturnBlockOfAllInfo myReturnBlockOfAllInfo; // 回传所有闹钟数据

@end
