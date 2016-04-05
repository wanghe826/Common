//
//  ZhouYueSleepContainTableView.m
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "ZhouYueSleepContainTableView.h"

#import "ZhouYueSleepContainTableViewCell.h"

#import "SportData.h" // 获取数据的类
#import "FetchSportDataUtil.h" // 计算数据的类

@interface ZhouYueSleepContainTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTabelView;

@property (nonatomic, strong) SportData *mySportData;

@property (nonatomic, strong) NSMutableArray *mutArrOfZhou; // 每周数据
@property (nonatomic, strong) NSMutableArray *mutArrOfYue; // 每月数据

@end

@implementation ZhouYueSleepContainTableView

- (UITableView *)myTabelView {
    if (!_myTabelView) {
//        _myTabelView = [[UITableView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.frame.size.height) / 2.0, -(self.frame.size.width - self.frame.size.height) / 2.0, self.frame.size.height, self.frame.size.width)];
        _myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - (self.frame.size.width / 7.0), self.frame.size.height)];
        _myTabelView.delegate = self;
        _myTabelView.dataSource = self;
        _myTabelView.backgroundColor = [UIColor clearColor];
        _myTabelView.separatorColor = kHexRGBAlpha(0xffffff, 0);
        _myTabelView.scrollEnabled = NO;
        _myTabelView.pagingEnabled = YES;
    }
    return _myTabelView;
} // 懒加载初始化 myTabelView

- (NSMutableArray *)mySleepData1 {
    if (!_mySleepData1) {
        _mySleepData1 = [NSMutableArray new];
        for (NSInteger i = 0; i < 7; i ++) {
            NSString *strOfDeep = [NSString stringWithFormat:@"%d", arc4random_uniform(25)];
            NSString *strOfQian = [NSString stringWithFormat:@"%d", arc4random_uniform(25 - [strOfDeep intValue])];
            NSString *strOfXinZhe = [NSString stringWithFormat:@"%d", arc4random_uniform(25 - [strOfDeep intValue] - [strOfQian intValue])]; //  - arc4random_uniform(25 - ([strOfDeep intValue] + [strOfQian intValue]))
            NSString *strOfNo = [NSString stringWithFormat:@"%d", 24 - [strOfDeep intValue] - [strOfQian intValue] - [strOfXinZhe intValue]];
            NSMutableArray *mySubMutArr = [NSMutableArray arrayWithArray:@[strOfDeep, strOfQian, strOfXinZhe, strOfNo]];
            [_mySleepData1 addObject:@{[NSString stringWithFormat:@"%ld", i]:mySubMutArr}];
        }
    }
    return _mySleepData1;
} // 睡眠周数据
- (NSMutableArray *)mySleepData2 {
    if (!_mySleepData2) {
        _mySleepData2 = [NSMutableArray new];
        for (NSInteger i = 0; i < _mounthDay; i ++) {
            NSString *strOfDeep = [NSString stringWithFormat:@"%d", arc4random_uniform(25)];
            NSString *strOfQian = [NSString stringWithFormat:@"%d", arc4random_uniform(25 - [strOfDeep intValue])];
            NSString *strOfXinZhe = [NSString stringWithFormat:@"%d", arc4random_uniform(25 - [strOfDeep intValue] - [strOfQian intValue])]; //  - arc4random_uniform(25 - ([strOfDeep intValue] + [strOfQian intValue]))
            NSString *strOfNo = [NSString stringWithFormat:@"%d", 24 - [strOfDeep intValue] - [strOfQian intValue] - [strOfXinZhe intValue]];
            NSMutableArray *mySubMutArr = [NSMutableArray arrayWithArray:@[strOfDeep, strOfQian, strOfXinZhe, strOfNo]];
            [_mySleepData2 addObject:@{[NSString stringWithFormat:@"%ld", i]:mySubMutArr}];
        }
    }
    return _mySleepData2;
} // 睡眠月数据

- (NSMutableArray *)myAllDayArr {
    if (!_myAllDayArr) {
        _myAllDayArr = [NSMutableArray array];
    } // 所有记录天的步数
    return _myAllDayArr;
}
- (NSMutableArray *)mutArrOfZhou {
    if (!_mutArrOfZhou) {
        _mutArrOfZhou = [NSMutableArray new];
    }
    return _mutArrOfZhou;
} // 周数据
- (NSMutableArray *)mutArrOfYue {
    if (!_mutArrOfYue) {
        _mutArrOfYue = [NSMutableArray new];
    }
    return _mutArrOfYue;
} // 月数据

