//
//  FitnessVC.m
//  Common
//
//  Created by HMM－MACmini on 16/1/14.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "FitnessVC.h"
#import "Constants.h"
#import "FitnessCell.h"

@interface FitnessVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableTableView; // 用来承接表格的UITableView、不错的想法
@property (nonatomic, strong) NSMutableArray *mutArrOfData; // 数据源
@property (nonatomic, assign) NSInteger maxElem; // 最大数据值
@property (nonatomic, strong) UIView *myBackView; // 柱状图

@property (nonatomic, assign) CGFloat lastScale;

@end

@implementation FitnessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; // 设置self.view的背景颜色
    
    [self requestData]; // 请求数据
    [self createMyTableTableView]; // 创建 myTableTableView
    
    UILongPressGestureRecognizer *myLongPressGus = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPresstableView:)];
    [self.myTableTableView addGestureRecognizer:myLongPressGus];
    
    UIPinchGestureRecognizer *myPanGus = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pantableView:)];
    [self.myTableTableView addGestureRecognizer:myPanGus];
}

- (void)longPresstableView:(UILongPressGestureRecognizer *)sender {
    
//    if ([sender state] == UIGestureRecognizerStateBegan) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.myTableTableView.center = [sender locationInView:self.view];
//        } completion:^(BOOL finished) {
//            
//        }];
//    } else {
//        self.myTableTableView.center = [sender locationInView:self.view];
//    }
    
    CGPoint point;
    CGAffineTransform currentTransform = [sender view].transform;
    if ([sender state] == UIGestureRecognizerStateBegan) {
        point = CGPointMake([sender locationInView:self.view].x, [sender locationInView:self.view].y);
    }
//    CGAffineTransform newTransform = CGAffineTransformTranslate(currentTransform, [sender locationInView:self.view].x - point.x, [sender locationInView:self.view].y - point.y);
//    [[sender view] setTransform:newTransform];
    kLog(@"%lf", [sender locationInView:self.view].x - point.x);
}

- (void)pantableView:(UIPinchGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }

    //当手指离开屏幕时,将lastscale设置为1.0
    if([sender state] == UIGestureRecognizerStateEnded) {
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [sender scale]);
    CGAffineTransform currentTransform = [sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [[sender view] setTransform:newTransform];
    _lastScale = [sender scale];

}

- (void)requestData {
#if 1 // 假数据
    if (!_mutArrOfData) {
        _mutArrOfData = [NSMutableArray array];
        for (NSInteger i = 0; i < 30000; i ++) {
            [_mutArrOfData addObject:@{[NSString stringWithFormat:@"第%03ld", i]:[NSString stringWithFormat:@"%d", arc4random_uniform(30000)]}];
        }
    }
    
    NSMutableArray *mutArrOfAllObject = [NSMutableArray array];
    for (NSInteger i = 0; i < _mutArrOfData.count; i ++) {
        [mutArrOfAllObject addObject:[_mutArrOfData[i] allObjects][0]];
    }
    self.maxElem = [self maxDataElem:mutArrOfAllObject]; // 最大数据值
#else // 真实数据
    
#endif
} // 请求数据

- (NSInteger)maxDataElem:(NSMutableArray *)wantMutArr {
    for (NSInteger i = 0; i < wantMutArr.count - 1; i ++) {
        if (i == 1) {
            break;
        }
        for (NSInteger j = i; j < wantMutArr.count - 1; j ++) {
            NSInteger elem1 = [wantMutArr[i] integerValue];
            NSInteger elem2 = [wantMutArr[j + 1] integerValue];
            if (elem1 < elem2) {
                [wantMutArr exchangeObjectAtIndex:i withObjectAtIndex:j + 1];
            }
        }
    }
    return [wantMutArr[0] integerValue];
} // 计算某个数组最大数据值

