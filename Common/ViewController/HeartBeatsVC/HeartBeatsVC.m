//
//  HeartBeatsVC.m
//  Common
//
//  Created by HuMingmin on 16/3/3.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "HeartBeatsVC.h"

@interface HeartBeatsVC ()

@property (nonatomic, strong) CALayer *myLayerOfChart;
@property (nonatomic, assign) CGPoint myTempPoint;
@property (nonatomic,assign) BOOL IsPlaying;

@end

@implementation HeartBeatsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialNavigationbar];
    [self createInfoViews]; // 创建 InfoViews
    [self createInfoCharts]; // 创建表格
    [self creteInfoDetailViews]; // 信息详细显示
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createShareBtn];
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

- (void) initialNavigationbar
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    self.title = NSLocalizedString(@"心率", nil);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
}
- (void) settingAction {
    
}

- (void) shareAction {
    
}

/**
 *  创建表格
 */
- (void)createInfoViews {
    NSArray *testArr1 = @[@"Current heart rate", @"Load", @"Average"];
    NSArray *testArr2 = @[@"000", @"99%", @"00"];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        testArr1 = @[@"当前心率", @"负荷", @"平均"];
        testArr2 = @[@"000", @"99%", @"00"];
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        for (NSInteger j = 0; j < 3; j ++) {
            UILabel *myInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + j * kScreenWidth / 3.0, (64 + 32) + 30 * i - 2, kScreenWidth / 3.0, 20 * (i + 1))];
            myInfoLabel.adjustsFontSizeToFitWidth = YES;
            myInfoLabel.backgroundColor = kRandomColor(0.0f);
            myInfoLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
            myInfoLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:myInfoLabel];
            
            if (i == 0) {
                myInfoLabel.text = testArr1[j];
                myInfoLabel.font = [UIFont boldSystemFontOfSize:17];
            } else {
                myInfoLabel.text = testArr2[j];
                if (j == 0) {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:50];
                    myInfoLabel.textColor = kHexRGBAlpha(0xbe7414, 1.0f);
                    
                    UILabel *myDanWeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 3.0 - 20 - 10 + 13, 40 * 2 / 3.0 - 10 + 10, 40, 40 * 1 / 3.0)];
                    myDanWeiLabel.backgroundColor = kRandomColor(0.0f);
                    myDanWeiLabel.font = [UIFont boldSystemFontOfSize:12];
                    myDanWeiLabel.adjustsFontSizeToFitWidth = YES;
                    myDanWeiLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
                    myDanWeiLabel.text = @"BMP";
                    [myInfoLabel addSubview:myDanWeiLabel];

                    
                    if (kScreenHeight == 480) {
                        myInfoLabel.font = [UIFont boldSystemFontOfSize:38];
            
                        myDanWeiLabel.transform = CGAffineTransformMakeTranslation(2, -5);
                    } else if (kScreenHeight == 568) {
                        myInfoLabel.font = [UIFont boldSystemFontOfSize:40];
                        myDanWeiLabel.transform = CGAffineTransformMakeTranslation(2, -5);
                    } else if (kScreenHeight == 736) {
                        
                    }
                } else if (j == 1) {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:40];
                    myInfoLabel.textColor = kHexRGBAlpha(0xbe7414, 1.0f);
                    
                    if (kScreenHeight == 480) {
                        
                    } else if (kScreenHeight == 568) {
                        myInfoLabel.font = [UIFont boldSystemFontOfSize:30];
                    } else if (kScreenHeight == 736) {
                        
                    }

                } else {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:30];
                    myInfoLabel.textColor = kHexRGBAlpha(0xffffff, 1.0f);
                    
                    UILabel *myDanWeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 3.0 - 20 - 10 - 15 + 2, 40 * 2 / 3.0 - 10 + 6, 40, 40 * 1 / 3.0)];
                    myDanWeiLabel.backgroundColor = kRandomColor(0.0f);
                    myDanWeiLabel.font = [UIFont boldSystemFontOfSize:11];
                    myDanWeiLabel.adjustsFontSizeToFitWidth = YES;
                    myDanWeiLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
                    myDanWeiLabel.text = @"BMP";
                    [myInfoLabel addSubview:myDanWeiLabel];
                    
                    if (kScreenHeight == 480) {
                        myInfoLabel.font = [UIFont boldSystemFontOfSize:18];
                    } else if (kScreenHeight == 568) {
                        myInfoLabel.font = [UIFont boldSystemFontOfSize:20];
                        myDanWeiLabel.transform = CGAffineTransformMakeTranslation(3, -5);
                    } else if (kScreenHeight == 736) {
                        
                    }
                }
            }

            
            if (kScreenHeight == 480) {
                myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -30);
            } else if (kScreenHeight == 568) {
                myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -20);
            } else if (kScreenHeight == 736) {
                
            }
        }
    }
}

