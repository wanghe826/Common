//
//  TimingVC.m
//  Common
//
//  Created by HMM－MACmini on 16/1/8.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "TimingVC.h"
#import "Masonry.h"

#import "CustomViewUtil.h"
#import <CoreText/CoreText.h>
#import "CurrentTimeView.h"

#define kHourTag   1
#define kMinuteTag 2
#define kSecondTag 3

@interface TimingVC () {
    UIImageView *_timezoneBackground;
    
    UIImageView *_selectView;
    
    CurrentTimeView *_timeView;
    UILabel *_currentTimeZoneLable;
    
    UIImageView *_circleView;
    UIImageView *_hourView;
    UIImageView *_minView;
    UIImageView *_secView;
    
    NSUInteger _currentTag;
    
    UILabel *_hintLabel;
    UIButton *_settingBtn;
    
    // 实现校时功能
    NSTimer *_sendCommandTimer;
    
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
}

@property (nonatomic, strong) UIAlertController *alertVC; // 一级 alter
@property (nonatomic, strong) UIAlertController *subAlertVC; // 二级 alert

@end

@implementation TimingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    self.title = NSLocalizedString(@"智能校时", nil);
    [self createUI];
    [self createWatch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!ApplicationDelegate.isC007) {
        if([ApplicationDelegate.productSeries isEqualToString:@"C002"] || [ApplicationDelegate.productSeries isEqualToString:@"C003"] || [ApplicationDelegate.productSeries isEqualToString:@"C004"] || [ApplicationDelegate.productSeries isEqualToString:@"C005"])
        {
            [self createStopWatch];
        }
    }
    
    [self receiveValueFromWatch];
    
    [WriteData2BleUtil goIntoTiming:ApplicationDelegate.currentPeripheral withSatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetTimer];
    [self startHandler];
    
    [WriteData2BleUtil goIntoTiming:ApplicationDelegate.currentPeripheral withSatus:NO];
}

- (void)createStopWatch {
    _sendCommandTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(stopHandler) userInfo:nil repeats:YES];
    [_sendCommandTimer fire];
}

- (void)resetTimer{
    [_sendCommandTimer invalidate];
    _sendCommandTimer = nil;
}

// 自定义 alterView
- (void)tapPress:(id)sender {
        NSArray *imageArr = @[@"", @"shoubiao_diyibiaopan_queding", @"shoubiao_dier_queding", @"shoubiao_disan_queding"];
        NSArray *imageArr1 = @[@"", @"shoubiao_diyibiaopan", @"shoubiao_dier_xia", @"shoubiao_disan_xiayibu"];
        self.alertVC = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:@"If Clock hand was not pointed to position 12, please press the up and down buttons ." preferredStyle:1];
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
        }]];
    
        UIImageView *myImageView = [[UIImageView alloc] init];
        myImageView.image = [UIImage imageNamed:imageArr[[sender tag] / 1111 - 1]];
        myImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (screen_height == 480) {
            myImageView.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 20, 50, 110, 86);
        } else if (screen_height == 568) {
            myImageView.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 20, 50, 110, 86);
        }
        else if (screen_height == 667)  {
            myImageView.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 40, 50, 110, 86);
        }
        else if(screen_height == 736) {
            myImageView.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 60, 50, 110, 86);
        }
        
        [_alertVC.view addSubview:myImageView];
        [self presentViewController:_alertVC animated:YES completion:nil];
        
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"next" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
            self.subAlertVC = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:@"If Clock hand was not pointed to position 12, please press the up and down buttons ." preferredStyle:1];
            UIImageView *myImageView1 = [[UIImageView alloc] init];
            myImageView1.image = [UIImage imageNamed:imageArr1[[sender tag] / 1111 - 1]];
            myImageView1.contentMode = UIViewContentModeScaleAspectFill;
            if (screen_height == 480) {
                myImageView1.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 20, 50, 110, 86);
            } else if (screen_height == 568) {
                myImageView1.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 20, 50, 110, 86);
            }
            else if (screen_height == 667)  {
                myImageView1.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 40, 50, 110, 86);
            }
            else if(screen_height == 736) {
                myImageView1.frame = CGRectMake(self.view.center.x - 110 / 2.0 - 60, 50, 110, 86);
            }
            
            [_subAlertVC.view addSubview:myImageView1];
            [self presentViewController:_subAlertVC animated:YES completion:nil];
            
            [_subAlertVC addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
                switch ([(UIButton*)sender tag]) {
                    case 2222: {
                        [WriteData2BleUtil stopOrStartHandler:ApplicationDelegate.currentPeripheral withStatus:YES withIndex:1];
                        break;
                    }
                    case 3333: {
                        [WriteData2BleUtil stopOrStartHandler:ApplicationDelegate.currentPeripheral withStatus:YES withIndex:3];
                        break;
                    }
                    case 4444: {
                        [WriteData2BleUtil stopOrStartHandler:ApplicationDelegate.currentPeripheral withStatus:YES withIndex:2];
                        break;
                    }
                    default:
                        break;
                }
                _btn1.hidden = NO;
                _btn2.hidden = NO;
                _btn3.hidden = NO;
                _btn4.hidden = NO;
            }]];
        }]];
}

