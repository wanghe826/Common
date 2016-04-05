//
//  PersonalVC.m
//  Common
//
//  Created by HMM－MACmini on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "PersonalVC.h"

#import "HMMTakePicVC.h"

@interface PersonalVC () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *myTableView; // 自定义手写 UITableView
@property (nonatomic, strong) NSMutableArray *mutArrOfData; // 数据源
@property (nonatomic, strong) NSMutableArray *mutArrOfcellDetailLabel; // cell 后面的显示请输入、请选择之类的 UILabel 的数组
@property (nonatomic, strong) UIButton *mySaveBtn; // 保存按钮
@property (nonatomic, strong) UIPickerView *myPickView; // myPickView
@property (nonatomic, strong) NSMutableArray *mutArrOfMyPickView; // mutArrOfMyPickView
@property (nonatomic, assign) NSInteger numOfSelectedCell; // 选中的 cell
@property (nonatomic, strong) UIDatePicker *myDataPick; // myDataPick

@property (nonatomic, strong)  UIImageView *myHeadImageView;
@end

@implementation PersonalVC

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.frame = self.view.bounds;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    return _myTableView;
} // 懒加载初始化 UITableView

- (NSMutableArray *)mutArrOfData {
    if (!_mutArrOfData) {
        _mutArrOfData = [NSMutableArray new];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"]) {
            _mutArrOfData = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPersonalProfileSetting"]];
        } else {
            _mutArrOfData = [NSMutableArray arrayWithArray:@[@{@"img_head_portrait.png img_head_portrait.png":[NSString stringWithFormat:@"%@  ", NSLocalizedString(@"智能表芯", nil)]},@{@"icon_sex.png icon_sex.png":[NSString stringWithFormat:@"性别  %@", NSLocalizedString(@"男", nil)]}, @{@"icon_birsday_sel.png icon_birsday_sel.png":[NSString stringWithFormat:@"生日  %@", NSLocalizedString(@"1990-01-01", nil)]}, @{@"icon_height_sel.png icon_height_sel.png":[NSString stringWithFormat:@"身高  %@", [NSString stringWithFormat:@"180%@",  NSLocalizedString(@"厘米", nil)]]}, @{@"icon_weight_sel.png icon_weight_sel.png":[NSString stringWithFormat:@"体重  %@", [NSString stringWithFormat:@"80%@",  NSLocalizedString(@"千克", nil)]]}, @{@"icon_blood_type_sel.png icon_blood_type_sel.png":[NSString stringWithFormat:@"血型  %@", NSLocalizedString(@"O血型", nil)]},@{@"icon_system_of_units.png icon_system_of_units.png":[NSString stringWithFormat:@"单位制  %@", NSLocalizedString(@"公制", nil)]}]];
        }
    }
    return _mutArrOfData;
} // 懒加载初始化 mutArrOfData

- (NSMutableArray *)mutArrOfcellDetailLabel {
    if (!_mutArrOfcellDetailLabel) {
        _mutArrOfcellDetailLabel = [NSMutableArray new];
        for (NSInteger i = 0; i < self.mutArrOfData.count; i ++) {
            UILabel *cellDetailLabel = [UILabel new];
            cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.4, 0, kScreenWidth * 0.6 - 15, 45)];
            cellDetailLabel.textAlignment = NSTextAlignmentRight;
            cellDetailLabel.font = [UIFont systemFontOfSize:16];
            cellDetailLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
            cellDetailLabel.numberOfLines = 0;
            [_mutArrOfcellDetailLabel addObject:cellDetailLabel];
        }
    }
    return _mutArrOfcellDetailLabel;
} // 懒加载初始化 cellDetailLabel