- (void)createMyTableTableView {
    self.myTableTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 + 0.5 * (kScreenWidth - 0 * 2 - 200), 100 - 0.5 * (kScreenWidth - 0 * 2 - 200), 200, kScreenWidth - 0 * 2) style:UITableViewStylePlain];
    self.myTableTableView.transform = CGAffineTransformMakeRotation(M_PI_2);
    // self.myTableTableView.backgroundColor = [UIColor redColor];
    self.myTableTableView.delegate = self;
    self.myTableTableView.dataSource = self;
    self.myTableTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    self.myTableTableView.sectionHeaderHeight = 7.5;
//    self.myTableTableView.sectionFooterHeight = 7.5;
    self.myTableTableView.rowHeight = (self.myTableTableView.frame.size.width - 0 * 2 - 7.5 * 2 * 7) / 7.0;
    self.myTableTableView.pagingEnabled = YES;
    self.myTableTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.myTableTableView];
} // 创建 myTableTableView

#pragma mark - 
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
} // row

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutArrOfData.count;
} // section

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strOfReusableID = @"FitnessCell";
    FitnessCell *cell = [tableView dequeueReusableCellWithIdentifier:strOfReusableID];
    if (cell == nil) {
        cell = [[FitnessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOfReusableID];
    }
    
    [cell refreshUI:self.mutArrOfData andMaxElem:self.maxElem andIndex:indexPath];

//    cell.backgroundColor = [UIColor greenColor];
    cell.transform = CGAffineTransformMakeTranslation(-200 * (arc4random_uniform(2) == 0 ? -1 : 1), 0);
    cell.transform = CGAffineTransformMakeScale(1 * (arc4random_uniform(2) == 0 ? 0 : 2), 1 * (arc4random_uniform(2) == 0 ? 0 : 2));
    [UIView animateWithDuration:1.0f animations:^{
        cell.transform = CGAffineTransformMakeTranslation(0, 0);
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
} // cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
} // selected cell

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5;
} // header height

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7.5;
} // footer heght

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.alpha = 0;
    return myView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.alpha = 0;
    return myView;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    kLog(@"%lf", scrollView.contentOffset.y);
}

/**
 *  绘图方法、、、
 */

