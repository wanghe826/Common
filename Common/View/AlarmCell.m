//
//  AlarmCell.m
//  Common
//
//  Created by HMM－MACmini on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "AlarmCell.h"

@interface AlarmCell () <UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *selectedView; // 存放下方选项单位的底图
@property (nonatomic, strong) UISwitch *mySwithch;
@property (nonatomic, strong) NSMutableArray *mutArrOfUserDefaul; // 持久化数据时候的数组
@property (nonatomic, strong) NSMutableArray *mutAttBtnSelected;

@end

@implementation AlarmCell

// 懒加载初始化所有控件
- (UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 47.5, 45)];
        // _myImageView.backgroundColor = kRandomColor(1.0);
    }
    return _myImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47.5 + 8, 11, kScreenWidth / 2.0, 16)];
        // _titleLabel.text = @"久坐提醒";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        // _titleLabel.backgroundColor = kRandomColor(1.0);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(47.5 + 8, 11 + 15 + 3, kScreenWidth / 2.0, 12)];
        // _timeLabel.backgroundColor = kRandomColor(1.0);
        // _timeLabel.text = @"09:00~22:00";
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(47.5, 45, kScreenWidth - 47.5, 35)];
        // _selectedView.backgroundColor = kRandomColor(1.0);
    }
    return _selectedView;
}
- (UISwitch *)mySwithch {
    if (!_mySwithch) {
        _mySwithch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 5, 0, 0)];
        _mySwithch.onTintColor = kHexRGBAlpha(0x004581, 1.0);
        [_mySwithch addTarget:self action:@selector(mySwithchChange:) forControlEvents:UIControlEventValueChanged];
        
        for (NSString *strOfBOOL in self.mutAttBtnSelected) {
            if ([strOfBOOL boolValue]) {
                _mySwithch.on = YES;
            }
        }
    }
    return _mySwithch;
}

// 懒加载初始化 mutArrOfUserDefaul
- (NSMutableArray *)mutArrOfUserDefaul {
    if (!_mutArrOfUserDefaul) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ClockSave"]) {
            _mutArrOfUserDefaul = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClockSave"]];
        } else {
            _mutArrOfUserDefaul = [NSMutableArray arrayWithArray:self.mutArrOfAllInfo];
        }
        // _mutArrOfUserDefaul = [NSMutableArray arrayWithArray:self.mutArrOfAllInfo];
        
        // @[@{@"icon_sedentary_reminder_sel.png":@"久坐提醒"}, @{@"icon_daytime_sel.png":@"请选择闹钟时间"}, @{@"icon_daytime_avr.png":@"请选择闹钟时间"}, @{@"icon_daytime_avr1.png":@"请选择闹钟时间"}, @{@"icon_night_avr.png":@"请选择闹钟时间"}, @{@"icon_night_sel.png":@"请选择闹钟时间"}]
    }
    return _mutArrOfUserDefaul;
}

// 懒加载初始化 mutAttBtnSelected
- (NSMutableArray *)mutAttBtnSelected {
    if (!_mutAttBtnSelected) {
        _mutAttBtnSelected = [NSMutableArray arrayWithArray:[NSMutableArray arrayWithArray:[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][1]]];
    }
    return _mutAttBtnSelected;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)drawRect:(CGRect)rect {
    [self creatDetail]; // 创建所有控件初始属性
}