- (void)createUI {
    UIView *selectorView = [CustomViewUtil autoTimingSelectorView];
    if (screen_height == 480) {
        selectorView.frame = CGRectMake(0, 0, screen_width - 20, 35);
    }else
    selectorView.frame = CGRectMake(0, 0, screen_width-20, 35);
    [self.view addSubview:selectorView];
    selectorView.center = CGPointMake(self.view.center.x, 90);
    
    for (UIView* view in selectorView.subviews) {
        if([view isKindOfClass:[UISwitch class]])
        {
            UISwitch* switchView = (UISwitch*)view;
            switchView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            switchView.tintColor = kRandomColor(0.0f);
            switchView.alpha = 1;
            BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:AutoTimingSwitchStatus];
            switchView.on = status;
            [switchView addTarget:self action:@selector(autoTimingSwitch:) forControlEvents:UIControlEventValueChanged];
//            break;
        }
        
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).text = NSLocalizedString(@"自动同步手机时间", nil);
            ((UILabel *)view).textColor = HexRGBAlpha(0xffffff, 1);
            ((UILabel *)view).font = [UIFont systemFontOfSize:16];
            ((UILabel *)view).adjustsFontSizeToFitWidth = YES;
        }
    }
    
    _timezoneBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
    _timezoneBackground.image = [UIImage imageNamed:@"bg_map"];
    [self.view addSubview:_timezoneBackground];
    if (kScreenHeight == 480) {
        [_timezoneBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(selectorView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(screen_width, screen_height/8));
        }];
    } else {
        [_timezoneBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(selectorView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(screen_width, screen_height/6));
        }];
    }
    
    _currentTimeZoneLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _currentTimeZoneLable.adjustsFontSizeToFitWidth = YES;
    [_currentTimeZoneLable setFont:[UIFont systemFontOfSize:12]];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@+8%@", NSLocalizedString(@"您当前位于", nil), NSLocalizedString(@"区", nil)]];
