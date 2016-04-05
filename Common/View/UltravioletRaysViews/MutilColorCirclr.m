//
//  MutilColorCirclr.m
//  Common
//
//  Created by HuMingmin on 16/3/1.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "MutilColorCirclr.h"

#import <QuartzCore/QuartzCore.h>
#import <math.h>

@implementation MutilColorCirclr

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
    CGContextRef myCtx = UIGraphicsGetCurrentContext();
    
    
    CGContextSetLineWidth(myCtx, 1);
    
    CGContextSetAllowsAntialiasing(myCtx, true); // 去锯齿
    CGContextSetShouldAntialias(myCtx, true);
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (58 + ((108 - 58) / 45.0) * i) / 255.0, (237 + ((243 - 237) / 45.0) * i) / 255.0, (245 - ((245 - 152) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (i - 45) * M_PI / 180, ((i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 58 + ((108 - 58) / 45.0) * i);
//        NSLog(@"%lf", 237 + ((243 - 237) / 45.0) * i);
//        NSLog(@"%lf", 245 - ((245 - 152) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (108 - ((108 - 55) / 45.0) * i) / 255.0, (243 - ((243 - 217) / 45.0) * i) / 255.0, (152 + ((178 - 152) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (45 + i - 45) * M_PI / 180, ((45 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 108 - ((108 - 55) / 45.0) * i);
//        NSLog(@"%lf", 243 - ((243 - 217) / 45.0) * i);
//        NSLog(@"%lf", 152 + ((178 - 152) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (55 + ((186 - 55) / 45.0) * i) / 255.0, (217 - ((217 - 211) / 45.0) * i) / 255.0, (178 - ((178 - 103) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (90 + i - 45) * M_PI / 180, ((90 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 55 + ((186 - 55) / 45.0) * i);
//        NSLog(@"%lf", 217 - ((217 - 211) / 45.0) * i);
//        NSLog(@"%lf", 178 - ((178 - 103) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (186 + ((234 - 186) / 45.0) * i) / 255.0, (211 - ((211 - 203) / 45.0) * i) / 255.0, (103 - ((103 - 61) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (135 + i - 45) * M_PI / 180, ((135 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 186 + ((234 - 186) / 45.0) * i);
//        NSLog(@"%lf", 211 - ((211 - 203) / 45.0) * i);
//        NSLog(@"%lf", 103 - ((103 - 61) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (234 - ((234 - 167) / 45.0) * i) / 255.0, (203 - ((203 - 29) / 45.0) * i) / 255.0, (61 + ((95 - 61) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (180 + i - 45) * M_PI / 180, ((180 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 234 - ((234 - 167) / 45.0) * i);
//        NSLog(@"%lf", 203 - ((203 - 29) / 45.0) * i);
//        NSLog(@"%lf", 61 + ((95 - 61) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (167 - ((167 - 91) / 45.0) * i) / 255.0, (29 + ((71 - 29) / 45.0) * i) / 255.0, (95 + ((168 - 95) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (225 + i - 45) * M_PI / 180, ((225 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 167 - ((167 - 91) / 45.0) * i);
//        NSLog(@"%lf", 29 + ((71 - 29) / 45.0) * i);
//        NSLog(@"%lf", 95 + ((168 - 95) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (91 - ((91 - 84) / 45.0) * i) / 255.0, (71 + ((236 - 71) / 45.0) * i) / 255.0, (168 + ((246 - 168) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (270 + i - 45) * M_PI / 180, ((270 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 91 - ((91 - 84) / 45.0) * i);
//        NSLog(@"%lf", 71 + ((236 - 71) / 45.0) * i);
//        NSLog(@"%lf", 168 + ((246 - 168) / 45.0) * i);
//        NSLog(@"\n");
    }
    
    for (NSInteger i = 0; i <= 45; i ++) { // 79 237 117、0 156 246
        CGContextSetRGBFillColor(myCtx, (84 - ((84 - 58) / 45.0) * i) / 255.0, (236 + ((236 - 237) / 45.0) * i) / 255.0, (246 - ((246 - 245) / 45.0) * i) / 255.0, 1);
        CGContextSetRGBStrokeColor(myCtx, 1.0, 0.0, 1.0, 0);
        CGContextMoveToPoint(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextAddArc(myCtx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, 100,  (315 + i - 45) * M_PI / 180, ((315 + i - 45) + 2) * M_PI / 180, 0);
        CGContextClosePath(myCtx);
        CGContextDrawPath(myCtx, kCGPathFillStroke); //绘制路径
        
//        NSLog(@"%lf", 84 - ((84 - 58) / 45.0) * i);
//        NSLog(@"%lf", 236 + ((236 - 237) / 45.0) * i);
//        NSLog(@"%lf", 246 - ((246 - 245) / 45.0) * i);
//        NSLog(@"\n");
    }
    
}

- (CGPoint)pointOnInnerCircleWithAngel:(NSInteger)angel {
    CGFloat r = self.frame.size.height / 2.0 / 1.12;
    CGFloat cx = self.frame.size.width / 2.0;
    CGFloat cy = self.frame.size.height / 2.0;
    CGFloat x = cx + r * cos(M_PI / 180 * angel);
    CGFloat y = cy + r * sin(M_PI / 180 * angel);
    return CGPointMake(x, y);
} // 圆环内点的角度
- (CGPoint)pointOnOuterCircleWithAngel:(NSInteger)angel {
    CGFloat r = self.frame.size.height / 2.0;
    CGFloat cx = self.frame.size.width / 2.0;
    CGFloat cy = self.frame.size.height / 2.0;
    CGFloat x = cx + r * cos(M_PI / 180 * angel);
    CGFloat y = cy + r * sin(M_PI / 180 *angel);
    return CGPointMake(x, y);
} // 圆环外点的角度

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
} // 初始化自定义 View 的大小

@end
