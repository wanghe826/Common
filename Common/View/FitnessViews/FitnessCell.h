//
//  FitnessCell.h
//  Common
//
//  Created by HMM－MACmini on 16/1/15.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

// typedef void (^BlockOfStopAMoment) (void);

@interface FitnessCell : UITableViewCell

// @property (nonatomic, strong) BlockOfStopAMoment myBlockOfStopAMoment;

- (void)refreshUI:(NSMutableArray *)mutArr andMaxElem:(NSInteger)maxElem andIndex:(NSIndexPath *)indexPath; // 刷新 UI

@end