//    [attrStr addAttribute:(NSString *)kCTForegroundColorAttributeName
//                    value:(id)[UIColor redColor].CGColor
//                    range:NSMakeRange(5, 2)];
//    [attrStr addAttribute:(NSString *)kCTFontAttributeName
//                    value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:26].fontName,24,NULL))
//                    range:NSMakeRange(5, 2)];
    _currentTimeZoneLable.attributedText = attrStr;
    _currentTimeZoneLable.textAlignment = NSTextAlignmentCenter;
    _currentTimeZoneLable.textColor = [UIColor whiteColor];
    [_timezoneBackground addSubview:_currentTimeZoneLable];
    [_currentTimeZoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_timezoneBackground);
        make.size.mas_equalTo(CGSizeMake(200, 21));
    }];
    
    
    UIView *timeZoneLabel = [CustomViewUtil timeZoneLabelView:CGRectZero];
    [self.view addSubview:timeZoneLabel];
    [timeZoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timezoneBackground.mas_left);
        make.right.mas_equalTo(_timezoneBackground.mas_right);
        make.top.mas_equalTo(_timezoneBackground.mas_bottom);
        make.height.mas_equalTo(@(20));
    }];
    
    _selectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_zone_sel"]];
    [_timezoneBackground addSubview:_selectView];
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timezoneBackground.mas_top);
        make.height.mas_equalTo(_timezoneBackground.mas_height);
        make.left.mas_equalTo(@(10*screen_width/25));
        make.width.mas_equalTo(@(2));
    }];
    
    
    _timeView = [CurrentTimeView currentTimeView:CGRectZero];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSUInteger hour;
    if([[dateStr substringWithRange:NSMakeRange(0, 2)] integerValue] > 12)
    {
        hour = [[dateStr substringWithRange:NSMakeRange(0, 2)] integerValue] - 12;
    }
    else
    {
        hour = [[dateStr substringWithRange:NSMakeRange(0, 2)] integerValue];
    }
    if(hour >= 10)
    {
        [_timeView.hourBtn setTitle:[NSString stringWithFormat:@"%d",hour] forState:UIControlStateNormal];
    }
    else
    {
        [_timeView.hourBtn setTitle:[NSString stringWithFormat:@"0%d",hour] forState:UIControlStateNormal];
    }
    [_timeView.minBtn setTitle:[dateStr substringWithRange:NSMakeRange(3, 2)] forState:UIControlStateNormal];
    [_timeView.secBtn setTitle:[dateStr substringWithRange:NSMakeRange(6, 2)] forState:UIControlStateNormal];
    
    
    [self.view addSubview:_timeView];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.top.mas_equalTo(_selectView.mas_bottom).offset(15);   //修改处
        if (screen_height == 480) {
            make.height.mas_equalTo(@(30));
        }else
        make.height.mas_equalTo(@(50));
    }];
}

- (void)createWatch {
    _currentTag = kSecondTag;
    _circleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_wacth"]];
    [self.view addSubview:_circleView];
    
    int margin = 60;
    if(screen_height==480)  margin = 70;
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).offset(margin);
        make.right.mas_equalTo(self.view.mas_right).offset(-margin);
        make.height.mas_equalTo(_circleView.mas_width);
    }];
    _hourView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hour_hand_avr"]];
    [self.view addSubview:_hourView];
    [_hourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_circleView);
        make.center.mas_equalTo(_circleView);
    }];
    _minView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minute_hand_avr"]];
    [self.view addSubview:_minView];
    [_minView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_circleView);
        make.center.mas_equalTo(_circleView);
    }];
    _secView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"second_hand_sel"]];
    [self.view addSubview:_secView];
    [_secView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_circleView);
        make.center.mas_equalTo(_circleView);
    }];
    
    float hourRotation = [_timeView.hourBtn.titleLabel.text integerValue]*2*M_PI/12;
    float minuteRotation = [_timeView.minBtn.titleLabel.text integerValue]*2*M_PI/60;
    float secondRotation = [_timeView.secBtn.titleLabel.text integerValue]*2*M_PI/60;
    _hourView.transform = CGAffineTransformMakeRotation(hourRotation);
    _minView.transform = CGAffineTransformMakeRotation(minuteRotation);
    _secView.transform = CGAffineTransformMakeRotation(secondRotation);
    
    [self addButtonAction];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _hintLabel.textColor = HexRGBAlpha(0xa2a2a2, 1);
    _hintLabel.font = [UIFont systemFontOfSize:16];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.text = NSLocalizedString(@"点击相应数字进入相应时间调整", nil);
    _hintLabel.adjustsFontSizeToFitWidth = YES;
    _hintLabel.numberOfLines = 0;
    [self.view addSubview:_hintLabel];
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(screen_width));
        if (screen_height == 480) {
            make.height.mas_equalTo(@(30));
        }else
        make.height.mas_equalTo(@(50));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_circleView.mas_bottom).offset(20);
    }];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _settingBtn.layer.cornerRadius = 4;
