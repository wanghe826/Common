//
//  DivingVC.m
//  Common
//
//  Created by HuMingmin on 16/3/2.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "DivingVC.h"

#import "BackgroundChartView.h" // 自定义表格视图

@interface DivingVC ()

@property (nonatomic, strong) CALayer *myLayer; // 上方详细的 Layer
@property (nonatomic, assign) CGFloat rateOfDevice; // 设备比例
@property (nonatomic, strong) CALayer *myLayerOfChart;

@property (nonatomic, assign) CGPoint myTempPoint;

@end

@implementation DivingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rateOfDevice = (screen_height / 667);
    
    [self initialNavigationbar]; // 重写并初始化 Nav
    
    [self createTopInfoViews];	// 创建登上顶部信息显示
    [self createChartInfo]; // 创建表格 Info
    [self createOtherViews]; // 创建表格 Other
    [self createShareBtn];
}

- (void) initialNavigationbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    self.title = NSLocalizedString(@"潜水", nil);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
}
- (void) createShareBtn
{
    UIButton* shareButton = [self.navigationController.navigationBar viewWithTag:1090];
    if(shareButton)
    {
        shareButton.hidden = NO;
    }
    else
    {
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.tag = 1090;
        [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setFrame:CGRectMake(screen_width - 90, 2, 40, 40)];
        [shareButton setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:shareButton];
    }
    
    UIButton *settingButton = [self.navigationController.navigationBar viewWithTag:1091];
    if(settingButton) {
        settingButton.hidden = NO;
    }
    else {
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setFrame:CGRectMake(screen_width - 44, 10, 25, 25)];
        settingButton.tag = 1091;
        [settingButton setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:settingButton];
    }
}
- (void) settingAction {
    
}

- (void) shareAction {
    
}

/**
 *  创建登上顶部信息显示
 */
