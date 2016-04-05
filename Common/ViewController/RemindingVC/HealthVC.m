//
//  HealthVC.m
//  Common
//
//  Created by Ling on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "HealthVC.h"
#import "NewHealthRemindVC.h"
#import "JiuZuoRemindVC.h"
#import "TakePillsRemindVC.h"

#import <Masonry.h>

@interface HealthVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *mutDataArr;
@property (nonatomic,strong) NSMutableArray *mutDetailDataArr;

@end



@implementation HealthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    [self creatMyTableView];
//    [self creatBottomView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      [self initNavigationView];
}
#pragma mark - 懒加载
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.sectionFooterHeight = 0.5;
        _myTableView.sectionHeaderHeight = 0.5;
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    return _myTableView;
}

- (NSMutableArray *)mutDataArr {
    if (!_mutDataArr) {
       
        _mutDataArr = [NSMutableArray new];
        _mutDataArr = [NSMutableArray arrayWithArray:@[@[NSLocalizedString(@"久坐提醒",nil)],@[NSLocalizedString(@"整点提醒",nil)],@[NSLocalizedString(@"睡眠提醒",nil)],@[NSLocalizedString(@"吃药提醒",nil)]]];
    }
    return _mutDataArr;
}
- (NSMutableArray *)mutDetailDataArr {
    if (!_mutDetailDataArr) {
       
        _mutDetailDataArr = [NSMutableArray new];
        _mutDetailDataArr = [NSMutableArray arrayWithArray:@[@[NSLocalizedString(@"每天08:00到12:00期间120分钟内不动手表将发出提醒",nil)],
                                                             @[NSLocalizedString(@"每到整点手表将发出提醒",nil)],
                                                             @[NSLocalizedString(@"每天23:00如检测到还未入睡手表将发出提醒",nil)],
                                                             @[NSLocalizedString(@"每天11:30时手表将发出提醒",nil)]]];
    }
    return _mutDetailDataArr;
}

#pragma mark - UI
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

- (void)initNavigationView {
    self.title = NSLocalizedString(@"健康提醒",nil);
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 40, 40);
    [addBtn setTitle:NSLocalizedString(@"添加",nil) forState:UIControlStateNormal];
    [addBtn setTitleColor:HexRGBAlpha(0xffffff, 1) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [addBtn addTarget:self action:@selector(customAddRemind) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)creatBottomView {
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(self.view.center.x - 15,30, 30, 30);
    [button addTarget:self action:@selector(customAddRemind) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    
    //创建添加按钮的背景
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    self.myTableView.tableFooterView = backView;
    self.myTableView.tableFooterView.frame = backView.frame;
    [self.myTableView.tableFooterView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //创建提示label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(button.frame),kScreenWidth , 60)];
    label.text = NSLocalizedString(@"点击加号,可以设置自定义提醒",nil);
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = HexRGBAlpha(0xa2a2a2, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.myTableView.tableFooterView addSubview:label];
}

- (void)customAddRemind {
    
    [self.navigationController pushViewController:[NewHealthRemindVC new] animated:YES];
}

- (void)mySwitchChange:(UISwitch *)stch {
    
    [[NSUserDefaults standardUserDefaults]setBool:stch.on forKey:[NSString stringWithFormat:@"healthSave%ld",[stch tag]]];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.mutDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"HealthCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text =  self.mutDataArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = HexRGBAlpha(0xffffff, 1);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UILabel *deLabel = [[UILabel alloc]init];
    deLabel.text = self.mutDetailDataArr[indexPath.section][indexPath.row];
    deLabel.font = [UIFont systemFontOfSize:10];
    deLabel.textColor = HexRGBAlpha(0xa2a2a2, 1);
    deLabel.numberOfLines = 0;
    deLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:deLabel];
    [deLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(36, 16, 0, 65));
        
    }];
    
    UIView *view1 = [[UIView alloc]initWithFrame:cell.frame];
    view1.backgroundColor = HexRGBAlpha(0x040b1d, 1);
    cell.backgroundView = view1;
    
    UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
    selectView.backgroundColor = HexRGBAlpha(0x060e25, 1);
    cell.selectedBackgroundView = selectView;
    
    UISwitch *mySwitch = [[UISwitch alloc]init];
    mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    mySwitch.tintColor = kRandomColor(0.0f);
    mySwitch.alpha = 1;
    mySwitch.tag = indexPath.section;
    [mySwitch addTarget:self action:@selector(mySwitchChange:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:mySwitch];
    [mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(14, kScreenWidth - 60, 0, 20));
    }];
    BOOL state = [[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"healthSave%ld",[mySwitch tag]]];
    mySwitch.on = state;
    
    return cell;    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[JiuZuoRemindVC new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[TakePillsRemindVC new] animated:YES];
            break;
        default:
            break;
    }
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