//    _settingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    _settingBtn.layer.borderWidth = 2;
    [_settingBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_settingBtn setBackgroundImage:[UIImage imageNamed:@"btn_sure"] forState:UIControlStateNormal];
    [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(asyncTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingBtn];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 40));
        make.center.mas_equalTo(_hintLabel);
    }];
    if (kScreenHeight == 480) {
        [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(250, 40));
            make.center.mas_equalTo(CGPointMake(_hintLabel.center.x, _hintLabel.center.y + 220));
        }];
    }
    _settingBtn.hidden = YES;
    
    
    int marginBtn = 30;
    if(screen_height==480)
    {
        marginBtn = -10 ;
    }
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.tag = 1111;
    [_btn1 addTarget:self action:@selector(watchTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_btn1 setImage:[UIImage imageNamed:@"anniu1"] forState:UIControlStateNormal];
    [self.view addSubview:_btn1];
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.mas_equalTo(_circleView.mas_centerY);
        make.centerX.mas_equalTo(_circleView.mas_centerX);
    }];;
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 addTarget:self action:@selector(watchTarget:) forControlEvents:UIControlEventTouchUpInside];
    _btn2.tag = 2222;
    [_btn2 setImage:[UIImage imageNamed:@"anniu2"] forState:UIControlStateNormal];
    [self.view addSubview:_btn2];
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerY.mas_equalTo(_circleView.mas_centerY);
        make.left.mas_equalTo(_btn1.mas_right).offset(marginBtn);
    }];;
    
    _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn4 addTarget:self action:@selector(watchTarget:) forControlEvents:UIControlEventTouchUpInside];
    _btn4.tag = 4444;
    [_btn4 setImage:[UIImage imageNamed:@"anniu4"] forState:UIControlStateNormal];
    [self.view addSubview:_btn4];
    [_btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerY.mas_equalTo(_circleView.mas_centerY);
        make.right.mas_equalTo(_btn1.mas_left).offset(-marginBtn);
    }];;
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn3 addTarget:self action:@selector(watchTarget:) forControlEvents:UIControlEventTouchUpInside];
    _btn3.tag = 3333;
    [_btn3 setImage:[UIImage imageNamed:@"anniu3"] forState:UIControlStateNormal];
    [self.view addSubview:_btn3];
    [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.mas_equalTo(_btn1.mas_centerX);
        make.top.mas_equalTo(_btn1.mas_bottom).offset(marginBtn);
    }];;
    
    if([ApplicationDelegate.productSeries isEqualToString:@"F003"] || [ApplicationDelegate.productSeries isEqualToString:@"H001"])
    {
        [_btn3 removeFromSuperview];
    }
    if([ApplicationDelegate.productSeries isEqualToString:@"C006"])
    {
        [_btn2 removeFromSuperview];
        [_btn4 removeFromSuperview];
    }
    if([ApplicationDelegate.productSeries isEqualToString:@"C002"] || [ApplicationDelegate.productSeries isEqualToString:@"C003"] || [ApplicationDelegate.productSeries isEqualToString:@"C004"] || [ApplicationDelegate.productSeries isEqualToString:@"C005"])
    {
        [_btn1 removeFromSuperview];
        [_btn2 removeFromSuperview];
        [_btn3 removeFromSuperview];
        [_btn4 removeFromSuperview];
    }
}

