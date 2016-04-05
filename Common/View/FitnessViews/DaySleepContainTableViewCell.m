//
//  DaySleepContainTableViewCell.m
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "DaySleepContainTableViewCell.h"

@interface DaySleepContainTableViewCell ()

@property (nonatomic, strong) UIView *myBackView; // 柱状图

@end

@implementation DaySleepContainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    if (_isSportVC) {
        [self.myBackView removeFromSuperview];
        self.myBackView = nil;
        self.myBackView = [UIView new];
        self.myBackView.backgroundColor = _cellColor;
        CGFloat distance = _cellHeight;
        self.myBackView.frame = CGRectMake(self.bounds.size.width - distance, 0, distance, self.bounds.size.height / 2.0);
        [self addSubview:_myBackView];
    } else {
        //    self.backgroundColor = [UIColor clearColor];
        
        [self.myBackView removeFromSuperview];
        self.myBackView = nil;
        self.myBackView = [UIView new];
        self.myBackView.backgroundColor = _cellColor;
        //    int distance = arc4random_uniform((int)self.bounds.size.width);
        CGFloat distance = _cellHeight;
        self.myBackView.frame = CGRectMake(self.bounds.size.width - distance, 0, distance, self.bounds.size.height);
        [self addSubview:_myBackView];
    }
}

@end
