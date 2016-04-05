//
//  HMMCustomCircleView.m
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "HMMCustomCircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "math.h"

static int stage = 0;

@interface HMMCustomCircleView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat baifebBi;

@end

@implementation HMMCustomCircleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.totle = 100;
        self.personOf = 67;
        self.baifebBi = 0.0;
    }
    return self;
    
}

-(void)test {
    
}
- (void)startAnimating {
    if (!self.timer.isValid) {
        [_timer invalidate];
        self.timer =[NSTimer timerWithTimeInterval:0.03f target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    self.hidden = NO;
    
    stage++;
}

-(void) stopAnimating {
    self.hidden = YES;
    [self.timer invalidate];
}
- (UIColor *)getColorForStage:(int)currentStage WithAlpha:(double)alpha
{
    int max = 120;
    int cycle = currentStage % max;
    
    //    if (cycle < max / 4) {
    //        return [UIColor colorWithRed:66.0/255.0 green:72.0/255.0 blue:101.0/255.0 alpha:alpha];
    //    } else if (cycle < max / 4 * 2) {
    //        return [UIColor colorWithRed:238.0/255.0 green:90.0/255.0 blue:40.0/255.0 alpha:alpha];
    //    } else if (cycle < max / 4 * 3) {
    //        return [UIColor colorWithRed:33.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:alpha];
    //    } else  {
    //        return [UIColor colorWithRed:251.0/255.0 green:184.0/255.0 blue:18.0/255.0 alpha:alpha];
    //    }
    

    if (cycle < max * (_baifebBi)) {
        float rate = currentStage % 120;
        rate = rate / (_baifebBi);
        
        if (_baifebBi >= (_personOf / _totle)) {
            [_timer invalidate];
        }
        
        if (_baifebBi >= 1.0f) {
            [_timer invalidate];
        }
//        return [UIColor colorWithRed:((79 / 120.0) * rate) / 255 green:(237 - ((237 - 156) / 120.0) * rate) / 255 blue:(117 + ((246 - 117) / 120.0) * rate) / 255 alpha:alpha];
        
        if (_personOf <= 0) {
         float rate = currentStage % 120;
         return [UIColor colorWithRed:((79 / 120.0) * rate) / 255 green:(237 - ((237 - 156) / 120.0) * rate) / 255 blue:(117 + ((246 - 117) / 120.0) * rate) / 255 alpha:0.3];
         } else {
         return [UIColor colorWithRed:((79 / 120.0) * rate) / 255 green:(237 - ((237 - 156) / 120.0) * rate) / 255 blue:(117 + ((246 - 117) / 120.0) * rate) / 255 alpha:alpha];
         }
    } else {
        float rate = currentStage % 120;
        return [UIColor colorWithRed:((79 / 120.0) * rate) / 255 green:(237 - ((237 - 156) / 120.0) * rate) / 255 blue:(117 + ((246 - 117) / 120.0) * rate) / 255 alpha:0.3];
    }
    
    // 79 237 117、0 156 246
    
}
- (CGPoint)pointOnInnerCirecleWithAngel:(int)angel {
    double r = self.frame.size.height / 2 / 1.12;
    double cx = self.frame.size.width / 2;
    double cy = self.frame.size.height / 2;
    double x = cx + r * cos(M_PI / 60 * angel + 45.55);
    double y = cy + r * sin(M_PI / 60 * angel + 45.55);
    return CGPointMake(x, y);
}
- (CGPoint)pointOnOuterCirecleWithAngel:(int)angel {
    double r = self.frame.size.height / 2;
    double cx = self.frame.size.width / 2;
    double cy = self.frame.size.height / 2;
    double x = cx + r * cos(M_PI / 60 * angel + 45.55);
    double y = cy + r * sin(M_PI / 60 * angel + 45.55);
    return CGPointMake(x, y);
}

- (void)drawRect:(CGRect)rect {
    CGPoint point;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    
    for (int i = 0 ; i < 120; ++i) {
        CGContextSetStrokeColorWithColor(ctx, [[self getColorForStage:stage + i WithAlpha:1.0f] CGColor]);
        point = [self pointOnOuterCirecleWithAngel:stage + i];
        CGContextMoveToPoint(ctx, point.x, point.y);
        point = [self pointOnInnerCirecleWithAngel:stage + i];
        CGContextAddLineToPoint(ctx, point.x, point.y);
        CGContextStrokePath(ctx);
    }
    _baifebBi += 0.01;
    //    stage++;
}

@end