- (void)refreshUI:(NSInteger)section {
    _titleLabel.text = [NSString stringWithFormat:@"%@:%@", [self.strOfSubTitle substringToIndex:2], [self.strOfSubTitle substringFromIndex:3]];
    _timeLabel.text = self.strOfSubTitle;
    
    // kLog(@"%@",self.strOfSubTitle);
    NSDate *date = [NSDate date]; // 当前时间
    date = [self dataOfSystem:date];
    NSString *cureentDateStr = [self stringFromDate:date];

    NSTimeInterval a_day = 24 * 60 * 60;
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:a_day];
    tomorrow = [self dataOfSystem:tomorrow];
    // NSString *tomorrowDateStr = [self stringFromDate:tomorrow];

    if ((([[self.strOfSubTitle substringToIndex:2] integerValue] == [[cureentDateStr substringWithRange:NSMakeRange(11, 2)] integerValue]) && ([[self.strOfSubTitle substringFromIndex:3] integerValue] > [[cureentDateStr substringWithRange:NSMakeRange(14, 2)] integerValue])) || ([[self.strOfSubTitle substringToIndex:2] integerValue] > [[cureentDateStr substringWithRange:NSMakeRange(11, 2)] integerValue])) {
        
        NSTimeInterval lastTimes = [[self dateFromString:[NSString stringWithFormat:@"%@%@:%@:00", [cureentDateStr substringToIndex:11], [self.self.strOfSubTitle substringToIndex:2], [self.strOfSubTitle substringFromIndex:3]]] timeIntervalSinceDate:date];
        
//        _timeLabel.text = [NSString stringWithFormat:@"%02ld小时%02ld分钟%02ld秒后闹钟将发出提醒", ((NSInteger)lastTimes / 3600), ((NSInteger)lastTimes % 3600) / 60, ((NSInteger)lastTimes % 3600) % 60];
        // && ([[cureentDateStr substringWithRange:NSMakeRange(17, 2)] integerValue]) == 0)
        // self.mutArrOfLastTime[self.numOfSection] = [NSString stringWithFormat:@"%ld", (NSInteger)lastTimes];
    } else {
        
        NSTimeInterval lastTimes = [[self dateFromString:[NSString stringWithFormat:@"%@%@:%@:00", [cureentDateStr substringToIndex:11], [self.self.strOfSubTitle substringToIndex:2], [self.strOfSubTitle substringFromIndex:3]]] timeIntervalSinceDate:date];
        
        _timeLabel.text = [NSString stringWithFormat:@"%02ld小时%02ld分钟%02ld秒后闹钟将发出提醒", ((NSInteger)lastTimes / 3600) + 23, 60 + ((NSInteger)lastTimes % 3600) / 60 - 1, 60 + ((NSInteger)lastTimes % 3600) % 60];
        // self.mutArrOfLastTime[self.numOfSection] = [NSString stringWithFormat:@"%ld", (NSInteger)lastTimes];
    }
    
    if (section == 0) {
        _titleLabel.text = @"久坐提醒";
        _timeLabel.text = self.strOfSubTitle;;
    }
    
    for (NSInteger i = 0; i < self.mutAttBtnSelected.count; i ++) {
        if ([self.mutAttBtnSelected[i] isEqualToString:@"1"]) {
            if ([_titleLabel.text length] == (self.numOfSection == 0 ? 4 : 5) && ![_timeLabel.text isEqualToString:@" "]) {
                self.mutArrOfUserDefaul[self.numOfSection] = @{[self.mutArrOfUserDefaul[self.numOfSection] allKeys][0]:@[[NSString stringWithFormat:@"%@、%@", self.titleLabel.text, self.timeLabel.text], self.mutAttBtnSelected]};
                
                [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfUserDefaul forKey:@"ClockSave"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                
            }
            break;
        } else {
            if (i == self.mutAttBtnSelected.count - 1) {
                
            }
        }
    }
    
    // kLog(@"%@", self.mutArrOfUserDefaul);
    // (self.numOfSection == 0 ? 4 : 5)
    if (![_timeLabel.text isEqualToString:@" "]) {
        for (NSString *strOfBOOL in self.mutAttBtnSelected) {
            if ([strOfBOOL boolValue]) {
                [_mySwithch setOn:YES animated:YES];
            }
        }
    }
} // 刷新 UI Cell

- (NSDate *)dataOfSystem:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
} // 获取系统时区

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    NSTimeInterval a_day = 8 * 60 * 60;
    return [destDate dateByAddingTimeInterval:a_day];
} // string -> date 减8个小时，得到系统的