- (void)watchTarget:(UIButton*)sender {
    switch (sender.tag) {
        case 1111:
        {
            [self createStopWatch];
            break;
        }
        case 2222:
        {
            [WriteData2BleUtil stopOrStartHandler:ApplicationDelegate.currentPeripheral withStatus:NO withIndex:1];
            break;
        }
        case 3333:
        {
            [WriteData2BleUtil stopOrStartHandler:ApplicationDelegate.currentPeripheral withStatus:NO withIndex:3];
            break;
        }
        case 4444:
        {
            [WriteData2BleUtil stopOrStartHandler:ApplicationDelegate.currentPeripheral withStatus:NO withIndex:2];
            break;
        }
        default:
            break;
    }
    _btn1.hidden = YES;
    _btn2.hidden = YES;
    _btn3.hidden = YES;
    _btn4.hidden = YES;
    if(sender.tag == 1111) {
        return;
    }
    [self tapPress:sender];
}

- (void)addButtonAction {
    __weak typeof(self) weakSelf = self;
    __weak typeof(_hourView) hourView = _hourView;
    __weak typeof(_minView) minView = _minView;
    __weak typeof(_secView) secView = _secView;
    _timeView.hourPressed = ^(void){
        _currentTag = kHourTag;
        hourView.image = [UIImage imageNamed:@"hour_hand_sel"];
        minView.image = [UIImage imageNamed:@"minute_hand_avr"];
        secView.image = [UIImage imageNamed:@"second_hand_avr"];
        [weakSelf.view bringSubviewToFront:hourView];
    };
    _timeView.minPressed = ^(void){
        _currentTag = kMinuteTag;
        hourView.image = [UIImage imageNamed:@"hour_hand_avr"];
        minView.image = [UIImage imageNamed:@"minute_hand_sel"];
        secView.image = [UIImage imageNamed:@"second_hand_avr"];
        [weakSelf.view bringSubviewToFront:minView];
    };
    _timeView.secPressed = ^(void){
        _currentTag = kSecondTag;
        hourView.image = [UIImage imageNamed:@"hour_hand_avr"];
        minView.image = [UIImage imageNamed:@"minute_hand_avr"];
        secView.image = [UIImage imageNamed:@"second_hand_sel"];
        [weakSelf.view bringSubviewToFront:secView];
    };
}

- (void) autoTimingSwitch:(UISwitch*)swi {
    [[NSUserDefaults standardUserDefaults] setBool:swi.on forKey:AutoTimingSwitchStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) selectTheTimezoneWithPoint:(CGPoint)currentPoint
{
    float average = screen_width/25;
    int index = currentPoint.x / average;
    NSLog(@"----index===>%d", index);
    if(index==0) return;
    
    int time = 0;
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"您当前位于", nil) ,time, NSLocalizedString(@"区", nil)]];
    if(index==1)
    {
       attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-1%@", NSLocalizedString(@"您当前位于", nil), NSLocalizedString(@"区", nil)]];
    }
    else if(index==2 || index==14)
    {
        attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@+0%@", NSLocalizedString(@"您当前位于", nil), NSLocalizedString(@"区", nil)]];
    }
    else if(index<=13 && index>0)
    {
        attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@+%d%@",NSLocalizedString(@"您当前位于", nil), index-2, NSLocalizedString(@"区", nil)]];
    }
    else
    {
        attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%d%@",NSLocalizedString(@"您当前位于", nil), abs(26-index), NSLocalizedString(@"区", nil)]];
    }
    if(attrStr.length==9)
    {
//        [attrStr addAttribute:(NSString *)kCTForegroundColorAttributeName
//                        value:(id)[UIColor redColor].CGColor
//                        range:NSMakeRange(5, 3)];
//        [attrStr addAttribute:(NSString *)kCTFontAttributeName
//                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:26].fontName,24,NULL))
//                        range:NSMakeRange(5, 3)];
    }
    else
    {
//        [attrStr addAttribute:(NSString *)kCTForegroundColorAttributeName
//                        value:(id)[UIColor redColor].CGColor
//                        range:NSMakeRange(5, 2)];
//        [attrStr addAttribute:(NSString *)kCTFontAttributeName
//                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:26].fontName,24,NULL))
//                        range:NSMakeRange(5, 2)];
    }
    _currentTimeZoneLable.attributedText = attrStr;
    
    _selectView.frame = CGRectMake(index*average, _selectView.frame.origin.y, CGRectGetWidth(_selectView.frame), CGRectGetHeight(_selectView.frame));
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(_timezoneBackground.frame, currentPoint))        //时区选择
    {
        [self selectTheTimezoneWithPoint:currentPoint];
        return;
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(_timezoneBackground.frame, currentPoint))        //时区选择
    {
        [self selectTheTimezoneWithPoint:currentPoint];
        return;
    }
    
