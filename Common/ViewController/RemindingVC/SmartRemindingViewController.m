//
//  SmartRemindingViewController.m
//  Common
//
//  Created by Ling on 16/1/8.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SmartRemindingViewController.h"
#import "SmartRemindCell.h"
#import "AddRemindVC.h"

@interface SmartRemindingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;//自定义tableview
@property (nonatomic,strong)NSMutableArray *mutDataArr;//app提醒数据源
@property (nonatomic,strong)NSMutableArray *dataImg;//图片数据源
@property (nonatomic,strong)UISwitch *mySwitch;
@property (nonatomic,strong)NSMutableDictionary *showDic;

@end

@implementation SmartRemindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGBAlpha(0x030919, 1);

    [self initView];
    [self initNavigationView];
//    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:_tableView selector:@selector(reloadData) name:AuthorizedSuccess object:nil];
   
//    [self addBleObserver];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_tableView name:AuthorizedSuccess object:nil];
}

- (void) babyDelegate {
    [_baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
    }];
}

#pragma mark - 数据处理

- (NSMutableArray *)mutDataArr
{
    if (_mutDataArr == nil) {
        _mutDataArr = [NSMutableArray new];
        
        _mutDataArr = [NSMutableArray arrayWithArray: @[NSLocalizedString(@"勿扰模式",nil),NSLocalizedString(@"邮件提醒",nil),NSLocalizedString(@"短信提醒",nil),NSLocalizedString(@"来电提醒",nil),NSLocalizedString(@"微信提醒",nil),NSLocalizedString(@"QQ",nil)]];
    }
    return _mutDataArr;
}
- (NSMutableArray *)dataImg {
    if (_dataImg == nil) {
        _dataImg = [NSMutableArray new];
        _dataImg = [NSMutableArray arrayWithArray: @[@"icon_aaronli",@"icon_email",@"icon_message",@"icon_telephone",@"icon_wechat",@"icon_reminder_qq_avr"]];
    }
    return _dataImg;
}
- (UISwitch *)mySwitch {
    if (!_mySwitch) {
    }
    return _mySwitch;
}

#pragma mark - UI
- (void)initNavigationView {
    self.title = NSLocalizedString(@"智能提醒",nil);
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 40, 40);
    [addBtn setTitle:NSLocalizedString(@"添加",nil) forState:UIControlStateNormal];
    [addBtn setTitleColor:HexRGBAlpha(0xffffff, 1) forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [addBtn addTarget:self action:@selector(addRemindings:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)initView
{
    //创建tableview
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.backgroundColor = [UIColor clearColor];

    self.tableView.sectionFooterHeight = 0.5f;
    self.tableView.sectionHeaderHeight = 0.5f;

    [self.view addSubview:self.tableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //tableview添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top).with.offset(padding.top);
        make.left.mas_equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-padding.right);
        
    }];
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.mutDataArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmartRemindCell *cell = [SmartRemindCell new];
    cell = [[[NSBundle mainBundle]loadNibNamed:@"SmartRemindCell" owner:self options:nil]lastObject];
    cell.txtLable.text = self.mutDataArr[indexPath.row];
    cell.txtLable.textColor = HexRGBAlpha(0xffffff, 1);
    cell.txtLable.font = [UIFont systemFontOfSize:16];
    cell.imgView.image = [UIImage imageNamed:self.dataImg[indexPath.row]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view1 = [[UIView alloc]initWithFrame:cell.frame];
    view1.backgroundColor = HexRGBAlpha(0x040b1d, 1);
    cell.backgroundView = view1;
    
    UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
    selectView.backgroundColor = HexRGBAlpha(0x060e24, 1);
    cell.selectedBackgroundView = selectView;
    
    // 创建switch按钮
    self.mySwitch = [UISwitch new];
    _mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _mySwitch.tintColor = kRandomColor(0.0f);
    _mySwitch.alpha = 1;
    _mySwitch.tag = indexPath.row;

    [_mySwitch addTarget:self action:@selector(mySwitchAction:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:_mySwitch];
    [_mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(10, kScreenWidth - 65, 0, 20));
    }];

    BOOL state = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"stateSave%ld",[_mySwitch tag]]];
    _mySwitch.on = state;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 处理事件
//switch处理事件

- (void)mySwitchAction:(UISwitch *)sender
{
    
//    if(!ApplicationDelegate.hasPaired)
    if(!ApplicationDelegate.currentPeripheral) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手表未连接",nil)];
        sender.on = !sender.on;
        return;
    }
    [WriteData2BleUtil syncAppRemindSwitch:ApplicationDelegate.currentPeripheral];
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:[NSString stringWithFormat:@"stateSave%ld", (long)[sender tag]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"--%@", [NSString stringWithFormat:@"stateSave%ld",(long)[sender tag]]);
    
    
//    [WriteData2BleUtil BLENotiflyType:[[NSUserDefaults standardUserDefaults] boolForKey:@"stateSave0"] startTime:[NSDate date] endTime:[NSDate date]];
}

- (void)addRemindings:(UIButton *)button {
    [self.navigationController pushViewController:[AddRemindVC new] animated:YES];
}

@end