- (UIPickerView *)myPickView {
    if (!_myPickView) {
        _myPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
        _myPickView.backgroundColor = [UIColor whiteColor];
        _myPickView.dataSource = self;
        _myPickView.delegate = self;
        _myPickView.showsSelectionIndicator = YES;
        _myPickView.tag = 111;
        _myPickView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _myPickView;
} // 懒加载初始化 myPickView

- (NSMutableArray *)mutArrOfMyPickView {
    if (!_mutArrOfMyPickView) {
        _mutArrOfMyPickView = [NSMutableArray new];
    }
    return _mutArrOfMyPickView;
} // 懒加载初始化 mutArrOfMyPickView

- (UIDatePicker *)myDataPick {
    if (!_myDataPick) {
        _myDataPick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight + 30, kScreenWidth, 230)];
        _myDataPick.datePickerMode = UIDatePickerModeDate;
        _myDataPick.tag = 222;
        _myDataPick.minuteInterval = 5; // 时间间隔
        NSDate *minDate = [[NSDate alloc] initWithTimeIntervalSince1970:1];
        NSDate *maxDate = [[NSDate alloc] initWithTimeIntervalSince1970:11651651156];
        _myDataPick.minimumDate = minDate;
        _myDataPick.maximumDate = maxDate;
        [_myDataPick setDate:[NSDate date] animated:YES];
        _myDataPick.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _myDataPick;
} // 懒加载初始化 myDataPick

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"个人", nil);
    self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    
    [self creatMyTableView]; // 创建 myTableView
    //    [self creatSavebtn]; // 创建保存按钮
    [self creatMyPickView]; // 创建 myPickView
    [self requestDataSelected]; // 创建选择项的数据源
    [self creatMyDataPick]; // 创建 myDataPick
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 改变状态栏颜色
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfData forKey:@"MyPersonalProfileSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 创建 myTableView
- (void)creatMyTableView {
    [self.view addSubview:self.myTableView];
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    _myTableView.separatorInset = UIEdgeInsetsMake(20, 30, 20, 30);
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    _myTableView.backgroundColor = [UIColor clearColor];
#if 0
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top);
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

// 创建保存按钮
- (void)creatSavebtn {
    self.mySaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *myBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    myBackView.backgroundColor = self.myTableView.tableFooterView.backgroundColor;
    _mySaveBtn.frame = CGRectMake(30, 45, kScreenWidth - 30 * 2, 40);
    _mySaveBtn.backgroundColor = kHexRGBAlpha(0x004581, 1.0);
    [_mySaveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [myBackView addSubview:_mySaveBtn];
    [_mySaveBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _mySaveBtn.clipsToBounds = YES;
    _mySaveBtn.layer.cornerRadius = 10;
    self.myTableView.tableFooterView = myBackView;
    self.myTableView.tableFooterView.frame =CGRectMake(0, 0, kScreenWidth, 80);
}

// 创建 myPickView
- (void)creatMyPickView {
    [self.view addSubview:self.myPickView];
}

// 创建选择项的数据源
- (void)requestDataSelected {
    
    [self.mutArrOfMyPickView addObject:@[NSLocalizedString(@"男", nil), NSLocalizedString(@"女", nil)]];
    
    NSMutableArray *mutArrOfPersonHeight = [NSMutableArray new];
    for (NSInteger i = 0; i < 250 - 60 + 1; i ++) {
        [mutArrOfPersonHeight addObject:[NSString stringWithFormat:@"%ld%@", 50 + i, NSLocalizedString(@"厘米", nil)]];
    }
    [self.mutArrOfMyPickView addObject:mutArrOfPersonHeight];
    
    NSMutableArray *mutArrOfPersonWeight = [NSMutableArray new];
    for (NSInteger i = 0; i < 250 - 30 + 1; i ++) {
        [mutArrOfPersonWeight addObject:[NSString stringWithFormat:@"%ld%@", 30 + i, NSLocalizedString(@"千克", nil)]];
    }
    [self.mutArrOfMyPickView addObject:mutArrOfPersonWeight];
    
    [self.mutArrOfMyPickView addObject:@[NSLocalizedString(@"A血型", nil), NSLocalizedString(@"B血型", nil), NSLocalizedString(@"AB血型", nil), NSLocalizedString(@"O血型", nil)]];
    
    
    [self.mutArrOfMyPickView addObject:@[NSLocalizedString(@"公制", nil), NSLocalizedString(@"英制", nil)]];
}

// 创建 myDataPick
- (void)creatMyDataPick {
    [self.view addSubview:self.myDataPick];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 30)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.userInteractionEnabled = YES;
    view.tag = 999;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kHexRGBAlpha(0x004581, 1.0) forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:kHexRGBAlpha(0x4a4a4a, 1.0) forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, 0, 100, 30);
    [view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kHexRGBAlpha(0x004581, 1.0) forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:kHexRGBAlpha(0x4a4a4a, 1.0) forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(kScreenWidth - 100, 0, 100, 30);
    [view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancelBtnAction:(id)sender {
    [UIView animateWithDuration:0.25f animations:^{
        [self.view viewWithTag:111].transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.view viewWithTag:222].transform = CGAffineTransformMakeTranslation(0, 0);
            [self.view viewWithTag:999].transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            
        }]; // _myDataPick 出现
    }]; // _myPickView 消失
    
    [self.myTableView setContentOffset:CGPointMake(0, -64) animated:YES];
    self.myTableView.scrollEnabled = YES;
} // 取消按钮
- (void)confirmBtnAction:(id)sender {
    [_mySaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self cancelBtnAction:sender];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:_myDataPick.date];
    self.mutArrOfData[2] = @{[self.mutArrOfData[2] allKeys][0]:[NSString stringWithFormat:@"生日   %@", [destDateString substringToIndex:11]]};
    
    [self performSelector:@selector(delayRealodTableViewData) withObject:nil afterDelay:1.3f];
} // 确认按钮