/**
 *  创建表格
 */
- (void)createInfoCharts {
    UIView *myChartView = [[UIView alloc] initWithFrame:CGRectMake(20, 64 + 20 + 20 + 40 + 35 + 27, kScreenWidth - 20 * 2, 200)];
    myChartView.backgroundColor = kRandomColor(0.0f);
    myChartView.tag = 110;
    [self.view addSubview:myChartView];
    if (kScreenHeight == 480) {
        myChartView.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, -25), 1.0, 0.9);
    }
    
    _myLayerOfChart = [CALayer layer];
    _myLayerOfChart.name = @"MyLayerOfChart";
    _myLayerOfChart.frame = myChartView.layer.bounds;
    _myLayerOfChart.shadowOpacity = 1.0f;
    _myLayerOfChart.delegate = self;
    [_myLayerOfChart setNeedsDisplay];
    [myChartView.layer addSublayer:_myLayerOfChart];
    
    for (NSInteger i = 0; i < 6; i ++) {
        UILabel *myLabelOfLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, (myChartView.frame.size.height / 7.0) * i + (myChartView.frame.size.height / 7.0) / 2.0, 40, (myChartView.frame.size.height / 7.0))];
        
        if (i == 5) {
            myLabelOfLeft.text = @"55BPM";
        } else {
            myLabelOfLeft.text = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"区间", nil),i];
        }
        

        myLabelOfLeft.textAlignment = NSTextAlignmentLeft;
        myLabelOfLeft.textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
        myLabelOfLeft.font = [UIFont boldSystemFontOfSize:10];
        [myChartView addSubview:myLabelOfLeft];
    }
    
    for (NSInteger i = 0; i < 4; i ++) {
        UILabel *myBottonLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * (kScreenWidth - 40) / 4.0, (myChartView.frame.size.height / 7.0) * 6, (kScreenWidth - 40) / 3.0, myChartView.frame.size.height / 7.0)];
        myBottonLabel.text = [NSString stringWithFormat:@"%ld%@", (i + 1) * 10, NSLocalizedString(@"分", nil)];
        myBottonLabel.textAlignment = NSTextAlignmentCenter;
        myBottonLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
        myBottonLabel.font = [UIFont boldSystemFontOfSize:10];
        [myChartView addSubview:myBottonLabel];
        
        if (kScreenHeight == 480) {
            myBottonLabel.transform = CGAffineTransformMakeTranslation(0, 15);
        } else if (kScreenHeight == 568) {

        } else if (kScreenHeight == 736) {
            
        }

    }
    
    
    if (kScreenHeight == 480) {
         myChartView.transform = CGAffineTransformMakeTranslation(0, -60);
    } else if (kScreenHeight == 568) {
        myChartView.transform = CGAffineTransformMakeTranslation(0, -40);
    } else if (kScreenHeight == 736) {
        
    }

}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    CGContextSetAllowsAntialiasing(ctx, true); // 去锯齿
    CGContextSetShouldAntialias(ctx, true);
    
    if ([layer.name isEqualToString:@"MyLayerOfChart"]) {
        UIView *myTempView = [self.view viewWithTag:110];
        
        CGContextSetStrokeColorWithColor(ctx, kHexRGBAlpha(0xffffff, 1.0).CGColor);
        
        CGContextMoveToPoint(ctx, 40, 0);
        CGContextAddLineToPoint(ctx, 40, myTempView.frame.size.height - (myTempView.frame.size.height / 7.0));
        CGContextStrokePath(ctx);
        
        
        CGContextMoveToPoint(ctx, 40, myTempView.frame.size.height - (myTempView.frame.size.height / 7.0));
        CGContextAddLineToPoint(ctx, kScreenWidth - 40, myTempView.frame.size.height - (myTempView.frame.size.height / 7.0));
        CGContextStrokePath(ctx);
        
        CGContextSetLineWidth(ctx, 1);
        _myTempPoint = CGPointMake(40, myTempView.frame.size.height / 7.0);
        for (NSInteger i = 0; i < 5; i ++) {
            CGContextMoveToPoint(ctx, _myTempPoint.x, _myTempPoint.y);
            
            CGContextSetFillColorWithColor(ctx, kRGBColor(79, 237, 117, 0.8).CGColor);
            CGContextSetStrokeColorWithColor(ctx, kHexRGBAlpha(0x2a2a2a, 0.8).CGColor);
            
            CGFloat lengths[] = {3, 2};
            CGContextSetLineDash(ctx, 0, lengths, 1);
            CGContextAddLineToPoint(ctx,  _myTempPoint.x + myTempView.frame.size.width - 40, _myTempPoint.y);
            CGContextStrokePath(ctx);
            
            _myTempPoint = CGPointMake(40, myTempView.frame.size.height / 7.0 * (i + 2));
        }
        

        
        NSMutableArray *testArr = [NSMutableArray array];
        CGFloat height = 6 * myTempView.frame.size.height / 7.0;
        
        for (NSInteger i = 0; i < 30 * 2; i ++) {
            [testArr addObject:[NSString stringWithFormat:@"%d", arc4random_uniform(36)]];
        }
        
              
        _myTempPoint = CGPointMake(40 + 0 * (myTempView.frame.size.width - 40) / 3 / 10 / 2, height * ([testArr[0] integerValue]/ 35.0));
        for (NSInteger i = 0; i < 30 * 2 - 1; i ++) {
            CGContextSetLineWidth(ctx, 1.0f);
            CGContextMoveToPoint(ctx, _myTempPoint.x, _myTempPoint.y);
            CGContextSetLineDash(ctx, 0, 0, 0);
            
            CGContextSetFillColorWithColor(ctx, kHexRGBAlpha(0x19bc9d, 1.0f).CGColor);
            CGContextSetStrokeColorWithColor(ctx, kHexRGBAlpha(0x19bc9d, 1.0f).CGColor);
            
            _myTempPoint = CGPointMake(40 + (i + 1) * (myTempView.frame.size.width - 40) / 3 / 10 / 2, height * ([testArr[i + 1] integerValue]/ 35.0));
            CGContextAddLineToPoint(ctx, _myTempPoint.x, _myTempPoint.y);
            CGContextStrokePath(ctx);
        }

    }
}

