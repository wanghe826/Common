//
//  FitnessCell.m
//  Common
//
//  Created by HMM－MACmini on 16/1/15.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "FitnessCell.h"
#import "VWWWaterView.h"

@interface FitnessCell ()

@property (nonatomic, strong) VWWWaterView *myBackView; // 柱状图
@property (nonatomic, strong) UILabel *myBackLabel; // 标签

@property (nonatomic, strong) NSMutableArray *mutArrOfData; // 数据源
@property (nonatomic, assign) NSInteger maxElem; // 最大数据值
@property (nonatomic, strong) NSIndexPath *indexPath;



@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation FitnessCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [self.myBackView removeFromSuperview];
    self.myBackView = nil;
    self.myBackView = [VWWWaterView new];
    self.myBackView.frame = CGRectMake(20 + (self.frame.size.width - 20 - 100 * ([[self.mutArrOfData[self.indexPath.section] allObjects][0] floatValue] / self.maxElem)), 0, 100 * ([[self.mutArrOfData[self.indexPath.section] allObjects][0] floatValue] / self.maxElem), self.frame.size.height);
    self.myBackView.transform = CGAffineTransformMakeRotation(M_PI_2 * 3);
    
    self.myBackView.frame = CGRectMake(self.myBackView.frame.origin.x, self.myBackView.frame.origin.y, 100 * ([[self.mutArrOfData[self.indexPath.section] allObjects][0] floatValue] / self.maxElem), self.frame.size.height);
    self.myBackView.center = CGPointMake(self.center.x, 0);
    self.myBackView.frame = CGRectMake(self.myBackView.frame.origin.x + self.myBackView.frame.size.width / 2.0 + (100 - 100 * ([[self.mutArrOfData[self.indexPath.section] allObjects][0] floatValue] / self.maxElem)), self.myBackView.frame.origin.y + self.frame.size.height / 2.0, self.myBackView.frame.size.width, self.myBackView.frame.size.height);
    
    // _myBackView.backgroundColor = kRandomColor(1.0);
    [self addSubview:_myBackView];
    
    
    //初始化渐变层
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.myBackView.bounds;
    [self.myBackView.layer addSublayer:self.gradientLayer];
    //设置渐变颜色方向
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //设定颜色组
    self.gradientLayer.colors = @[(__bridge id)kHexRGBAlpha(0xEFBEBD, 0.0).CGColor,
                                  (__bridge id)kHexRGBAlpha(0x8496c8, 1.0).CGColor];
    //设定颜色分割点
    self.gradientLayer.locations = @[@(0.2f) ,@(1.0f)];
    
    /*
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                  target:self
                                                selector:@selector(TimerEvent)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)TimerEvent
{
    //定时改变颜色
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor colorWithRed:arc4random() % 255 / 255.0
                                                               green:arc4random() % 255 / 255.0
                                                                blue:arc4random() % 255 / 255.0
                                                               alpha:1.0].CGColor];
    
    //定时改变分割点
    self.gradientLayer.locations = @[@(arc4random() % 10 / 10.0f), @(1.0f)];
}
*/
    
    
    
    [self.myBackLabel removeFromSuperview];
    self.myBackLabel = nil;
    self.myBackLabel = [UILabel new];
    self.myBackLabel.frame  =CGRectMake(0, 0, 30, self.frame.size.height);
    self.myBackLabel.transform = CGAffineTransformMakeRotation(M_PI_2 * 3);
    self.myBackLabel.text = [[self.mutArrOfData[self.indexPath.section] allObjects][0] stringByAppendingString:@"步"];
    self.myBackLabel.adjustsFontSizeToFitWidth = YES;
    self.myBackLabel.font = [UIFont systemFontOfSize:7];
    self.myBackLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.myBackLabel];
}

- (void)refreshUI:(NSMutableArray *)mutArr andMaxElem:(NSInteger)maxElem andIndex:(NSIndexPath *)indexPath {
    self.mutArrOfData = [NSMutableArray arrayWithArray:mutArr];
    self.maxElem = maxElem;
    self.indexPath = indexPath;
} // 刷新 UI

@end
