//
//  BackgroundCharView.m
//  Common
//
//  Created by QFITS－iOS on 16/2/29.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "BackgroundChartView.h"

@implementation BackgroundChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _column = 7;
        _row = 7;
        _labelHidden = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetRGBStrokeColor(ctx, 0x16/255.0, 0x18 / 255.0, 0x21 / 255.0, 1.0);
    CGContextBeginPath(ctx);
    
    float originX = (CGRectGetWidth(self.frame)-10)/_column;
    float originY = CGRectGetHeight(self.frame)/_row;
    
    if (_isLabelOuter) {
        originX = (CGRectGetWidth(self.frame))/_column;
        for(int m=0; m<=_row - 1; ++m)
        {
            CGContextMoveToPoint(ctx, 0, m*originY);
            CGContextAddLineToPoint(ctx, self.frame.size.width, m * originY);
        }
        
        for (int n=0; n<=_column; ++n)
        {
            CGContextMoveToPoint(ctx, n*originX, 0);
            CGContextAddLineToPoint(ctx, n * originX, self.frame.size.height - self.frame.size.height / (_row - 1));
        }
    } else {
        for(int m=0; m<=_row; ++m)
        {
            CGContextMoveToPoint(ctx, 0, m*originY);
            CGContextAddLineToPoint(ctx, self.frame.size.width - 10, m*originY);
        }
        
        for (int n=0; n<=_column; ++n)
        {
            CGContextMoveToPoint(ctx, n*originX, 0);
            CGContextAddLineToPoint(ctx, n*originX, self.frame.size.height);
        }
    }
    
    CGContextStrokePath(ctx);
    
    if(_labelHidden) return;
    
    if (_isLabelOuter) {
        //绘制label
        for(int i=0; i< 5; i++)
        {
            CGRect rect = CGRectMake(i * originX + 5 - (5 / 2.0), originY * 6 + (5 / 2.0) , originX, originY);
            rect = CGRectMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height, rect.size.width, rect.size.height);
            CGContextAddRect(ctx, rect);
            
            NSString* str;
            if(i < 3)
            {
                str = [NSString stringWithFormat:@"0%d:00", i*4];
            }
            else if(i == 5)
            {
                str = [NSString stringWithFormat:@"18:00"];
            }
            else
            {
                str = [NSString stringWithFormat:@"%d:00", i*4];
            }
            
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            // NSForegroundColorAttributeName : 文字颜色
            // NSFontAttributeName : 字体
            attrs[NSForegroundColorAttributeName] = HexRGBAlpha(0x999898, 1.0f);
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
            
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
            [style setAlignment:NSTextAlignmentCenter];
            attrs[NSParagraphStyleAttributeName] = style;
            
            [str drawInRect:rect withAttributes:attrs];
        }
    } else {
        //绘制label
        for(int i=0; i<=6; i++)
        {
            CGRect rect = CGRectMake(i*originX+5 - (5 / 2.0), originY*6 + (5 / 2.0), originX, originY);
            CGContextAddRect(ctx, rect);
            
            NSString* str;
            if(i<3)
            {
                str = [NSString stringWithFormat:@"0%d:00", i*4];
            }
            else if(i==5)
            {
                str = [NSString stringWithFormat:@"18:00"];
            }
            else
            {
                str = [NSString stringWithFormat:@"%d:00", i*4];
            }
            
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            // NSForegroundColorAttributeName : 文字颜色
            // NSFontAttributeName : 字体
            attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:8];
            
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
            [style setAlignment:NSTextAlignmentCenter];
            attrs[NSParagraphStyleAttributeName] = style;
            
            [str drawInRect:rect withAttributes:attrs];
        }
    } // 王鹤大哥
    
}

- (void) setRow:(NSUInteger)row
{
    _row = row;
    [self setNeedsDisplay];
}

- (void) setColumn:(NSUInteger)column
{
    _column = column;
    [self setNeedsDisplay];
}

- (void) setLabelHidden:(BOOL)labelHidden
{
    _labelHidden = labelHidden;
    [self setNeedsDisplay];
}

@end