/**
 *  创建信息详情显示
 */
- (void)creteInfoDetailViews {
    NSArray *testArr1 = @[@"00:00", @"00.0", @"000"];
    NSArray *testArr2 = @[@"Duration", @"Distance", @"Burn Calories"];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        testArr2 = @[@"运动时长", @"运动距离", @"消耗热量"];
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        for (NSInteger j = 0; j < 3; j ++) {
            UILabel *myInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + j * (kScreenWidth - 30 * 2) / 3.0, (64 + 20 + 20 + 40 + 35 + 200 + 20 + 25 + 3) + 35 * i, (kScreenWidth - 30 * 2) / 3.0, 60 - 20 * (i + 1))];
            myInfoLabel.adjustsFontSizeToFitWidth = YES;
            myInfoLabel.backgroundColor = kRandomColor(0.0f);
            myInfoLabel.textColor = [UIColor whiteColor];
            myInfoLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:myInfoLabel];
            if (kScreenHeight == 480) {
                myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -60);
            }
            
            if (i == 0) {
                myInfoLabel.text = testArr1[j];
                myInfoLabel.font = [UIFont boldSystemFontOfSize:30];
                if (j != 0) {
                    UILabel *myDanWeiLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 30 * 2) / 3.0 - 20 - 10 + 10, 40 * 2 / 3.0 - 10 + 3, 20, 40 * 1 / 3.0)];
                    myDanWeiLabel.backgroundColor = kRandomColor(0.0f);
                    myDanWeiLabel.font = [UIFont boldSystemFontOfSize:11];
                    myDanWeiLabel.adjustsFontSizeToFitWidth = YES;
                    myDanWeiLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
                    if (j == 1) {
                        myDanWeiLabel.text = @"km";
                    } else {
                        myDanWeiLabel.text = @"cal";
                    }
                    [myInfoLabel addSubview:myDanWeiLabel];
                    
                    if (kScreenHeight == 480) {
                        myDanWeiLabel.transform = CGAffineTransformMakeTranslation(0, -4);
                    } else if (kScreenHeight == 568) {
                        myDanWeiLabel.transform = CGAffineTransformMakeTranslation(0, -4);
                    } else if (kScreenHeight == 736) {
                        
                    }
                }
                
                if (kScreenHeight == 480) {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:20];
                    myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -90);
                } else if (kScreenHeight == 568) {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:20];
                    myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -50);
                } else if (kScreenHeight == 736) {
                    
                }
                
            } else {
                myInfoLabel.text = testArr2[j];
                myInfoLabel.font = [UIFont boldSystemFontOfSize:16];
                myInfoLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
        
                if (kScreenHeight == 480) {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:12];
                    myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -100);
                } else if (kScreenHeight == 568) {
                    myInfoLabel.font = [UIFont boldSystemFontOfSize:12];
                    myInfoLabel.transform = CGAffineTransformMakeTranslation(0, -60);
                } else if (kScreenHeight == 736) {
                    
                }
            }
        
        }
    }
    
    /**
     *  创建开始和结束按钮。
     */
    UIButton *btnOfContinus = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOfContinus.frame = CGRectMake(kScreenWidth / 2.0 - 120 , kScreenHeight - 135, 60, 60);
    [btnOfContinus setImage:[UIImage imageNamed:@"switch_start_avr"] forState:UIControlStateNormal];
    [btnOfContinus addTarget:self action:@selector(btnOfContinusAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOfContinus.tag = 31103;
    _IsPlaying = NO;
    [self.view addSubview:btnOfContinus];
    
    UIButton *btnOfOver = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOfOver.frame = CGRectMake(kScreenWidth / 2.0 + 120 - 60, kScreenHeight - 135, 60, 60);
    [btnOfOver setImage:[UIImage imageNamed:@"switch_end_avr"] forState:UIControlStateNormal];
    [btnOfOver addTarget:self action:@selector(btnOfOverAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOfOver.tag = 31104;
    [self.view addSubview:btnOfOver];
    
    if (kScreenHeight == 480) {
        btnOfContinus.transform = CGAffineTransformMakeTranslation(0, 50);
        btnOfOver.transform = CGAffineTransformMakeTranslation(0, 50);
    } else if (kScreenHeight == 568) {
        btnOfContinus.transform = CGAffineTransformMakeTranslation(0, 30);
        btnOfOver.transform = CGAffineTransformMakeTranslation(0, 30);
    } else if (kScreenHeight == 736) {
        
    }
    
//    UIButton *starCeShiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [starCeShiBtn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
//
//    [starCeShiBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
//    starCeShiBtn.tag = 31102;
//    [starCeShiBtn setTitle:NSLocalizedString(@"暂停", nil)forState:UIControlStateSelected];
//    starCeShiBtn.frame = CGRectMake(kScreenWidth / 2.0 - 20, kScreenHeight - 135, 60, 60);
//    [starCeShiBtn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
//    starCeShiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//
//    [self.view addSubview:starCeShiBtn];
//    
//    
//    
//    if (kScreenHeight == 480) {
//        starCeShiBtn.transform = CGAffineTransformMakeTranslation(0, 25);
//    }
//
//    if (kScreenHeight == 480) {
//        starCeShiBtn.transform = CGAffineTransformMakeTranslation(0, 50);
//    } else if (kScreenHeight == 568) {
//        starCeShiBtn.transform = CGAffineTransformMakeTranslation(0, 30);
//    } else if (kScreenHeight == 736) {
//        
//    }
}

/**
 *  废弃
 *
 *  @param sender <#sender description#>
 */
//- (void)btnClcik:(id)sender {
//    UIButton *btn = sender;
//
//    if (btn.selected == YES) {
//        btn.selected = NO;
//        [btn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
//        btn.alpha = 0;
//        
//        UIButton *btnOfContinus = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnOfContinus.frame = CGRectMake(kScreenWidth / 2.0 - 120 , kScreenHeight - 135, 60, 60);
//        [btnOfContinus setImage:[UIImage imageNamed:@"switch_start_avr"] forState:UIControlStateNormal];
//        [btnOfContinus addTarget:self action:@selector(btnOfContinusAction:) forControlEvents:UIControlEventTouchUpInside];
//        btnOfContinus.tag = 31103;
//        [self.view addSubview:btnOfContinus];
//        
//        UIButton *btnOfOver = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnOfOver.frame = CGRectMake(kScreenWidth / 2.0 + 120 - 60, kScreenHeight - 135, 60, 60);
//        [btnOfOver setImage:[UIImage imageNamed:@"switch_end_avr"] forState:UIControlStateNormal];
//        [btnOfOver addTarget:self action:@selector(btnOfOverAction:) forControlEvents:UIControlEventTouchUpInside];
//        btnOfOver.tag = 31104;
//        [self.view addSubview:btnOfOver];
//        
//        if (kScreenHeight == 480) {
//            btnOfContinus.transform = CGAffineTransformMakeTranslation(0, 50);
//            btnOfOver.transform = CGAffineTransformMakeTranslation(0, 50);
//        } else if (kScreenHeight == 568) {
//            btnOfContinus.transform = CGAffineTransformMakeTranslation(0, 30);
//            btnOfOver.transform = CGAffineTransformMakeTranslation(0, 30);
//        } else if (kScreenHeight == 736) {
//            
//        }
//        
//    } else {
//        btn.selected = YES;
//        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    }
//}


- (void)btnOfContinusAction:(id)sender {
    if (_IsPlaying == NO) {
        [[self.view viewWithTag:31103] setImage:[UIImage imageNamed:@"switch_continue_avr"] forState:UIControlStateNormal];
    } else {
        [[self.view viewWithTag:31103] setImage:[UIImage imageNamed:@"switch_start_avr"] forState:UIControlStateNormal];
    }
    
    _IsPlaying = !_IsPlaying;
}
- (void)btnOfOverAction:(id)sender {
    [[self.view viewWithTag:31103] setImage:[UIImage imageNamed:@"switch_start_avr"] forState:UIControlStateNormal];
    _IsPlaying = NO;
//    [[self.view viewWithTag:31102] setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
//    [self.view viewWithTag:31102].alpha = 1;
//    [[self.view viewWithTag:31104] removeFromSuperview];
//    [[self.view viewWithTag:31103] removeFromSuperview];
}

- (void)dealloc {
    [_myLayerOfChart removeFromSuperlayer];
}

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