/**
 *  给一个'数组'做升序、此时的数组元素比较特别，可以自行打印
 *
 *  @param mutArr 传入数组
 *
 *  @return 返回排序的'某个'数组
 */
- (NSArray *)wantArrOfOneToN:(NSMutableArray *)mutArr1 {
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0;  i < mutArr1.count; i ++) {
        [values addObject:[mutArr1[i] objectForKey:[mutArr1[i] allKeys][0]]];
    }
    return [values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] > [obj2 floatValue] ) {
            return NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue] ) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self createTableView];
    [self drawSomeBackCharts]; // 绘画后方方格背景
    
    if (_isSportVC) {
        if (_isZhou) {
            [self requestData]; // 请求数据
        } else {
            [self requestData]; // 请求数据
        }
    }
}
// 请求数据
- (void)requestData {
    if (_isSportVC) {
        if (_isZhou) {
            
            self.myAllDayArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempArr1"];
            self.mutArrOfZhou = [[NSUserDefaults standardUserDefaults] objectForKey:@"tempArr2"];
            
            
            
            if (self.myAllDayArr.count % 7 != 0) {
                self.myReturnBlockOfMaxPageOfZhouOfSport(self.myAllDayArr.count / 7 + 1);
            } else {
                self.myReturnBlockOfMaxPageOfZhouOfSport(self.myAllDayArr.count / 7 + 0);
            }
            
            self.myReturnBlockOfAllWeeksArr(self.mutArrOfZhou); // 所有周数据
        } else {
            _mySportData = [SportData new];
            [_mySportData fetchAllSportDataLength];
            
            //    sleep(1.0);
            
            // 天数据处理
            NSMutableArray *arrOfTempTest1 = [NSMutableArray arrayWithArray:[FetchSportDataUtil fetchAllDaysSportData]];
            self.myAllDayArr = [NSMutableArray arrayWithArray:[[arrOfTempTest1 reverseObjectEnumerator] allObjects]];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.myAllDayArr forKey:@"tempArr1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 周数据处理
            NSMutableArray *array1; // 周数的天数
            NSMutableArray *arrOfTempTest2 = [NSMutableArray arrayWithArray:[FetchSportDataUtil fetchAllWeeksSportData:&array1]];
            self.mutArrOfZhou = [NSMutableArray arrayWithArray:arrOfTempTest2];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfZhou forKey:@"tempArr2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            // 月数据处理
            NSMutableArray *array2; // 月数的天数
            NSMutableArray *arrOfTempTest3 = [NSMutableArray arrayWithArray:[FetchSportDataUtil fetchAllMonthSportData:&array2]];
            self.mutArrOfYue = [NSMutableArray arrayWithArray:arrOfTempTest3];
          
            


            self.myReturnBlockOfMaxPageYueOfSportt(self.mutArrOfYue.count); // 最多月数
            self.myReturnBlockOfAllYueArr(self.mutArrOfYue); // 所有月数据

        }
    } else {
        
    }
    
    if (_isZhou) {
        self.myReturnBlockOfAllDaysSteps(self.myAllDayArr);
    }
    [self.myTabelView reloadData];
}
- (void)drawSomeBackCharts {
    if (_isZhou) {
        [self huiZhiBiaoGe:7 andY:7];
    } else {
        [self huiZhiBiaoGe:7 andY:7];
    }
} // 调用！绘制背景表格文字.等
- (void)huiZhiBiaoGe:(NSInteger)x andY:(NSInteger)y {
    CGFloat littleWidth = self.frame.size.width / x;
    CGFloat littleHeight = self.frame.size.height / y;
    for (NSInteger i = 0; i < y; i ++) {
        for (NSInteger j = 0; j < x - 1; j ++) {
            CGMutablePathRef path = CGPathCreateMutable();
            // 指定矩形
            CGRect rectangle = CGRectMake(littleWidth * j, littleHeight * i, littleWidth, littleHeight);
            // 将矩形添加到路径中
            CGPathAddRect(path, NULL, rectangle);
            // 获取上下文
            CGContextRef currentContext = UIGraphicsGetCurrentContext();
            // 将路径添加到上下文
            CGContextAddPath(currentContext, path);
            // 设置矩形填充色
            [kHexRGBAlpha(0x161821, 0) setFill];
            // 矩形边框颜色
            [kHexRGBAlpha(0x161821, 1) setStroke];
            // 边框宽度
            CGContextSetLineWidth(currentContext, 1.0f);
            // 绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGPathRelease(path);
        }
    }
    
    CGFloat originX = self.frame.size.width / 7.0;
    CGFloat originY = self.frame.size.height / 7.0;

    if (_isZhou) {
        NSArray *testArr1 = @[@"Sun.", @"Mon.", @"Tue.", @"Wed.", @"Thur.", @"Fri.", @"Sat."];
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
            testArr1 = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        }

        NSArray *testArr2 = [[testArr1 reverseObjectEnumerator] allObjects];
        for (NSInteger i = 0; i < 7; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6.0 * originX, 0 + i * originY, originX, originY)];
            label.backgroundColor = kRandomColor(0.0f);
            label.text = testArr2[i];
            label.textColor = kHexRGBAlpha(0xc1c1c1, 1.0f);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:12];
            label.transform = CGAffineTransformMakeRotation(-M_PI_2);
            [self addSubview:label];
        }
    } else {
        NSArray *testArr1 = @[@"1", @"", @"", @"16", @"", @"", [NSString stringWithFormat:@"%ld", _mounthDay]];
        NSArray *testArr2 = [[testArr1 reverseObjectEnumerator] allObjects];
        for (NSInteger i = 0; i < 7; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6.0 * originX, 0 + i * originY, originX, originY)];
            label.backgroundColor = kRandomColor(0.0f);
            label.text = testArr2[i];
            label.textColor = kHexRGBAlpha(0xc1c1c1, 1.0f);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:12];
            label.transform = CGAffineTransformMakeRotation(-M_PI_2);
            [self addSubview:label];
        }
    }
} // 绘制背景表格文字.等

