//
//  IDCardVC.m
//  Common
//
//  Created by Ling on 16/2/19.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "IDCardVC.h"

@interface IDCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *_textField;
}


@property (nonatomic,strong)UITableView *myTableview;//自定义tableview
@property (nonatomic,strong)NSMutableArray *mutArrData;//数据源
@property (nonatomic,strong)UIButton *saveBtn;//保存按钮
@property (nonatomic,strong)NSArray *DetailDataArr;


@end

@implementation IDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavView];
    [self creatMyTableview];
    [self creatSaveBtn];
}

- (UITableView *)myTableview {
    
    if (_myTableview == nil) {
      
        _myTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableview.frame = self.view.bounds;
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        _myTableview.estimatedRowHeight = 45;
        _myTableview.sectionFooterHeight = 1.0;
        _myTableview.sectionHeaderHeight = 1.0;
        _myTableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _myTableview;
}

- (NSMutableArray *)mutArrData {
    
    if (_mutArrData == nil) {
        
         _mutArrData = [NSMutableArray new];
        
        _mutArrData = [NSMutableArray arrayWithArray:@[
                                   @{@"card_icon_name_avr、card_icon_name_sel":@"姓名、"},
                                   @{@"card_icon_cellphone_avr、card_icon_cellphone_sel":@"电话、"},
                                   @{@"card_icon_mailbox_avr、card_icon_mailbox_sel":@"邮箱、"},
                                   @{@"card_icon_company_avr、card_icon_company_sel":@"公司、"}]];
    }
    return _mutArrData;
}

- (NSArray *)DetailDataArr {
    
    if (_DetailDataArr == nil) {
        
        _DetailDataArr = [NSArray new];
        
        _DetailDataArr = @[@[@"填写您的名字"],@[@"填写您的联系电话"],@[@"填写您的邮箱地址"],@[@"填写您的公司名称"]];
    }
    return _DetailDataArr;
}



- (void)initNavView {
    
    self.title = @"名片";
}

//自定义tableview
- (void)creatMyTableview {
    
    [self.view addSubview:self.myTableview];
    
    [self.myTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"IDCardTableViewCell"];
    _myTableview.separatorInset = UIEdgeInsetsMake(20, 30, 20, 30);

    UIEdgeInsets edge = UIEdgeInsetsMake(-15, 0, 0, 0);
    
    [self.myTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(edge.top);
        make.left.mas_equalTo(self.view.mas_top).with.offset(edge.left);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-edge.bottom);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-edge.right);
        
    }];
    

}

//创建保存按钮
- (void)creatSaveBtn {
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    backView.backgroundColor = self.myTableview.tableFooterView.backgroundColor;
    self.saveBtn.frame = CGRectMake(30, 45, kScreenWidth - 30 * 2, 40);
    self.saveBtn.backgroundColor = kHexRGBAlpha(0x004581, 1.0);
    [self.saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.saveBtn];
    [self.saveBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.saveBtn.clipsToBounds = YES;
    self.saveBtn.layer.cornerRadius = 10;
    self.myTableview.tableFooterView = backView;
    self.myTableview.tableFooterView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30 * 2, 40));
        
    }];
    
}

//保存按钮的点击事件
- (void)saveBtnAction {
    
    
    
}


#pragma mark - UITextFieldDelegate
//回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.mutArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"IDCardTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
    }
    cell.imageView.image = [UIImage imageNamed:[[self.mutArrData[indexPath.section] allKeys][0] substringToIndex:[[self.mutArrData[indexPath.section] allKeys][0] rangeOfString:@"、"].location]];

    cell.textLabel.text = [[self.mutArrData[indexPath.section]objectForKey:[self.mutArrData[indexPath.section]allKeys][0]]substringToIndex:2];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = kHexRGBAlpha(0x4a4a4a, 1.0);
    cell.textLabel.numberOfLines = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _textField = [[UITextField alloc]init];
    _textField.tag = 1000;
    _textField.delegate = self;
    _textField.placeholder =  self.DetailDataArr[indexPath.section][indexPath.row];
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.font = [UIFont systemFontOfSize:13];
    _textField.textColor = kHexRGBAlpha(0x4a4a4a, 1.0);
    _textField.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:_textField];

    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).with.offset(5);
        make.right.mas_equalTo(cell.mas_right).with.offset(-15);
        make.height.equalTo(@35);
        make.width.equalTo(@260);
    }];
    return cell;
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
