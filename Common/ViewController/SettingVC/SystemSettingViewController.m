//
//  SystemSettingViewController.m
//  Common
//
//  Created by Ling on 16/1/8.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "SystemSettingCell.h"
#import "equipmentUpdateVC.h"
#import "FunctionInstruction.h"
#import "EnterWebsite.h"

@interface SystemSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)NSMutableArray *DetailData;

@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    _dataSource = @[NSLocalizedString(@"应用版本",nil),NSLocalizedString(@"设备固件版本",nil),NSLocalizedString(@"设备电量",nil),NSLocalizedString(@"功能说明",nil),NSLocalizedString(@"访问官网",nil)];
    
    NSString* appVersion = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    self.DetailData = [[NSMutableArray alloc] initWithArray:@[appVersion,NSLocalizedString(@"请连接手表",nil),NSLocalizedString(@"请连接手表",nil),NSLocalizedString(@"",nil),NSLocalizedString(@"",nil)]];
}

- (void)refreshView {
    NSString* version = NSLocalizedString(@"请连接手表",nil);
    NSString* battery = NSLocalizedString(@"请连接手表",nil);
    if(ApplicationDelegate.firmwareVersion) version = ApplicationDelegate.firmwareVersion;
    if(ApplicationDelegate.firmwareBattery!=0) battery = [NSString stringWithFormat:@"%d", ApplicationDelegate.firmwareBattery];
    _DetailData[1] = version;
    _DetailData[2] = battery;
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   [self initNavigationView];
    
    [self refreshView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:RefreshFirmwareBatteryAndVersion object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshFirmwareBatteryAndVersion object:nil];
}

- (void)initNavigationView
{

    self.title = NSLocalizedString(@"关于系统",nil);

    self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
}

//tableview视图加载
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0.5f;
    _tableView.sectionFooterHeight = 0.5f;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    SystemSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SystemSettingCell" owner:self options:nil]lastObject];
    }
    cell.txtLabel.text = self.dataSource[indexPath.row];
    cell.numLabel.text = self.DetailData[indexPath.row];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.txtLabel.textColor = HexRGBAlpha(0xffffff, 1);
    cell.txtLabel.font = [UIFont systemFontOfSize:16];
    cell.numLabel.textColor = HexRGBAlpha(0xa2a2a2, 1);
    cell.numLabel.font = [UIFont systemFontOfSize:16];
    cell.numLabel.numberOfLines = 0;
  
    UIView *view1 = [[UIView alloc]initWithFrame:cell.frame];
    view1.backgroundColor = HexRGBAlpha(0x040b1d, 1);
    cell.backgroundView = view1;
    
    UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
    selectView.backgroundColor = HexRGBAlpha(0x060e24, 1);
    cell.selectedBackgroundView = selectView;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,175)];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
    imgView.frame = CGRectMake((kScreenWidth - 100)/2,10,100, 100);
    [headerView addSubview:imgView];
    

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(imgView.frame)+ 10,kScreenWidth, 29)];
    label.text = NSLocalizedString(@"智能科技",nil);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = label.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)HexRGBAlpha(0x4cdac4, 1).CGColor,HexRGBAlpha(0x009ef4, 1).CGColor, nil];
    gradient.startPoint = CGPointMake(0, 1);
    gradient.endPoint = CGPointMake(1, 1);
    [headerView.layer addSublayer:gradient];
    
    gradient.mask = label.layer;
    label.frame = gradient.bounds;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[equipmentUpdateVC new] animated:YES];
    }else if (indexPath.row == 3) {
        [self.navigationController pushViewController:[FunctionInstruction new] animated:YES];
    }else if (indexPath.row == 4) {
        [self.navigationController pushViewController:[EnterWebsite new] animated:YES];
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
