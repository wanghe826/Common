//
//  JiuZuoRemindVC.m
//  Common
//
//  Created by Ling on 16/3/8.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "JiuZuoRemindVC.h"

#import "ClockSelectedView.h"

@interface JiuZuoRemindVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView    * myTableView;
@property (nonatomic,strong) NSMutableArray * mutDataArr;
@property (nonatomic,strong) NSMutableArray * mutDetailDataArr;

@property (nonatomic, strong) UIView *backView; // 黑色遮罩

@property (nonatomic, assign) NSInteger num1;
@property (nonatomic, assign) NSInteger num2;

@end

@implementation JiuZuoRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMyTableView];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.mutDetailDataArr forKey:kSedentarySave];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self initNavigationView];
}
- (void)initNavigationView {
   self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width/3,titleSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGBAlpha(0xffffff, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.text= NSLocalizedString(@"久坐编辑",nil);
    self.navigationItem.titleView = label;
}
- (void)creatMyTableView {
    [self.view addSubview:self.myTableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(-10, 0, 0, 0);
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(padding.top);
        make.left.mas_equalTo(self.view).with.offset(padding.left);
        make.bottom.mas_equalTo(self.view).with.offset(-padding.bottom);
        make.right.mas_equalTo(self.view).with.offset(-padding.right);
    }];
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.sectionFooterHeight = 0.5;
        _myTableView.sectionHeaderHeight = 0.5;
    }
    return _myTableView;
}

- (NSMutableArray *)mutDataArr {
    if (!_mutDataArr) {
        _mutDataArr = [NSMutableArray arrayWithArray:@[@[NSLocalizedString(@"久坐时长",nil)],@[NSLocalizedString(@"开始时间",nil)],@[NSLocalizedString(@"结束时间",nil)]]];
    }
    return _mutDataArr;
}

- (NSMutableArray *)mutDetailDataArr {
    if (!_mutDetailDataArr) {
        NSMutableArray *tempArr = [[NSUserDefaults standardUserDefaults] objectForKey:kSedentarySave];
        if (tempArr) {
            _mutDetailDataArr = [NSMutableArray arrayWithArray:tempArr];
        } else {
            _mutDetailDataArr = [NSMutableArray arrayWithArray:@[@"0", @"00:00", @"00:00"]];
        }
    }
    return _mutDetailDataArr;
}

#pragma mark - UITableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutDataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *KCellJiuZuoID = @"KCellJiuZuoID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCellJiuZuoID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:KCellJiuZuoID];
    }
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = self.mutDataArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor =  HexRGBAlpha(0xffffff, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *view1 = [[UIView alloc]initWithFrame:cell.frame];
    view1.backgroundColor = HexRGBAlpha(0x040b1d, 1);
    cell.backgroundView = view1;
    
    UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
    selectView.backgroundColor = HexRGBAlpha(0x060e24, 1.0f);
    cell.selectedBackgroundView = selectView;
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", self.mutDetailDataArr[indexPath.section], NSLocalizedString(@"分钟", nil)];
    } else {
        cell.detailTextLabel.text = self.mutDetailDataArr[indexPath.section];
    }
    cell.detailTextLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self initSelView:1 andIndexRow:indexPath.section]; // 2各的
    } else {
        [self initSelView:2 andIndexRow:indexPath.section]; // 2各的
    }
}

