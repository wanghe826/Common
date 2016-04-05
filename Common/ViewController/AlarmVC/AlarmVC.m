//
//  AlarmVC.m
//  Common
//
//  Created by HMM－MACmini on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "AlarmVC.h"
#import "AlarmCell.h"

@interface AlarmVC () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *myTableView; // 自定义手写 UITableView
@property (nonatomic, strong) NSMutableArray *mutArrOfData; // 数据源
@property (nonatomic, strong) UIPickerView *myPickView; // myPickView
@property (nonatomic, strong) NSMutableArray *mutArrOfMyPickView; // mutArrOfMyPickView
@property (nonatomic, assign) NSInteger numOfSelectedCell; // 选中的 cell
@property (nonatomic, copy) NSString *strOfTransportToCellSubTitle1;
@property (nonatomic, copy) NSString *strOfTransportToCellSubTitle2;
@property (nonatomic, copy) NSString *strOfTransportToCellSubTitle3;
@property (nonatomic, copy) NSString *strOfTransportToCellSubTitle4;
@property (nonatomic, strong) NSTimer *myTestTimer; // 测试定时器

@end

@implementation AlarmVC

// 懒加载初始化 UITableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.frame = self.view.bounds;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        // _myTableView.estimatedRowHeight = 45;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.sectionHeaderHeight = 1.0;
        _myTableView.sectionFooterHeight = 1.0;
    }
    return _myTableView;
}

// 懒加载初始化 mutArrOfData
- (NSMutableArray *)mutArrOfData {
    if (!_mutArrOfData) {
        _mutArrOfData = [NSMutableArray new];
        // _mutArrOfData = [NSMutableArray arrayWithArray:@[@{@"icon_sedentary_reminder_sel.png":@"久坐提醒"}, @{@"icon_daytime_sel.png":@"06:00"}, @{@"icon_daytime_avr.png":@"07:30"}, @{@"icon_daytime_avr1.png":@"16:00"}, @{@"icon_night_avr.png":@"20:30"}, @{@"icon_night_sel.png":@"22:00"}]];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ClockSave"]) {
            _mutArrOfData = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClockSave"]];
        } else {
            _mutArrOfData = [NSMutableArray arrayWithArray:@[
                                                             @{@"icon_sedentary_reminder_sel.png":@[@"久坐提醒、 ", @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]},
                                                             @{@"icon_daytime_sel.png":@[@"请选择闹钟时间、 ", @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]},
                                                             @{@"icon_daytime_avr.png":@[@"请选择闹钟时间、 ", @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]},
                                                             @{@"icon_daytime_avr1.png":@[@"请选择闹钟时间、 ", @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]},
                                                             @{@"icon_night_avr.png":@[@"请选择闹钟时间、 ", @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]},
                                                             @{@"icon_night_sel.png":@[@"请选择闹钟时间、 ", @[@"0", @"0", @"0", @"0", @"0", @"0", @"0"]]}]];
        }
    }
    return _mutArrOfData;
}

- (UIPickerView *)myPickView {
    if (!_myPickView) {
        _myPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight + 30, kScreenWidth, 200 - 50)];
        _myPickView.backgroundColor = [UIColor whiteColor];
        _myPickView.dataSource = self;
        _myPickView.delegate = self;
        _myPickView.showsSelectionIndicator = YES;
        _myPickView.tag = 1111;
        // _myPickView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myPickView.backgroundColor = [UIColor whiteColor];
    }
    return _myPickView;
} // 懒加载初始化 myPickView