// 保存按钮点击事件
- (void)saveBtnAction:(id)sender {
    if ([[sender titleLabel].text isEqualToString:@"编辑"]) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.view viewWithTag:222].transform = CGAffineTransformMakeTranslation(0, 0);
            [self.view viewWithTag:999].transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                [self.view viewWithTag:111].transform = CGAffineTransformMakeTranslation(0, -200);
            } completion:^(BOOL finished) {
                
            }]; // _myPickView 出现
        }]; // _myDataPick 消失
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        if (indexPath.section == 0) {
            self.numOfSelectedCell = indexPath.section + 1;
        } else {
            self.numOfSelectedCell = indexPath.section;
        }
        [self.myPickView reloadComponent:0];
        
        [self.myTableView setContentOffset:CGPointMake(0, -(kScreenHeight - 200 - (self.myTableView.frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.size.height))) animated:YES];
        self.myTableView.scrollEnabled = NO;
        
    } else if ([[sender titleLabel].text isEqualToString:@"保存"]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfData forKey:@"MyPersonalProfileSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
} // row

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutArrOfData.count;
} // section

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier]; // 用TableSampleIdentifier表示需要重用的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    } // 如果如果没有多余单元，则需要创建新的单元
    
    cell.backgroundColor = kHexRGBAlpha(0x040b1d, 1.0f);
    [cell.imageView removeFromSuperview];
    
    if (indexPath.section != 0) {
//        cell.textLabel.text = [[self.mutArrOfData[indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]] substringToIndex:4];
    } else {
        // cell.textLabel.text = [self.mutArrOfData[indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = kHexRGBAlpha(0xffffff, 1.0);
    cell.textLabel.numberOfLines = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [cell addSubview:self.mutArrOfcellDetailLabel[indexPath.section]];
    ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).backgroundColor = kRandomColor(0.0f);
    UIEdgeInsets padding = UIEdgeInsetsMake(20, kScreenWidth / 2.0 - 30 , 20, 20 + 10);
#if 0
    [self.mutArrOfcellDetailLabel[indexPath.section] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(cell.mas_left).with.offset(padding.left);
        make.bottom.equalTo(cell.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(cell.mas_right).with.offset(-padding.right);
    }];
#else
    [self.mutArrOfcellDetailLabel[indexPath.section] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell).with.insets(padding);
    }];