- (void)initSelView:(NSInteger)howMuchNum andIndexRow:(NSInteger)indexSection {
    ClockSelectedView *selView = [ClockSelectedView new];
    selView.selectedNum = howMuchNum;
    selView.tag = 314001;
    selView.frame = CGRectMake(0, kScreenHeight / 2.0 + 60 + (kScreenHeight), kScreenWidth, kScreenHeight / 2.0 - 60);
    selView.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);
    [UIView animateWithDuration:0.25f animations:^{
        selView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    }];
    
    NSMutableArray *mutArrOfAllSelItemss = [NSMutableArray new];
    for (NSInteger i = 0; i < 3; i ++) {
        NSMutableArray *mutArrOfEach = [NSMutableArray new];
        NSInteger tempDistanceMin = 0; // 初始值
        NSInteger canSlectedNum = 0; // 第几个啦
        NSInteger distance = 0; // 值的间距
        switch (i) {
            case 0: {
                canSlectedNum = 25;
                distance = 5;
                break;
            }
            case 1: {
                canSlectedNum = 24;
                distance = 1;
                break;
            }
            case 2: {
                canSlectedNum = 60;
                distance = 1;
                break;
            }
            default:
                break;
        }
        for (NSInteger j = 0; j < canSlectedNum + 2 * 2; j ++) {
            if (j < 2 || j > canSlectedNum + 1) {
                [mutArrOfEach addObject:@""];
            } else {
                tempDistanceMin += distance;
                if (i == 0) {
                    [mutArrOfEach addObject:[NSString stringWithFormat:@"%ld", tempDistanceMin - distance]];
                } else {
                    [mutArrOfEach addObject:[NSString stringWithFormat:@"%02ld", tempDistanceMin - distance]];
                }
            }
        }
        [mutArrOfAllSelItemss addObject:mutArrOfEach];
    }
    
    if (howMuchNum == 1) {
        selView.myLetfToRightEachNumMutArr = [NSMutableArray arrayWithArray:@[mutArrOfAllSelItemss[0]]];
    } else {
        selView.myLetfToRightEachNumMutArr = [NSMutableArray arrayWithArray:@[mutArrOfAllSelItemss[1], mutArrOfAllSelItemss[2]]];
    }

    __block typeof(self) weakSelf = self;
    selView.myReturnBlockOfSelected = ^(NSInteger num) {
        NSLog(@"%ld", num);
        if (indexSection == 0) {
            weakSelf.num1 = num;
        } else {
            weakSelf.num1 = num;
        }
    };
    selView.myReturnBlockOfSelectedOfInfo = ^(NSInteger num) {
        NSLog(@"%ld", num);
        if (indexSection == 0) {
            if (num > 24 + 2) {
                weakSelf.mutDetailDataArr[indexSection] = @"120";
            } else {
                weakSelf.mutDetailDataArr[indexSection] = [NSString stringWithFormat:@"%ld", [mutArrOfAllSelItemss[indexSection][num] integerValue]];
            }
            [weakSelf.myTableView reloadData];
        } else {
            if (weakSelf.num1 == 0) {
                if (num > 23 + 2) {
                    weakSelf.mutDetailDataArr[indexSection] = [NSString stringWithFormat:@"23:%02ld", [[weakSelf.mutDetailDataArr[indexSection] substringFromIndex:3] integerValue]];
                } else {
                    weakSelf.mutDetailDataArr[indexSection] = [NSString stringWithFormat:@"%02ld:%02ld", [mutArrOfAllSelItemss[weakSelf.num1 + 1][num] integerValue], [[weakSelf.mutDetailDataArr[indexSection] substringFromIndex:3] integerValue]];
                }
                [weakSelf.myTableView reloadData];
            } else if (weakSelf.num1 == 1) {
                if (num > 59 + 2) {
                    weakSelf.mutDetailDataArr[indexSection] = [NSString stringWithFormat:@"%02ld:59", [[weakSelf.mutDetailDataArr[indexSection] substringToIndex:2] integerValue]];
                } else {
                    weakSelf.mutDetailDataArr[indexSection] = [NSString stringWithFormat:@"%02ld:%02ld", [[weakSelf.mutDetailDataArr[indexSection] substringToIndex:2] integerValue], [mutArrOfAllSelItemss[weakSelf.num1 + 1][num] integerValue]];
                }
                [weakSelf.myTableView reloadData];
            }
            // NSLog(@"%@", weakSelf.mutDetailDataArr);
        }
    };
    
    
    // titleView
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backView.backgroundColor = kHexRGBAlpha(0x000000, 0.4);
    [[UIApplication sharedApplication].windows[1] addSubview:_backView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2.0 + (kScreenHeight), kScreenWidth, 60)];
    view.backgroundColor = kHexRGBAlpha(0xffffff, 1.0f);
    view.userInteractionEnabled = YES;
    [_backView addSubview:view];
    [UIView animateWithDuration:0.25f animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    }];
    
    UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1, kScreenWidth, 1)];
    separateView.backgroundColor = kHexRGBAlpha(0xa2a2a2, 0.5f);
    [view addSubview:separateView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth / 2.0 - 20 * 2, 60)];
    label.backgroundColor = kRandomColor(0.0f);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    label.font = [UIFont systemFontOfSize:16];
    label.text = NSLocalizedString(@"开始时间", nil);
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth - 70, kScreenHeight / 2.0 + (kScreenHeight), 50, 60);
    btn.backgroundColor = kRandomColor(0.0f);
    btn.tag = 314002;
    [btn setTitle:NSLocalizedString(@"下一项", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:kHexRGBAlpha(0x000000, 1.0f) forState:UIControlStateNormal];
    [[UIApplication sharedApplication].windows[1] addSubview:btn];
    [UIView animateWithDuration:0.25f animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
    }];
    
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapClcik:)];
    [_backView addGestureRecognizer:tapGesA];
    
    [[UIApplication sharedApplication].windows[1] addSubview:selView];
    
    if (indexSection == 0) {
        // 分钟 label
        UILabel *myFenzhongLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + 40, 1000, 50, 20)];
        myFenzhongLabel.backgroundColor = kRandomColor(0.0f);
        myFenzhongLabel.text = NSLocalizedString(@"分钟", nil);
        myFenzhongLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
        myFenzhongLabel.font = [UIFont systemFontOfSize:20];
        myFenzhongLabel.tag = 314003;
        [[UIApplication sharedApplication].windows[1] addSubview:myFenzhongLabel];
        [UIView animateWithDuration:0.25f animations:^{
            myFenzhongLabel.frame = CGRectMake(kScreenWidth / 2.0 + 40, selView.frame.origin.y + selView.frame.size.height / 2.0 - 10, 50, 20);
        }];
    }
}
- (void)nextBtnAction:(id)sender {
     [self dismissTapClcik:nil];
//    [self tableView:self.myTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
} // 下一项按钮
- (void)dismissTapClcik:(id)sender {
    for (UIView *view in _backView.subviews) {
        [UIView animateWithDuration:0.25 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
            [[UIApplication sharedApplication].windows[1] viewWithTag:314001].transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
            [[UIApplication sharedApplication].windows[1] viewWithTag:314002].transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
            [[UIApplication sharedApplication].windows[1] viewWithTag:314003].transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [_backView removeFromSuperview];
            [[[UIApplication sharedApplication].windows[1] viewWithTag:314001] removeFromSuperview];
            [[[UIApplication sharedApplication].windows[1] viewWithTag:314002] removeFromSuperview];
            [[[UIApplication sharedApplication].windows[1] viewWithTag:314003] removeFromSuperview];
        }];
    }
} // 见面小时手势

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