- (NSMutableArray *)mutArrOfMyPickView {
    if (!_mutArrOfMyPickView) {
        _mutArrOfMyPickView = [NSMutableArray new];
    }
    return _mutArrOfMyPickView;
} // 懒加载初始化 mutArrOfMyPickView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.myTestTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayRealodTableViewData) userInfo:nil repeats:YES];
    
    [self creatMyTableView]; // 创建 myTableView
    [self creatMyPickView]; // 创建 myPickView
    [self requestDataSelected]; // 创建选择项的数据源
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)creatMyPickView {
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.alpha = 0.0;
    maskView.tag = 8888;
    maskView.backgroundColor = kHexRGBAlpha(0x4a4a4a, 1.0);
    [self.view addSubview:maskView];
    
    [self.view addSubview:self.myPickView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 30)];
    // view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.tag = 9999;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + 0.5, kScreenWidth, 0.5)];
    label.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:label];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kHexRGBAlpha(0x004581, 1.0) forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:kHexRGBAlpha(0x4a4a4a, 1.0) forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(kScreenWidth - 65, 4, 50, 22);
    [view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 4.5;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [titleBtn setTitle:@"设置闹钟时间" forState:UIControlStateNormal];
    [titleBtn setTitleColor:kHexRGBAlpha(0x004581, 1.0) forState:UIControlStateHighlighted];
    [titleBtn setTitleColor:kHexRGBAlpha(0x4a4a4a, 1.0) forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(7.5, 0, 100, 30);
    [view addSubview:titleBtn];
    titleBtn.enabled = NO;
    
    UIView *myBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.myPickView.frame.origin.y + self.myPickView.frame.size.height, kScreenWidth, 100)];
    myBackView.tag = 6666;
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    myBackView.backgroundColor = [UIColor whiteColor];
    confirmBtn.frame = CGRectMake(0, 0, kScreenWidth - 30 * 2, 40);
    confirmBtn.backgroundColor = kHexRGBAlpha(0x004581, 1.0);
    confirmBtn.center = CGPointMake(myBackView.bounds.size.width / 2.0, myBackView.frame.size.height / 2.0);
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [myBackView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.clipsToBounds = YES;
    confirmBtn.layer.cornerRadius = 10;
    [self.view addSubview:myBackView];
} // 创建 myPickView

- (void)cancelBtnAction:(id)sender {
    [self.view viewWithTag:8888].alpha = 0;
    [self allDown];
    [self.myTableView setContentOffset:CGPointMake(0, -64) animated:YES];
    self.myTableView.scrollEnabled = YES;
} // 取消按钮

- (void)confirmAction:(id)sender {
    [self.view viewWithTag:8888].alpha = 0;
    [self cancelBtnAction:sender];
   
    [self performSelector:@selector(delayRealodTableViewData) withObject:nil afterDelay:1.3f];
} // 确认按钮

// 创建选择项的数据源
- (void)requestDataSelected {
    NSMutableArray *mutArrOfHour = [NSMutableArray new];
    for (NSInteger i = 0; i < 24; i ++) {
        [mutArrOfHour addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
    [self.mutArrOfMyPickView addObject:mutArrOfHour];
    
    [self.mutArrOfMyPickView addObject:@[@":"]];
    
    NSMutableArray *mutArrOfMinu = [NSMutableArray new];
    for (NSInteger i = 0; i < 60; i ++) {
        [mutArrOfMinu addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
    [self.mutArrOfMyPickView addObject:mutArrOfMinu];
}

// 创建 myTableView
- (void)creatMyTableView {
    [self.view addSubview:self.myTableView];
    [_myTableView registerClass:[AlarmCell class] forCellReuseIdentifier:@"AlarmCell"];
    _myTableView.separatorInset = UIEdgeInsetsMake(20, 30, 20, 30);
    UIEdgeInsets padding = UIEdgeInsetsMake(-20, 0, 0, 0);
    
#if 0
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
#else
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
#endif
    
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutArrOfData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"AlarmCell";
    // 用TableSampleIdentifier表示需要重用的单元
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    // 如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[AlarmCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.mutArr = [NSMutableArray arrayWithArray:@[@"30分钟", @"1个小时", @"2个小时", @"3个小时", @"4个小时"]];
    } else {
        cell.mutArr = [NSMutableArray arrayWithArray:@[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]];
    }
    // cell.strOfImageName = self.mutArrOfData[indexPath.section];
    
    cell.mutArrOfAllInfo = self.mutArrOfData;
    
    if (self.strOfTransportToCellSubTitle1 == nil) {
        self.strOfTransportToCellSubTitle1 = @"00";
    }
    if (self.strOfTransportToCellSubTitle2 == nil) {
        self.strOfTransportToCellSubTitle2 = @"00";
    }
    if (self.strOfTransportToCellSubTitle3 == nil) {
        self.strOfTransportToCellSubTitle3 = @"00";
    }
    if (self.strOfTransportToCellSubTitle4 == nil) {
        self.strOfTransportToCellSubTitle4 = @"00";
    }
    if (indexPath.section == 0) {
        cell.strOfSubTitle = [NSString stringWithFormat:@"%@:%@~%@:%@", self.strOfTransportToCellSubTitle1, self.strOfTransportToCellSubTitle2, self.strOfTransportToCellSubTitle3, self.strOfTransportToCellSubTitle4];
    } else {
        cell.strOfSubTitle = [NSString stringWithFormat:@"%@~%@", self.strOfTransportToCellSubTitle1, self.strOfTransportToCellSubTitle2];
    }
    

    if (indexPath.section == self.numOfSelectedCell) {
        [cell refreshUI:indexPath.section];
    }
    // [cell refreshUI:indexPath.section andStrOfAllTitle:[[[NSUserDefaults standardUserDefaults] objectForKey:@"ClockSave"][indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]]];
    
    cell.numOfSection = indexPath.section;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
} // cell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
} // cell 高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 35;
    } else if (section == 1) {
        return 5;
        
    } else {
        return 1.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
} // header view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myTestTimer invalidate];
    [self allUp];

    UIView *maskVIew = [self.view viewWithTag:8888];
    maskVIew.alpha = 0.3;
    
    [self.myTableView setContentOffset:CGPointMake(0, -(kScreenHeight - 330 + 50 - (self.myTableView.frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.size.height))) animated:YES];
    self.myTableView.scrollEnabled = NO;
    
    self.numOfSelectedCell = indexPath.section;
    [self.myPickView reloadAllComponents];
}

