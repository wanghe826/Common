//
//  DaySleepContainTableView.m
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "DaySleepContainTableView.h"

#import "DaySleepContainTableViewCell.h"

@interface DaySleepContainTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTabelView;

@end

@implementation DaySleepContainTableView

- (id)initWithFrame:(CGRect)frame {
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

- (UITableView *)myTabelView {
    if (!_myTabelView) {
        _myTabelView = [[UITableView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.frame.size.height) / 2.0, -(self.frame.size.width - self.frame.size.height) / 2.0, self.frame.size.height, self.frame.size.width)];
        _myTabelView.delegate = self;
        _myTabelView.dataSource = self;
        _myTabelView.backgroundColor = [UIColor clearColor];
        _myTabelView.scrollEnabled = NO;
    }
    return _myTabelView;
} // 懒加载初始化 myTabelView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self createTableView];
    
    [self drawSomeBackCharts]; // 绘画后方方格背景
}
- (void)drawSomeBackCharts {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetRGBStrokeColor(ctx, 0x16/255.0, 0x18 / 255.0, 0x21 / 255.0, 1.0);
    CGContextBeginPath(ctx);
    
    float originX = (CGRectGetWidth(self.frame)) / _column;
    float originY = CGRectGetHeight(self.frame) / _row;
    
    if (_isLabelOuter) {
        originX = (CGRectGetWidth(self.frame)) / _column;
        for(int m=0; m<=_row - 1; ++m)
        {
            CGContextMoveToPoint(ctx, 0, m*originY);
            CGContextAddLineToPoint(ctx, self.frame.size.width, m * originY);
        }
        
        for (int n = 0; n <= _column; ++n)
        {
            CGContextMoveToPoint(ctx, n*originX, 0);
            CGContextAddLineToPoint(ctx, n * originX, self.frame.size.height - self.frame.size.height / (_row - 1));
        }
    } else {
        for(int m = 0; m <= _row; ++m)
        {
            CGContextMoveToPoint(ctx, 0, m*originY);
            CGContextAddLineToPoint(ctx, self.frame.size.width - 10, m*originY);
        }
        
        for (int n = 0; n <= _column; ++n)
        {
            CGContextMoveToPoint(ctx, n * originX, 0);
            CGContextAddLineToPoint(ctx, n * originX, self.frame.size.height);
        }
    }
    CGContextStrokePath(ctx);
    
    if(_labelHidden) return;
    
    if (_isLabelOuter) {
        //绘制label
        for(int i = 0; i < 5; i++)
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
            attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:8];
            
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
            [style setAlignment:NSTextAlignmentCenter];
            attrs[NSParagraphStyleAttributeName] = style;
            
            [str drawInRect:rect withAttributes:attrs];
        }
    } else {
        NSArray *testArr = @[@"12:00", @"16:00", @"20:00", @"00:00", @"04:00", @"08:00", @"12:00"];
        // 绘制 label
        for(int i = 0; i < 7; i++)
        {
            CGRect rect = CGRectMake(i * originX + 5 - (5 / 2.0), originY * 6 + (5 / 2.0), originX, originY);
            CGContextAddRect(ctx, rect);
            
            NSString *str;
            str = testArr[i];
            
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:8];
            
            NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
            [style setAlignment:NSTextAlignmentCenter];
            attrs[NSParagraphStyleAttributeName] = style;
            
            [str drawInRect:rect withAttributes:attrs];
        }
    }
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

- (void)createTableView {
    [self addSubview:self.myTabelView];
    
    _myTabelView.transform = CGAffineTransformMakeRotation(M_PI_2);
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.frame.size.width) / (7.0 * 4 * 2);
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7 * 4 * 2;
} // row Num
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DaySleepContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDaySleepContainTableViewCell"];
    if (!cell) {
        cell = [[DaySleepContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyDaySleepContainTableViewCell"];
    }
    
    NSArray *testArr = @[HexRGBAlpha(0x19bc9d, 0.6), HexRGBAlpha(0x0687, 0.6), HexRGBAlpha(0xbfa875, 0.6)];
    NSArray *testArrHeight = @[[NSString stringWithFormat:@"%lf", 4 * self.frame.size.height / 7.0], [NSString stringWithFormat:@"%lf", 3 * self.frame.size.height / 7.0], [NSString stringWithFormat:@"%lf", 2 * self.frame.size.height / 7.0]];
    int randowNum = arc4random_uniform(3);
    cell.cellColor = testArr[randowNum];
    cell.cellHeight = [testArrHeight[randowNum] floatValue];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
} // cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
