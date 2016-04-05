//
//  AddRemindVC.m
//  Common
//
//  Created by Ling on 16/3/3.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "AddRemindVC.h"
#import "SmartRemindCell.h"
@interface AddRemindVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)UISwitch *mySwitch;
@property (nonatomic,strong)UITableView *tableView;//自定义tableview
@property (nonatomic,strong)NSMutableArray *dataSource;//app提醒数据源
@property (nonatomic,strong)NSMutableArray *dataImg;//图片数据源


@end

@implementation AddRemindVC


- (UISwitch *)mySwitch {
    if (!_mySwitch) {

    }
    return _mySwitch;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
   
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNavigationView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:AuthorizedSuccess object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:AuthorizedSuccess object:nil];
}
#pragma mark - 数据处理
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
        _dataSource = [NSMutableArray arrayWithArray: @[NSLocalizedString(@"新浪微博",nil),NSLocalizedString(@"腾讯微博",nil),NSLocalizedString(@"陌陌",nil),NSLocalizedString(@"知乎",nil),NSLocalizedString(@"Facebook",nil),NSLocalizedString(@"Twitter",nil),NSLocalizedString(@"Linkdle",nil),NSLocalizedString(@"Whatsapp",nil),NSLocalizedString(@"Tumblr",nil),NSLocalizedString(@"Line",nil)]];
       

    }
    return _dataSource;
}
- (NSMutableArray *)dataImg
{
    if (_dataImg == nil) {

        _dataImg = [NSMutableArray new];
 
        _dataImg = [NSMutableArray arrayWithArray:@[@"icon_reminder_xinlang_avr",
                                                    @"icon_reminder_tencent_avr",
                                                    @"icon_reminder_momo_avr",
                                                    @"icon_reminder_zhihu_avr",
                                                    @"icon_reminder_facebook_avr",
                                                    @"icon_reminder_twitter_avr",
                                                    @"icon_reminder_linkedIn_avr",
                                                    @"icon_reminder_whatsapp_avr",
                                                    @"icon_tumblr",
                                                    @"icon_line"
                                                    ]];

    }
    return _dataImg;
    
}

- (void)initView
{
    //创建tableview
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 0.5f;
    self.tableView.sectionFooterHeight = 0.5f;
    [self.view addSubview:self.tableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(-10, 0, 0, 0);

    //tableview添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top).with.offset(padding.top);
        make.left.mas_equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-padding.right);
        
    }];

}

- (void)initNavigationView
{
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,titleSize.width/3,titleSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGBAlpha(0xffffff, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"添加应用",nil);
    self.navigationItem.titleView = label;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSource.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SmartRemindCell *cell = [SmartRemindCell new];
    cell = [[[NSBundle mainBundle]loadNibNamed:@"SmartRemindCell" owner:self options:nil]lastObject];
    cell.txtLable.text = self.dataSource[indexPath.row];
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
    
    
    self.mySwitch = [UISwitch new];
    self.mySwitch.tag = indexPath.row;
    _mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _mySwitch.tintColor = kRandomColor(0.0f);
    _mySwitch.alpha = 1;
    
    [_mySwitch addTarget:self action:@selector(mySwitchAction:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:_mySwitch];
    [_mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell).with.insets(UIEdgeInsetsMake(10, kScreenWidth - 65, 0, 20));
    }];

    BOOL state = [[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"stateAdditionSave%ld",[_mySwitch tag]]];
    _mySwitch.on = state;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)mySwitchAction:(UISwitch *)stch {
    if(!ApplicationDelegate.currentPeripheral)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手表未连接",nil)];
        stch.on = !stch.on;
        return;
    }
    
    [WriteData2BleUtil syncAppRemindSwitch:ApplicationDelegate.currentPeripheral];
    [[NSUserDefaults standardUserDefaults]setBool:stch.on forKey:[NSString stringWithFormat:@"stateAdditionSave%ld",[stch tag]]];
    [[NSUserDefaults standardUserDefaults]synchronize];

    NSLog(@"----> %@", [NSString stringWithFormat:@"stateAdditionSave%ld",[stch tag]]);


}

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