- (void)allUp {

        [UIView animateWithDuration:1.0f animations:^{
            [self.view viewWithTag:1111].transform = CGAffineTransformMakeTranslation(0, -330 + 50);
            [self.view viewWithTag:9999].transform = CGAffineTransformMakeTranslation(0, -330 + 50);
            [self.view viewWithTag:6666].transform = CGAffineTransformMakeTranslation(0, -330 + 50);
        } completion:^(BOOL finished) {
            
        }]; // _myPickView 出现、以及其他的

} // 所有选择空间全部向上移动

- (void)allDown {
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.view viewWithTag:1111].transform = CGAffineTransformMakeTranslation(0, 0);
        [self.view viewWithTag:9999].transform = CGAffineTransformMakeTranslation(0, 0);
        [self.view viewWithTag:6666].transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }]; // _myPickView 出现、以及其他的
    
} // 所有选择空间全部向下移动

#pragma mark -
#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.numOfSelectedCell == 0) {
        return self.mutArrOfMyPickView.count * 2 + 1;
    } else {
        return self.mutArrOfMyPickView.count;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.numOfSelectedCell == 0) {
        if (component == 3) {
            return 1;
        } else if (component > 3) {
            return [self.mutArrOfMyPickView[component - 4] count];
        } else {
            return [self.mutArrOfMyPickView[component] count];
        }
    } else {
        return [self.mutArrOfMyPickView[component] count];
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.numOfSelectedCell == 0) {
        if (component == 3) {
            return @"~";
        } else if (component > 3) {
            return self.mutArrOfMyPickView[component - 4][row];
        } else {
            return self.mutArrOfMyPickView[component][row];
        }
    } else {
        return self.mutArrOfMyPickView[component][row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.numOfSelectedCell == 0) {
        if (component == 0) {
            self.strOfTransportToCellSubTitle1 = self.mutArrOfMyPickView[component][row];
        } else if (component == 2) {
            self.strOfTransportToCellSubTitle2 = self.mutArrOfMyPickView[component][row];
        } else if (component == 4) {
            self.strOfTransportToCellSubTitle3 = self.mutArrOfMyPickView[component - 4][row];
        } else if (component == 6) {
            self.strOfTransportToCellSubTitle4 = self.mutArrOfMyPickView[component - 4][row];
        }
    } else {
        if (component == 0) {
            self.strOfTransportToCellSubTitle1 = self.mutArrOfMyPickView[component][row];
        } else if (component == 2) {
            self.strOfTransportToCellSubTitle2 = self.mutArrOfMyPickView[component][row];
        }
    }
}

- (void)delayRealodTableViewData {
    [self.myTableView reloadData];
} // 延迟刷新数据

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