- (NSString *)stringFromDate:(NSDate *)date{
    NSTimeInterval a_day = 8 * 60 * 60;
    date = [date dateByAddingTimeInterval:-a_day];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
} // date -> string 减8个小时，得到系统的

// 创建所有控件初始属性
- (void)creatDetail {
    [self addSubview:self.myImageView];
    // [_myImageView setImage:[UIImage imageNamed:[(NSDictionary *)self.strOfImageName allKeys][0]]];
    [_myImageView setImage:[UIImage imageNamed:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]]];
    _myImageView.contentMode = UIViewContentModeCenter;
    
    [self addSubview:self.titleLabel];
    _titleLabel.textColor = kHexRGBAlpha(0x4a4a4a, 1.0);
    _titleLabel.text = [[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] substringToIndex:[[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] rangeOfString:@"、"].location];
    
    [self addSubview:self.timeLabel];
    // _timeLabel.text = self.strOfSubTitle;
    _timeLabel.textColor = kHexRGBAlpha(0x4a4a4a, 1.0);
    _timeLabel.text = [[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] substringFromIndex:[[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] rangeOfString:@"、"].location + 1];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    if (_timeLabel.text.length >= 8 ) {
        NSDate *date = [NSDate date]; // 当前时间
        date = [self dataOfSystem:date];
        NSString *cureentDateStr = [self stringFromDate:date];
        
        NSTimeInterval a_day = 24 * 60 * 60;
        NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:a_day];
        tomorrow = [self dataOfSystem:tomorrow];
        // NSString *tomorrowDateStr = [self stringFromDate:tomorrow];
        
        if ((([[_titleLabel.text substringToIndex:2] integerValue] == [[cureentDateStr substringWithRange:NSMakeRange(11, 2)] integerValue]) && ([[_titleLabel.text substringFromIndex:3] integerValue] > [[cureentDateStr substringWithRange:NSMakeRange(14, 2)] integerValue])) || ([[_titleLabel.text substringToIndex:2] integerValue] > [[cureentDateStr substringWithRange:NSMakeRange(11, 2)] integerValue])) {
            NSTimeInterval lastTimes = [[self dateFromString:[NSString stringWithFormat:@"%@%@:%@:00", [cureentDateStr substringToIndex:11], [_titleLabel.text substringToIndex:2], [_titleLabel.text substringFromIndex:3]]] timeIntervalSinceDate:date];
            _timeLabel.text = [NSString stringWithFormat:@"%02ld小时%02ld分钟%02ld秒后闹钟将发出提醒", ((NSInteger)lastTimes / 3600), ((NSInteger)lastTimes % 3600) / 60, ((NSInteger)lastTimes % 3600) % 60];
            // && ([[cureentDateStr substringWithRange:NSMakeRange(17, 2)] integerValue]) == 0)
            // self.mutArrOfLastTime[self.numOfSection] = [NSString stringWithFormat:@"%ld", (NSInteger)lastTimes];
        } else {
            NSTimeInterval lastTimes = [[self dateFromString:[NSString stringWithFormat:@"%@%@:%@:00", [cureentDateStr substringToIndex:11], [_titleLabel.text substringToIndex:2], [self.strOfSubTitle substringFromIndex:3]]] timeIntervalSinceDate:date];
            _timeLabel.text = [NSString stringWithFormat:@"%02ld小时%02ld分钟%02ld秒后闹钟将发出提醒", ((NSInteger)lastTimes / 3600) + 23, 60 + ((NSInteger)lastTimes % 3600) / 60 - 1, 60 + ((NSInteger)lastTimes % 3600) % 60];
            //        self.mutArrOfLastTime[self.numOfSection] = [NSString stringWithFormat:@"%ld", (NSInteger)lastTimes];
        }
        
        if (self.numOfSection == 0) {
            _titleLabel.text = @"久坐提醒";
            _timeLabel.text = [[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] substringFromIndex:[[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] rangeOfString:@"、"].location + 1];
        }
    } else {
        
    }
    
    
    // self.mySwithch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 5, 0, 0)];
    self.mySwithch.frame = CGRectMake(kScreenWidth - 60, 5, 0, 0);
    _mySwithch.onTintColor = kHexRGBAlpha(0x004581, 1.0);
    _mySwithch.tag = 1212 + self.numOfSection;
    [_mySwithch addTarget:self action:@selector(mySwithchChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.mySwithch];
    

    if (!_selectedView) {
        [self addSubview:self.selectedView];
        
        UILabel *sparateLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(47.5, 45 - 1, (kScreenWidth - 47.5 * 2), 1)];
        sparateLineLabel.backgroundColor = kHexRGBAlpha(0xc6c6c6, 1.0);
        [self addSubview:sparateLineLabel];
        
        for (NSInteger i = 0; i < self.mutArr.count; i ++) {
            UIButton *mybtn = [UIButton buttonWithType:UIButtonTypeCustom];
            mybtn.frame = CGRectMake(47.5 + (kScreenWidth - 47.5 * 2) / self.mutArr.count * i, 45, (kScreenWidth - 47.5 * 2) / self.mutArr.count, 35);
            // mybtn.backgroundColor = kRandomColor(1.0);
            mybtn.titleLabel.font = [UIFont systemFontOfSize:11];
            mybtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [mybtn setTitleColor:kHexRGBAlpha(0xc6c6c6, 1.0) forState:UIControlStateNormal];
            [mybtn setTitleColor:kHexRGBAlpha(0x00458e, 1.0) forState:UIControlStateSelected];
            [mybtn setTitleColor:kHexRGBAlpha(0x00458e, 1.0) forState:UIControlStateHighlighted];
            [mybtn setTitle:self.mutArr[i] forState:UIControlStateNormal];
            [self addSubview:mybtn];
            mybtn.tag = 77 + i;
            [mybtn addTarget:self action:@selector(btnSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            mybtn.selected = [[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][1][i] boolValue];
            
            if (mybtn.selected) {
                [mybtn setBackgroundColor:kHexRGBAlpha(0xc6c6c6, 1.0)];
            }
            
            if (i < self.mutArr.count - 1) {
                UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(47.5 + (kScreenWidth - 47.5 * 2) / self.mutArr.count * (i + 1), 45, 1, 35)];
                myLabel.backgroundColor = kHexRGBAlpha(0xc6c6c6, 1.0);
                [self addSubview:myLabel];
            }
        }
    }
    
    self.mutAttBtnSelected = [NSMutableArray arrayWithArray:[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][1]];
    
    if (self.numOfSection == 0) {
        _titleLabel.text = @"久坐提醒";
        _timeLabel.text = [[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] substringFromIndex:[[self.mutArrOfAllInfo[self.numOfSection] objectForKey:[self.mutArrOfAllInfo[self.numOfSection] allKeys][0]][0] rangeOfString:@"、"].location + 1];
    }
}