//    if(!CGRectContainsPoint(_circleView.frame, currentPoint))
//    {
//        return;
//    }
    
    _hintLabel.hidden = YES;
    _settingBtn.hidden = NO;
    [self rotateWatchHandle:currentPoint];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(_selectView.frame, currentPoint))        //时区选择
    {
        [self selectTheTimezoneWithPoint:currentPoint];
        return;
    }
    
//    if(!CGRectContainsPoint(_circleView.frame, currentPoint))
//    {
//        return;
//    }
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if(CGRectContainsPoint(_selectView.frame, currentPoint))        //时区选择
    {
        [self selectTheTimezoneWithPoint:currentPoint];
        return;
    }
    
//    if(!CGRectContainsPoint(_circleView.frame, currentPoint))
//    {
//        return;
//    }
    
    [self rotateWatchHandle:currentPoint];
}

- (void)rotateWatchHandle:(CGPoint)currentPoint {
    double degree = 0;
    if(currentPoint.x<self.view.center.x)       //触摸点在中心点的左边
    {
        degree = atan((self.view.center.x - currentPoint.x)/(currentPoint.y-_hourView.center.y));
        if(currentPoint.y>=_hourView.center.y)   //触摸点在中心点的上边
        {
            degree+=M_PI;
        }
    }
    if(currentPoint.x>self.view.center.x)       //触摸点在中心点的右边
    {
        degree = atan((currentPoint.x - self.view.center.x)/(currentPoint.y-_hourView.center.y));
        if(currentPoint.y>=_hourView.center.y)   //触摸点在中心点的上边
        {
            degree+=M_PI;
        }
        degree = -degree;
    }
    
    
    switch (_currentTag) {
        case kHourTag:
        {
            CGFloat radiusssss = atan2f(_hourView.transform.b, _hourView.transform.a);
            CGFloat degreeeeee = radiusssss * (180 / M_PI);
            NSLog(@"---degreee--> %f", degreeeeee);
            if(degreeeeee>=0 && degreeeeee<=180)
            {
                int hour = degreeeeee/30;
                if(hour==0)  hour = 12;
                
                if(hour<10)
                {
                    [_timeView.hourBtn setTitle:[NSString stringWithFormat:@"0%d",hour] forState:UIControlStateNormal];
                }
                else
                {
                    [_timeView.hourBtn setTitle:[NSString stringWithFormat:@"%d",hour] forState:UIControlStateNormal];
                }
            }
            else
            {
                int hour = (18-(-degreeeeee+180)/30);
                if(hour==0) hour = 12;
                if(hour<10)
                {
                    [_timeView.hourBtn setTitle:[NSString stringWithFormat:@"0%d",hour] forState:UIControlStateNormal];
                }
                else
                {
                    [_timeView.hourBtn setTitle:[NSString stringWithFormat:@"%d",hour] forState:UIControlStateNormal];
                }
            }
            _hourView.transform = CGAffineTransformMakeRotation(degree);
            break;
        }
        case kMinuteTag:
        {
            CGFloat radiusssss = atan2f(_minView.transform.b, _minView.transform.a);
            CGFloat degreeeeee = radiusssss * (180 / M_PI);
            if(degreeeeee>=0 && degreeeeee<=180)
            {
                int minute = degreeeeee/6;
                if(minute<10)
                {
                    [_timeView.minBtn setTitle:[NSString stringWithFormat:@"0%d",minute] forState:UIControlStateNormal];
                }
                else
                {
                   [_timeView.minBtn setTitle:[NSString stringWithFormat:@"%d",minute] forState:UIControlStateNormal];
                }
            }
            else
            {
                int minute = (90-(-degreeeeee+180)/6);
                if(minute<10)
                {
                    [_timeView.minBtn setTitle:[NSString stringWithFormat:@"0%d",minute] forState:UIControlStateNormal];
                }
                else
                {
                    [_timeView.minBtn setTitle:[NSString stringWithFormat:@"%d",minute] forState:UIControlStateNormal];
                }
            }
            _minView.transform = CGAffineTransformMakeRotation(degree);
            break;
        }
        case kSecondTag:
        {
            CGFloat radiusssss = atan2f(_secView.transform.b, _secView.transform.a);
            CGFloat degreeeeee = radiusssss * (180 / M_PI);
            
            if(degreeeeee>=0 && degreeeeee<=180)
            {
                int hour = degreeeeee/6;
                if(hour<10)
                {
                    [_timeView.secBtn setTitle:[NSString stringWithFormat:@"0%d",hour] forState:UIControlStateNormal];
                }
                else
                {
                    [_timeView.secBtn setTitle:[NSString stringWithFormat:@"%d",hour] forState:UIControlStateNormal];
                }
            }
            else
            {
                int minute = (90-(-degreeeeee+180)/6);
                if(minute<10)
                {
                    [_timeView.secBtn setTitle:[NSString stringWithFormat:@"0%d",minute] forState:UIControlStateNormal];
                }
                else
                {
                    [_timeView.secBtn setTitle:[NSString stringWithFormat:@"%d",minute] forState:UIControlStateNormal];
                }
            }

            _secView.transform = CGAffineTransformMakeRotation(degree);
            break;
        }
        default:
            break;
    }
}

