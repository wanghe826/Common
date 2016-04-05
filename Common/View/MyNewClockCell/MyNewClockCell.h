//
//  MyNewClockCell.h
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlockIsOn)(BOOL isOn, NSInteger section);

@interface MyNewClockCell : UITableViewCell

@property (nonatomic, copy) ReturnBlockIsOn myReturnBlockIsOn;
@property (nonatomic, strong) NSIndexPath *myIndexPath;

- (void)refreshUI1:(NSMutableArray *)arrOfAllInfo andIndexPath:(NSIndexPath *)indexPath; // 刷新时间显示 UI 数据
- (void)refreshUI2:(NSMutableArray *)arrOfAllSwitch andIndexPath:(NSIndexPath *)indexPath; // 刷新开关显示

@end