// 按钮点击事件
- (void)btnSelectedAction:(id)sender {
//    self.myReturnBlockStopTime(); // 停止定时器
    UIButton *btn = (UIButton *)sender;
    if (self.numOfSection == 0) {
        for (NSInteger i = 77; i < 84; i ++) {
            UIButton *btn = [(UIButton *)self viewWithTag:i];
            [btn setSelected:NO];
            btn.backgroundColor = [UIColor clearColor];
            self.mutAttBtnSelected[i - 77] = @"0";
        }
        btn.selected = YES;
        self.mutAttBtnSelected[[sender tag] - 77] = @"1";
    } else {
        btn.selected = !btn.selected;
    }
    
    if (btn.selected == YES) {
        [btn setBackgroundColor:kHexRGBAlpha(0xc6c6c6, 1.0)];
        self.mutAttBtnSelected[[sender tag] - 77] = @"1";
    } else {
        [btn setBackgroundColor:kHexRGBAlpha(0xc6c6c6, 0.0)];
        self.mutAttBtnSelected[[sender tag] - 77] = @"0";
    }
    
    if ([_titleLabel.text length] == (self.numOfSection == 0 ? 4 : 5) && ![_timeLabel.text isEqualToString:@" "]) {
        self.mutArrOfUserDefaul[self.numOfSection] = @{[self.mutArrOfUserDefaul[self.numOfSection] allKeys][0]:@[[NSString stringWithFormat:@"%@、%@", self.titleLabel.text, self.timeLabel.text], self.mutAttBtnSelected]};
        
        [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfUserDefaul forKey:@"ClockSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
//    kLog(@"%@", self.mutArrOfUserDefaul);
    
    if ([_titleLabel.text length] == (self.numOfSection == 0 ? 4 : 5) && ![_timeLabel.text isEqualToString:@" "]) {
        for (NSString *strOfBOOL in self.mutAttBtnSelected) {
            if ([strOfBOOL isEqualToString:@"0"]) {
                [_mySwithch setOn:NO animated:YES];
            } else {
                [_mySwithch setOn:YES animated:YES];
                break;
            }
        }
    } else {
        [_mySwithch setOn:NO animated:YES];
        
    }
    
    for (NSInteger i = 0; i < self.mutArrOfAllInfo.count; i ++) {
        UISwitch *mySwitch = (UISwitch *)[self viewWithTag:1212 + self.numOfSection];
        if (![mySwitch isOn]) {
            self.mutArrOfUserDefaul[self.numOfSection] = @{[self.mutArrOfUserDefaul[self.numOfSection] allKeys][0]:@[[NSString stringWithFormat:@"%@、%@", @"请选择闹钟时间", @" "], @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]};
            
            [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfUserDefaul forKey:@"ClockSave"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
//            self.myReturnBlockStarTime(); // 开始定时器
        }
    } // 判断开关状态，是否保存信息

}

- (void)mySwithchChange:(id)sender {
//    self.myReturnBlockStopTime(); // 停止定时器
    for (NSInteger i = 0; i < self.mutAttBtnSelected.count; i ++) {
        if ([self.mutAttBtnSelected[i] isEqualToString:@"1"]) {
            if ([_titleLabel.text length] == (self.numOfSection == 0 ? 4 : 5) && ![_timeLabel.text isEqualToString:@" "]) {
                self.mutArrOfUserDefaul[[sender tag] - 1212] = @{[self.mutArrOfUserDefaul[[sender tag] - 1212] allKeys][0]:@[[NSString stringWithFormat:@"%@、%@", self.titleLabel.text, self.timeLabel.text], self.mutAttBtnSelected]};
                
                [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfUserDefaul forKey:@"ClockSave"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"闹钟输入不完整" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [myAlert show];
                [_mySwithch setOn:YES animated:YES];
            }
        
            break;
        } else {
            if (i == self.mutAttBtnSelected.count - 1) {
                UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"闹钟输入不完整" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [myAlert show];
                [_mySwithch setOn:YES animated:YES];
            }
        }
    }
    
    
    for (NSInteger i = 0; i < self.mutArrOfAllInfo.count; i ++) {
        UISwitch *mySwitch = (UISwitch *)[self viewWithTag:1212 + self.numOfSection];
        if (![mySwitch isOn]) {
            self.mutArrOfUserDefaul[self.numOfSection] = @{[self.mutArrOfUserDefaul[self.numOfSection] allKeys][0]:@[[NSString stringWithFormat:@"%@、%@", @"请选择闹钟时间", @" "], @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]};
            
            [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfUserDefaul forKey:@"ClockSave"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
//            self.myReturnBlockStarTime(); // 开始定时器
        }
    } // 判断开关状态，是否保存信息
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_mySwithch setOn:NO animated:YES];

}

@end