/*
 
 
 @property (nonatomic, strong) NSMutableArray *mutAtt; // 数据源
 @property (nonatomic, assign) NSInteger maxElem; // 最大数据值
 
 @property (nonatomic, strong) CALayer *layer1;
 @property (nonatomic, strong) CALayer *layer2;
 @property (nonatomic, strong) CALayer *layer3;
 
 @property (nonatomic, assign) CGContextRef myCGContextRef;
 
 [self requestData]; // 请求数据
 [self creatMyScrollView]; // 创建展示数据的 UIScrollView
 
- (void)requestData {
#if 1 // 假数据
    if (!_mutAtt) {
        _mutAtt = [NSMutableArray array];
        for (NSInteger i = 0; i < 200; i ++) {
            [_mutAtt addObject:@{[NSString stringWithFormat:@"第%03ld", i]:[NSString stringWithFormat:@"%d", arc4random_uniform(30000)]}];
        }
    }
    
    NSMutableArray *mutArrOfAllObject = [NSMutableArray array];
    for (NSInteger i = 0; i < _mutAtt.count; i ++) {
        [mutArrOfAllObject addObject:[_mutAtt[i] allObjects][0]];
    }
    self.maxElem = [self maxDataElem:mutArrOfAllObject]; // 最大数据值
#else // 真实数据
    
#endif
} // 请求数据

- (NSInteger)maxDataElem:(NSMutableArray *)wantMutArr {
    for (NSInteger i = 0; i < wantMutArr.count - 1; i ++) {
        if (i == 2) {
            break;
        }
        for (NSInteger j = i; j < wantMutArr.count - 1; j ++) {
            NSInteger elem1 = [wantMutArr[i] integerValue];
            NSInteger elem2 = [wantMutArr[j + 1] integerValue];
            if (elem1 < elem2) {
                [wantMutArr exchangeObjectAtIndex:i withObjectAtIndex:j + 1];
            }
        }
    }
    return [wantMutArr[0] integerValue];
} // 计算最大数据值

- (void)creatMyScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth - 15 * 2, 200)];
    myScrollView.tag = 1;
    myScrollView.pagingEnabled = YES;
    myScrollView.backgroundColor = [UIColor redColor];
    myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width * (_mutAtt.count / 7 + ((_mutAtt.count % 7 == 0) ? 0 : 1)), myScrollView.frame.size.height);
    [self.view addSubview:myScrollView];
    [self drawPic:myScrollView];
} // 创建展示数据的 UIScrollView

- (void)drawPic:(UIScrollView *)wantScrollView {
    
    CALayer *caLayer1 = [CALayer layer]; // 实例化 caLayer1
    caLayer1.backgroundColor = [UIColor whiteColor].CGColor;
    caLayer1.frame = CGRectMake(0, 0, wantScrollView.contentSize.width, wantScrollView.contentSize.height);
    caLayer1.delegate = self;
    caLayer1.name = @"caLayer1";
    [caLayer1 setNeedsDisplay]; // caLayer1 调用 setNeedsDisplay 来绘制自己的界面
    
    CALayer *caLayer2 = [CALayer layer];
    caLayer2.backgroundColor = [UIColor redColor].CGColor;
    caLayer2.frame = CGRectMake(30, 170, 100, 100);
    caLayer2.delegate = self;
    caLayer2.name = @"caLayer2";
    [caLayer2 setNeedsDisplay];
    
    CALayer *caLayer3 = [CALayer layer];
    caLayer3.backgroundColor = [UIColor greenColor].CGColor;
    caLayer3.frame = CGRectMake(30, 170, 100, 100);
    caLayer3.delegate = self;
    caLayer3.name = @"caLayer3";
    [caLayer3 setNeedsDisplay];
    
    [wantScrollView.layer addSublayer:caLayer1];
    
    self.layer1 = caLayer1;
    self.layer2 = caLayer2;
    self.layer3 = caLayer3;
    
} // CGContextRef 绘图

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    self.myCGContextRef = ctx; // 创建指针
    if (layer == self.layer1) {
        CGContextSetAllowsAntialiasing(ctx, false);
        CGContextSetShouldAntialias(ctx, false); // 去除锯齿
        for (NSInteger i = 0; i < self.mutAtt.count; i ++) {
            CGRect myRect = CGRectMake(20 * (i / 7 + 1) + ((kScreenWidth - 15 * 2 - 20 * 8) / 7 + 20) * i, 30 + (100 - 100 * ([[_mutAtt[i] allObjects][0] floatValue] / _maxElem)), (kScreenWidth - 15 * 2 - 20 * 8) / 7, 100 * ([[_mutAtt[i] allObjects][0] floatValue] / _maxElem));
            CGContextAddRect(ctx,myRect); // 画方框
            CGContextSetLineWidth(ctx, 0.0); // 方框边缘线的宽度
            CGContextSetFillColorWithColor(ctx, kRandomColor(0.85).CGColor); // 填充颜色，默认黑色
            CGContextSetStrokeColorWithColor(ctx, kHexRGBAlpha(0x2412aa, 1.0).CGColor); // 边框颜色，默认黑色
            CGContextDrawPath(ctx, kCGPathFillStroke); // 绘画路径
        } // 一次性创建所有

        for (NSInteger i = 0; i < self.mutAtt.count; i ++) {
            CGRect myRect = CGRectMake(20 * (i / 7 + 1) + ((kScreenWidth - 15 * 2 - 20 * 8) / 7 + 20) * i, 30, (kScreenWidth - 15 * 2 - 20 * 8) / 7, 100);
            if (i == 2) {
                CGContextClearRect(_myCGContextRef, myRect);
                
                break;
            }
        } // 可以用来改变特定
    }
    
}

- (void)dealloc {
    
    [self.layer1 removeFromSuperlayer];
    [self.layer2 removeFromSuperlayer];
    [self.layer3 removeFromSuperlayer];
   
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
