//
//  ClockSelectedView.h
//  Common
//
//  Created by HuMingmin on 16/3/5.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlockOfSelected)(NSInteger num);
typedef void(^ReturnBlockOfSelectedOfInfo)(NSInteger num);

@interface ClockSelectedView : UIView

@property (nonatomic, strong) NSMutableArray *myLetfToRightEachNumMutArr;

@property (nonatomic, assign) NSInteger selectedNum; // 可以选择的个数

@property (nonatomic, strong) ReturnBlockOfSelected myReturnBlockOfSelected;
@property (nonatomic, strong) ReturnBlockOfSelectedOfInfo myReturnBlockOfSelectedOfInfo;

@property (nonatomic, assign) NSInteger huaDongLeDiJiGe; // 滑动到了第几个
@property (nonatomic, strong) NSMutableArray *tempArrOfHuaDongDiJiGe;

@property (nonatomic, assign) BOOL isSingle; // 是否是贪睡或者说是单个

@end