#endif
    
    if ([[self.mutArrOfData[indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]] length] == 11) {
        ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        if (indexPath.section == 0) {
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).transform = CGAffineTransformMakeTranslation(-kScreenWidth / 4.0 + 30 + 30, 0);
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).adjustsFontSizeToFitWidth = YES;
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).numberOfLines = 1;
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).textAlignment = NSTextAlignmentLeft;
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).textColor = kHexRGBAlpha(0xffffff, 1.0);
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).font = [UIFont boldSystemFontOfSize:16];
        } else {
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).transform = CGAffineTransformMakeTranslation(0, 0);
            ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).textColor = kHexRGBAlpha(0xa2a2a2, 1.0);
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:[self.mutArrOfData[indexPath.section] allKeys][0]];
        if (indexPath.section == 1) {
            if ([[[self.mutArrOfData[indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]] substringFromIndex:0] isEqualToString:@"女"]) {
                cell.imageView.image = [UIImage imageNamed:@"icon_sex.png"];
            } else {
                cell.imageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringFromIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@" "].location + 1]];
            }
        } else {
                cell.imageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringFromIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@" "].location + 1]];
        }
        
    }
    
    if (indexPath.section == 0) {
        ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).text = [[self.mutArrOfData[indexPath.section] allObjects][0] substringFromIndex:0];
        cell.imageView.image = [UIImage imageNamed:@""];
    } else if (indexPath.section == 1) {
        ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).text = [[self.mutArrOfData[indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]] substringFromIndex:3];
    } else {
        ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).text = [[self.mutArrOfData[indexPath.section] objectForKey:[self.mutArrOfData[indexPath.section] allKeys][0]] substringFromIndex:3];
    }

    
    if (indexPath.section == 0) {
        
        if (!_myHeadImageView) {
            _myHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.5, 28, cell.frame.size.height + 32, cell.frame.size.height + 32)];
            [cell addSubview:_myHeadImageView];
            _myHeadImageView.clipsToBounds = YES;
            _myHeadImageView.layer.cornerRadius = (cell.frame.size.height + 32) / 2.0;
            _myHeadImageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringToIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@" "].location]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", @"myHMMHeadImage.png"]]]) {
                _myHeadImageView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", @"myHMMHeadImage.png"]]];
            } else {
                _myHeadImageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringToIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@" "].location]];
            }
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", @"myHMMHeadImage.png"]]]) {
                _myHeadImageView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", @"myHMMHeadImage.png"]]];
            } else {
                _myHeadImageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringToIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@" "].location]];
            }
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:[[self.mutArrOfData[indexPath.section] allKeys][0] substringToIndex:[[self.mutArrOfData[indexPath.section] allKeys][0] rangeOfString:@" "].location]];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = nil;
        UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        _myHeadImageView.userInteractionEnabled = YES;
        [_myHeadImageView addGestureRecognizer:tapImageView];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSArray *arrOfTyprEnglish = @[@"", NSLocalizedString(@"性别", nil), NSLocalizedString(@"生日", nil), NSLocalizedString(@"身高", nil), NSLocalizedString(@"体重", nil), NSLocalizedString(@"血型", nil), NSLocalizedString(@"单位制", nil)];
    cell.textLabel.text = arrOfTyprEnglish[indexPath.section];
    return cell;
} // cell
- (void)tapImage:(id)sender {
    HMMTakePicVC *myHMMTakePic = [HMMTakePicVC new];
    myHMMTakePic.isFromPersonInfo = YES;
    
    myHMMTakePic.myReturnBlockOfSelectedImage = ^(UIImage *comeLastImage) {
        NSString *resourcePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *realPath = [resourcePath stringByAppendingPathComponent:@"myHMMHeadImage.png"];
        
        NSData *imageData = UIImagePNGRepresentation(comeLastImage);
        [imageData writeToFile:realPath atomically:YES];
        NSLog(@"%@", NSHomeDirectory());
        _mutArrOfData[0] = @{@"myHMMHeadImage.png myHMMHeadImage.png":[_mutArrOfData[0] allObjects][0]};
        [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfData forKey:@"MyPersonalProfileSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _myHeadImageView.image = comeLastImage;
    };
    [self.navigationController pushViewController:myHMMTakePic animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = kRandomColor(0.0f);
    return view;
} // header view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = kRandomColor(0.0f);
    return view;
} // footer view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    } else {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return 15;
    } else if (section == 6) {
        return 0;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        [UIView animateWithDuration:0.5f animations:^{
            [self.view viewWithTag:111].transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f animations:^{
                [self.view viewWithTag:222].transform = CGAffineTransformMakeTranslation(0, -230);
                [self.view viewWithTag:999].transform = CGAffineTransformMakeTranslation(0, -230);
            } completion:^(BOOL finished) {
                
            }]; // _myDataPick 出现
        }]; // _myPickView 消失
        
        [self.myTableView setContentOffset:CGPointMake(0, -(kScreenHeight - 200 - (self.myTableView.frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.size.height)) + 30) animated:YES];
        self.myTableView.scrollEnabled = NO;
    } else {
        
        if (indexPath.section == 0) {
            //            self.numOfSelectedCell = indexPath.section + 1;
        } else {
            
            [UIView animateWithDuration:0.5f animations:^{
                [self.view viewWithTag:222].transform = CGAffineTransformMakeTranslation(0, 0);
                [self.view viewWithTag:999].transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5f animations:^{
                    [self.view viewWithTag:111].transform = CGAffineTransformMakeTranslation(0, -200);
                } completion:^(BOOL finished) {
                    
                }]; // _myPickView 出现
            }]; // _myDataPick 消失
            
            
            if (indexPath.section == 1) {
                self.numOfSelectedCell = indexPath.section;
            } else {
                self.numOfSelectedCell = indexPath.section - 1;
            }
            
            [self.myPickView reloadComponent:0];
            
            [self.myTableView setContentOffset:CGPointMake(0, -(kScreenHeight - 200 - (self.myTableView.frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.origin.y + [self.myTableView cellForRowAtIndexPath:indexPath].frame.size.height))) animated:YES];
            self.myTableView.scrollEnabled = NO;
        }
    }
    
    
    if (indexPath.section == 0) {
        UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, kScreenWidth - 120, [tableView cellForRowAtIndexPath:indexPath].bounds.size.height)];
        myTextField.delegate = self;
        [myTextField becomeFirstResponder];
        myTextField.textColor = kHexRGBAlpha(0xffffff, 1.0f);
        
        ((UILabel *)self.mutArrOfcellDetailLabel[indexPath.section]).text = myTextField.text;
        [[tableView cellForRowAtIndexPath:indexPath] addSubview:myTextField];
        
    }
    
} // did selected cell

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.myTableView.userInteractionEnabled = YES;
    self.myTableView.scrollEnabled = YES;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    ((UILabel *)self.mutArrOfcellDetailLabel[0]).text = @"";
    textField.placeholder = NSLocalizedString(@"智能表芯", nil);
    [textField setValue:kHexRGBAlpha(0xa2a2a2, 0.5f) forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    self.myTableView.scrollEnabled = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    ((UILabel *)self.mutArrOfcellDetailLabel[0]).text = textField.text;
    
    [textField removeFromSuperview];
    textField = nil;
    
    self.mutArrOfData[0] = @{[self.mutArrOfData[0] allKeys][0]:((UILabel *)self.mutArrOfcellDetailLabel[0]).text};
    
    // 保存
    [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfData forKey:@"MyPersonalProfileSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.numOfSelectedCell == 0) {
        return 0;
    } else {
        return [self.mutArrOfMyPickView[self.numOfSelectedCell - 1] count];
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"%ld", self.numOfSelectedCell);
    if (self.numOfSelectedCell == 0) {
        return @"设么都没有！！！";
    } else {
        return self.mutArrOfMyPickView[self.numOfSelectedCell - 1][row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.numOfSelectedCell == 0) {
        self.mutArrOfData[self.numOfSelectedCell - 1] = @{[self.mutArrOfData[self.numOfSelectedCell - 1] allKeys][0]:[NSString stringWithFormat:@"%@%@", [[self.mutArrOfData[self.numOfSelectedCell - 1] objectForKey:[self.mutArrOfData[self.numOfSelectedCell - 1] allKeys][0]] substringToIndex:4], self.mutArrOfMyPickView[self.numOfSelectedCell - 1][row]]};
    } else {
        if (self.numOfSelectedCell == 1) {
            self.mutArrOfData[self.numOfSelectedCell] = @{[self.mutArrOfData[self.numOfSelectedCell] allKeys][0]:[NSString stringWithFormat:@"%@%@", [[self.mutArrOfData[self.numOfSelectedCell] objectForKey:[self.mutArrOfData[self.numOfSelectedCell] allKeys][0]] substringToIndex:4], self.mutArrOfMyPickView[self.numOfSelectedCell - 1][row]]};
        } else {
            self.mutArrOfData[self.numOfSelectedCell + 1] = @{[self.mutArrOfData[self.numOfSelectedCell + 1] allKeys][0]:[NSString stringWithFormat:@"%@%@", [[self.mutArrOfData[self.numOfSelectedCell + 1] objectForKey:[self.mutArrOfData[self.numOfSelectedCell + 1] allKeys][0]] substringToIndex:4], self.mutArrOfMyPickView[self.numOfSelectedCell - 1][row]]};
        }
    } // 重新计算数组，刷新数据用
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view viewWithTag:111].transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self.myTableView setContentOffset:CGPointMake(0, -64) animated:YES];
        self.myTableView.scrollEnabled = YES;
    }]; // _myPickView 消失
    
    [self performSelector:@selector(delayRealodTableViewData) withObject:nil afterDelay:1.3];
    
    [_mySaveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    // 保存
    [[NSUserDefaults standardUserDefaults] setObject:self.mutArrOfData forKey:@"MyPersonalProfileSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)delayRealodTableViewData {
    [self.myTableView reloadData];
} // 延迟刷新数据

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