/****
 蓝牙相关的操作
 **/

#pragma 停针
- (void)stopHandler {
    [WriteData2BleUtil controlHandle:ApplicationDelegate.currentPeripheral withStatus:NO];
}

- (void)startHandler {
   [WriteData2BleUtil controlHandle:ApplicationDelegate.currentPeripheral withStatus:YES];
}

- (void) stopAllHander {
    [WriteData2BleUtil stopAll:ApplicationDelegate.currentPeripheral];
}
#pragma 开始同步时间
- (void)asyncTime {
    [self resetTimer];
    
    NSUInteger hour = [_timeView.hourBtn.titleLabel.text integerValue];
    NSUInteger minute = [_timeView.minBtn.titleLabel.text integerValue];
    NSUInteger second = [_timeView.secBtn.titleLabel.text integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    
    
    [WriteData2BleUtil adjustTime:ApplicationDelegate.currentPeripheral withHour:comps.hour withMinute:comps.minute withSecond:comps.second];
    
//    if(!ApplicationDelegate.isC007) {
        // 发送世界时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WriteData2BleUtil asyncWorldTime:ApplicationDelegate.currentPeripheral];
        });
//    }
   
    if(hour==12) hour = 0;
    int allSeconds = hour*60*60 + minute*60 + second;
//    if(ApplicationDelegate.isC007) {
        [WriteData2BleUtil sendAllSeconds:ApplicationDelegate.currentPeripheral withSeconds:allSeconds];
//    }
    

    int year = comps.year;
    int month = comps.month;
    int day = comps.day;
    NSLog(@"------>年%d, 月%d, 日%d", year, month, day);
//    if(ApplicationDelegate.isC007) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WriteData2BleUtil controlDate:ApplicationDelegate.currentPeripheral withYear:16 withMonth:month withDay:day];
        });
//    }
    
//    _btn1.hidden = NO;
//    _btn2.hidden = NO;
//    _btn3.hidden = NO;
//    _btn4.hidden = NO;
    
    [self startHandler];
}

- (void) receiveValueFromWatch {
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        Byte* bytes = (Byte*)[characteristic.value bytes];
        NSLog(@"收到手表数据：%@", characteristic.value);
    }];
    
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"------>写入成功：%@", characteristic.value);
    }];
}

- (void)commonDelegate {
}

@end