- (void)createTableView {
    [self addSubview:self.myTabelView];
    
//    _myTabelView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isZhou) {
        return (self.frame.size.height) / (7.0);
    } else {
        return (self.frame.size.height) / (_mounthDay);
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSportVC) {
        if (_isZhou) {
//            return 7;
            return self.myAllDayArr.count;
        } else {
//            return _mounthDay;
            return self.myAllDayArr.count;
        }
    } else {
        if (_isZhou) {
            return 7;
        } else {
            return _mounthDay;
        }
    }
} // row Num
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhouYueSleepContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyZhouYueSleepContainTableViewCell"];
    if (!cell) {
        cell = [[ZhouYueSleepContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyZhouYueSleepContainTableViewCell"];
    }
    
    cell.isZhou = _isZhou;
    cell.isSportVC = _isSportVC;
    cell.mounthDay = _mounthDay;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
//    [cell refreshUI:self.mySleepData andIndexpath:indexPath];
    
    if (_isSportVC) {
        if (_isZhou) {
            cell.myIndex = indexPath;
            cell.mutArrOfT = self.myAllDayArr;
        } else {
            cell.myIndex = indexPath;
//            cell.mutArrOfT = self.mySportData2;
            cell.mutArrOfT = self.myAllDayArr;
        }
        cell.backgroundColor = kRandomColor(0.0f);
    } else {
        if (_isZhou) {
            cell.myIndex = indexPath;
            cell.mutArrOfT = self.mySleepData1;
        } else {
            cell.myIndex = indexPath;
            cell.mutArrOfT = self.mySleepData2;
        }
    }

    return cell;
} // cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSportVC) {
        for (NSInteger i = 0; i < self.myAllDayArr.count; i ++) {
            if (i == indexPath.row) {
                ZhouYueSleepContainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell refreshUI:indexPath];
            } else {
                ZhouYueSleepContainTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell refreshUIA:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            if (ApplicationDelegate.isC007) {
                self.myReturnBlockOfThisDayStep([NSString stringWithFormat:@"%ld", _mySportData.oneDaySportData]);
            } else {
                self.myReturnBlockOfThisDayStep([_myAllDayArr[indexPath.row] allObjects][0]);
            }
        }
    } else {
        if (_isZhou) {
            for (NSInteger i = 0; i < 7; i ++) {
                if (i == indexPath.row) {
                    ZhouYueSleepContainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell refreshUI:indexPath];
                } else {
                    ZhouYueSleepContainTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [cell refreshUIA:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        } else {
            for (NSInteger i = 0; i < _mounthDay; i ++) {
                if (i == indexPath.row) {
                    ZhouYueSleepContainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell refreshUI:indexPath];
                } else {
                    ZhouYueSleepContainTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [cell refreshUIA:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
    }
}
- (void)refreshZhouTabelViewPositionPage:(NSInteger)pageNum {
        [self.myTabelView setContentOffset:CGPointMake(0, pageNum * self.frame.size.height) animated:YES];
} // 刷新数据位置
@end
