//
//  HMMCustomCircleView.h
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMCustomCircleView : UIView // 自定义彩色圆环界面

@property (nonatomic, assign) CGFloat personOf; // 个人完成步数
@property (nonatomic, assign) NSInteger totle; // 个人目标步数

- (void)startAnimating;
- (void)stopAnimating;

@end