- (void)createTopInfoViews {
    // 底部承载 View
    UIView *backInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 10, kScreenWidth, 80)];
    backInfoView.tag = 300;
    backInfoView.backgroundColor = kRandomColor(0.0f);
    [self.view addSubview:backInfoView];
    
    _myLayer = [CALayer layer];
    _myLayer.name = @"humingminTop";
    _myLayer.frame = backInfoView.layer.bounds;
    _myLayer.shadowOpacity = 1.0f;
    _myLayer.delegate = self;
    [_myLayer setNeedsDisplay];
    [backInfoView.layer addSublayer:_myLayer];
    
    
    NSArray *testArr1 = @[@"cloudy day", @"", @"99℃", @" "];
    NSArray *testArr2 = @[@"Current weather", @" ", @"Current temperature", @" "];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        testArr1 = @[@"阴天", @"", @"99℃", @" "];
        testArr2 = @[@"当前天气", @" ", @"当前温度", @" "];
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        for (NSInteger j = 0; j < 2; j ++) {
            UILabel *myLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0 + j * backInfoView.frame.size.width / 2.0, 0 + i * (backInfoView.frame.size.height / 2.0 + 5), backInfoView.frame.size.width / 2.0, backInfoView.frame.size.height / 2.0 / 2.0)];
            myLabel1.backgroundColor = kRandomColor(0.0f);
            myLabel1.textAlignment = NSTextAlignmentCenter;
            myLabel1.font = [UIFont boldSystemFontOfSize:18];
            myLabel1.textColor = kHexRGBAlpha(0x37435d, 1.0f);
            
            myLabel1.numberOfLines = 2;
            myLabel1.adjustsFontSizeToFitWidth = YES;
            
            [backInfoView addSubview:myLabel1];
            if (i == 0) {
                myLabel1.text = testArr1[j];
                if (j == 1) {
                    myLabel1.transform = CGAffineTransformMakeTranslation(0, 45);
                }
            } else {
                myLabel1.text = testArr1[j + 2];
            }
            
            UILabel *myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0 + j * backInfoView.frame.size.width / 2.0, 0 + i * (backInfoView.frame.size.height / 2.0 + 4) + backInfoView.frame.size.height / 2.0 / 2.0 / 2.0 + 7, backInfoView.frame.size.width / 2.0, backInfoView.frame.size.height / 2.0 / 2.0)];
            myLabel2.backgroundColor = kRandomColor(0.0f);
            myLabel2.textAlignment = NSTextAlignmentCenter;
            myLabel2.font = [UIFont boldSystemFontOfSize:10];
            myLabel2.textColor = kHexRGBAlpha(0x323d54, 1.0f);
            [backInfoView addSubview:myLabel2];
            if (i == 0) {
                myLabel2.text = testArr2[j];
            } else {
                myLabel2.text = testArr2[j + 2];
            }
        }
    }
    
    if (kScreenHeight == 480) {
        backInfoView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8f, 0.8f), 0, -15);
    }
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    if ([layer.name isEqualToString:@"humingminTop"]) {
        CGContextSetRGBStrokeColor(ctx, 29 / 255.0, 35 / 255.0, 50 / 255.0, 0.0);
        CGContextSetRGBFillColor(ctx, 29 / 255.0, 35 / 255.0, 50 / 255.0, 0.9);
        CGContextSetLineWidth(ctx, 1.0);
        
        CGContextAddEllipseInRect(ctx, CGRectMake(0, 40, kScreenWidth / 2.0, 1.5));
        CGContextAddEllipseInRect(ctx, CGRectMake(kScreenWidth / 2.0, 0, 1.5, 80));
        CGContextDrawPath(ctx, kCGPathFillStroke);
    } else if ([layer.name isEqualToString:@"humingminChart"]) {
        UIView *myTempView2 = [self.view viewWithTag:301];
        
        CGContextSetLineWidth(ctx, 2);
        CGContextSetAllowsAntialiasing(ctx, true); // 去锯齿
        CGContextSetShouldAntialias(ctx, true);
        
        _myTempPoint = CGPointMake(5 * myTempView2.frame.size.width / 6, 0);
        
        for (NSInteger i = 1; i < 11; i ++) {
            CGContextMoveToPoint(ctx, _myTempPoint.x, _myTempPoint.y);
            
            CGContextSetFillColorWithColor(ctx, kRGBColor(0x0f, 0xb2, 0xe6, 1.0).CGColor);
            CGContextSetStrokeColorWithColor(ctx, kRGBColor(0x0f, 0xb2, 0xe6, 1.0).CGColor);
            
            CGFloat lengths[] = {3, 2};
            CGContextSetLineDash(ctx, 0, lengths, 1);
            CGContextAddLineToPoint(ctx, _myTempPoint.x - 20, 0);
            CGContextStrokePath(ctx);
            
            int tempInt = arc4random_uniform(120);
            
            CGContextMoveToPoint(ctx, _myTempPoint.x - 20, 0);
            CGContextSetLineDash(ctx, 0, 0, 0);
            CGContextAddLineToPoint(ctx, _myTempPoint.x - 20, tempInt);
            CGContextStrokePath(ctx);
            
            CGContextMoveToPoint(ctx, _myTempPoint.x - 20, tempInt);
            CGContextSetLineDash(ctx, 0, 0, 0);
            CGContextAddLineToPoint(ctx, 5 * myTempView2.frame.size.width / 6  - 20 * 2 * i, tempInt);
            CGContextStrokePath(ctx);
            
            CGContextMoveToPoint(ctx, 5 * myTempView2.frame.size.width / 6  - 20 * 2 * i, tempInt);
            CGContextSetLineDash(ctx, 0, 0, 0);
            CGContextAddLineToPoint(ctx, 5 * myTempView2.frame.size.width / 6  - 20 * 2 * i, 0);
            CGContextStrokePath(ctx);
            
            _myTempPoint = CGPointMake(5 * myTempView2.frame.size.width / 6  - 20 * 2 * i, 0);
            
        }
    }
    
}
- (void)dealloc {
    [_myLayer removeFromSuperlayer];
    [_myLayerOfChart removeFromSuperlayer];
}

/**
 *  创建表格 Info
 */
- (void)createChartInfo {
    BackgroundChartView *myBackgroundChartView = [[BackgroundChartView alloc] initWithFrame:CGRectMake(0, 64 + 10 + 80 + 15, kScreenWidth, kScreenWidth / 2.0 + 70)];
    myBackgroundChartView.isLabelOuter = YES;
    myBackgroundChartView.tag = 301;
    myBackgroundChartView.row = 8;
    myBackgroundChartView.column = 6;
    myBackgroundChartView.backgroundColor = kRandomColor(0.0f);
    [self.view addSubview:myBackgroundChartView];
    
    _myLayerOfChart = [CALayer layer];
    _myLayerOfChart.name = @"humingminChart";
    _myLayerOfChart.frame = myBackgroundChartView.layer.bounds;
    _myLayerOfChart.shadowOpacity = 1.0;
    _myLayerOfChart.delegate = self;
    [_myLayerOfChart setNeedsDisplay];
    [myBackgroundChartView.layer addSublayer:_myLayerOfChart];
    
    
    if (kScreenHeight == 480) {
        myBackgroundChartView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0f, 0.85), 0, -30);
    } else if (kScreenHeight == 568) {
        
    } else if (kScreenHeight == 736) {
        
    }
}

/**
 *  创建表格 Other
 */
- (void)createOtherViews {
    UIView *myTempView1 = [self.view viewWithTag:300];
    UIView *myTempView2 = [self.view viewWithTag:301];
    
    UILabel *myShenduLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, myTempView2.frame.size.height + myTempView2.frame.origin.y - 20 + 7, kScreenWidth, 20)];
    myShenduLabel.text = NSLocalizedString(@"深度记录", nil);
    myShenduLabel.textAlignment = NSTextAlignmentCenter;
    myShenduLabel.font = [UIFont boldSystemFontOfSize:12];
    myShenduLabel.textColor = HexRGBAlpha(0xc0c0c0, 1.0f);
    [self.view addSubview:myShenduLabel];
    
    UILabel *myLabelOfSomeInfo = [[UILabel alloc] initWithFrame:CGRectMake(0 + 40, myTempView2.frame.size.height + myTempView2.frame.origin.y + 8 + 7, kScreenWidth - 80, 40)];
    myLabelOfSomeInfo.backgroundColor = kRandomColor(0.0f);
    myLabelOfSomeInfo.numberOfLines = 2;
    myLabelOfSomeInfo.adjustsFontSizeToFitWidth = YES;
    myLabelOfSomeInfo.text = @"Diving too frequently, we recommend that you should take a break appropriately.";
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        myLabelOfSomeInfo.text = @"潜水过于频繁，建议您适当休息。";
    }
    
    myLabelOfSomeInfo.textAlignment = NSTextAlignmentCenter;
    myLabelOfSomeInfo.textColor = kHexRGBAlpha(0x967632, 1.0f);
    myLabelOfSomeInfo.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:myLabelOfSomeInfo];
    
    // 最下方详细详细
    [self createDetailInfoDisplay];
    

    
    if (kScreenHeight == 480) {
        myShenduLabel.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0f, 1.0f), 0, -20);
        myLabelOfSomeInfo.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0f, 1.0f), 0, -15 - 20);
    } else if (kScreenHeight == 568) {
        
    } else if (kScreenHeight == 736) {
        
    }
}
- (void)createDetailInfoDisplay {
    //    140 * _rateOfDevice
    
    NSArray *arrOfType = @[@{@"icon_diving":@"Times of diving"}, @{@"icon_height":@"Total diving"}, @{@"icon_time":@"Total time"}];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        arrOfType = @[@{@"icon_diving":@"下潜次数"}, @{@"icon_height":@"总下潜深度"}, @{@"icon_time":@"总时长"}];
    }
    
    CGFloat distance = kScreenWidth / 3.0;
    for (NSInteger i = 0; i < 3; i ++) {
        
        UIView *myBottomDetialView = [[UIView alloc] initWithFrame:CGRectMake(distance * i, (kScreenHeight - ((140 - 50) * _rateOfDevice)) - (30 + 20 - 25)  * _rateOfDevice - 32, distance, (140 - 50) * _rateOfDevice + (30 + 20)  * _rateOfDevice)];
        myBottomDetialView.backgroundColor = kRandomColor(0.0);
        [self.view addSubview:myBottomDetialView];
        
        // 图片
        UIImageView *myImageViewBase = [[UIImageView alloc] initWithFrame:CGRectMake(distance / 4.0, 0 + 10, distance / 2.0, myBottomDetialView.frame.size.height / 4.0)];
        myImageViewBase.contentMode = UIViewContentModeScaleAspectFit;
        myImageViewBase.image = [UIImage imageNamed:[arrOfType[i] allKeys][0]];
        [myBottomDetialView addSubview:myImageViewBase];
        
        CGFloat insideWidth = myBottomDetialView.frame.size.width;
        CGFloat insderheight = myBottomDetialView.frame.size.height;
        
        // 显示总时长的字样 like
        UILabel *myHourLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 40 - (18) + 15 * _rateOfDevice, insderheight / 2.0 - 20, 40, 40)];
        myHourLable.text = @"10";
        myHourLable.font = [UIFont boldSystemFontOfSize:25];
        myHourLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
        [myBottomDetialView addSubview:myHourLable];
        
        // “时” like
        UILabel *labelOfShi = [[UILabel alloc] initWithFrame:CGRectMake(myHourLable.frame.size.width - 10 * _rateOfDevice, myHourLable.frame.size.height / 2.0 - 5, myHourLable.frame.size.width / 2.0 - 5, myHourLable.frame.size.height / 2.0)];
        labelOfShi.text = NSLocalizedString(@"时", nil);
        labelOfShi.font = [UIFont boldSystemFontOfSize:10];
        labelOfShi.textColor = HexRGBAlpha(0xececec, 1.0);
        [myHourLable addSubview:labelOfShi];
        
        // 显示分长的字样 like
        UILabel *myMinLable = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 + 20 - (18) + 5 * _rateOfDevice, insderheight / 2.0 - 20, 40, 40)];
        myMinLable.text = @"36";
        myMinLable.font = [UIFont boldSystemFontOfSize:26];
        myMinLable.textColor = kHexRGBAlpha(0xececec, 1.0f);
        [myBottomDetialView addSubview:myMinLable];
        
        // “分” like
        UILabel *labelOfFen = [[UILabel alloc] initWithFrame:CGRectMake(myMinLable.frame.size.width - 8 * _rateOfDevice, myMinLable.frame.size.height / 2.0 - 5, myMinLable.frame.size.width / 2.0 - 5, myMinLable.frame.size.height / 2.0)];
        labelOfFen.text = NSLocalizedString(@"分", nil);
        labelOfFen.adjustsFontSizeToFitWidth = YES;
        labelOfFen.font = [UIFont boldSystemFontOfSize:12];
        labelOfFen.textColor = HexRGBAlpha(0xececec, 1.0);
        [myMinLable addSubview:labelOfFen];
        
        // 类型 like
        UILabel *labelOfTarget = [[UILabel alloc] initWithFrame:CGRectMake(insideWidth / 2.0 - 100 / 2.0, insderheight / 2.0 - 40 + 60 - 10, 100, 25)];
        labelOfTarget.text = [arrOfType[i] allObjects][0];
        labelOfTarget.font = [UIFont boldSystemFontOfSize:12];
        labelOfTarget.textColor = HexRGBAlpha(0xe4e4e4, 1.0);
        labelOfTarget.textAlignment = NSTextAlignmentCenter;
        [myBottomDetialView addSubview:labelOfTarget];
        
        if (i == 2) {
            
        } else {
            labelOfFen.alpha = 0;
            myMinLable.alpha = 0;
            
            myHourLable.transform = CGAffineTransformMakeTranslation(28, 0);
            
            if (i == 0) {
                labelOfShi.text = @"";
            } else {
                labelOfShi.text = @"m";
            }
        }
        
        if (kScreenHeight == 480) {
            myBottomDetialView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0, 1.0), 0, 10);
        } else if (kScreenHeight == 568) {
            myBottomDetialView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0, 1.0), 0, 25);
        } else if (kScreenHeight == 736) {

        }
    }
} // 创建下方详细信息接口

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
