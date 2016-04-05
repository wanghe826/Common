//
//  PersonalInformationVC.m
//  Common
//
//  Created by lixiaofeng on 16/3/23.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "PersonalInformationVC.h"
#import "PersonalTableViewCell.h"            //个人信息Cell
#import "FMDBHelper.h"                       //数据库
#import "HMMTakePicVC.h"                     //摄相视图

#define KWIDTH self.view.bounds.size.width   //视图宽度
#define KHIGHT self.view.bounds.size.height  //视图高度
#define KHIGHT2  36                          //cell的高度

@interface PersonalInformationVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView * tableView;              //tableView
@property(nonatomic,strong)NSMutableArray * informationArr;      //保存信息数组
@property(nonatomic,strong)NSMutableArray * protectArr;          //默认信息保存数组
@property(nonatomic,strong)UIView * headView;                    //头视图
@property(nonatomic,strong)UITextField * textField;              //输入框
@property(nonatomic,strong)UIView * bgView;                      //背景视图
@property(nonatomic,strong)NSMutableArray * dataSourceArr;       //保存数据资源
@property(nonatomic,strong)UIView * showView;                    //显示视图
@property(nonatomic,strong)NSMutableArray * selectArr;           //选择保存数组
@property(nonatomic,strong)UITableView  * selectTableView;       //滚动视图
@property(nonatomic,assign)NSInteger KHIGHT1;                    //记录当前页面数
@property(nonatomic,strong)UIDatePicker * selectBirDate;         //浏览生日
@property(nonatomic,strong)UIView *birBgView;                    //生日浏览背景界面
@property(nonatomic,strong)UILabel * dataLabel;                  //记录数据
@property(nonatomic,strong)NSArray * kdkdkkArr;                  //中间可
@property(nonatomic,assign)NSInteger currentCount;               //记录点击的cell的行数下标
@property(nonatomic,strong)NSString * dataString;                //保存数据
@property(nonatomic,strong)NSString * textStr;                   //保存输入框中的数据
@property(nonatomic,strong)UIAlertController * alertController;  //提示控制器
@property(nonatomic,strong)UIImageView * imageView;              //存储拍照后的照片
@property(nonatomic,strong)NSMutableArray  * informationData;
@property(nonatomic,strong)NSDictionary * dict;
@property(nonatomic,assign)NSInteger index;                                     //记录第一个tableview下标

@property (nonatomic, assign) BOOL isToAlbum;

@end

@implementation PersonalInformationVC

#pragma mark 懒加载
// 懒加载初始化selectBirDate
- (UIDatePicker *)selectBirDate {
    if (!_selectBirDate) {
        _selectBirDate = [[UIDatePicker alloc] init];
        _selectBirDate.frame = CGRectMake(0, KHIGHT -230, KWIDTH, 230);
        _selectBirDate.datePickerMode = UIDatePickerModeDate;
        _selectBirDate.tag = 222;
        _selectBirDate.minuteInterval = 5; // 时间间隔
        NSDate *minDate = [[NSDate alloc] initWithTimeIntervalSince1970:1];
        NSDate *maxDate = [[NSDate alloc] initWithTimeIntervalSince1970:11651651156];
        _selectBirDate.minimumDate = minDate;
        _selectBirDate.maximumDate = maxDate;
        [_selectBirDate setDate:[NSDate date] animated:YES];
        _selectBirDate.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _selectBirDate;
}

//懒加载保存数据资源
-(NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray new];
    }
    return _dataSourceArr;
}

//懒加载可变数组
-(NSMutableArray *)informationArr
{
    if (!_informationArr) {
        _informationArr = [NSMutableArray new];
        
        _informationArr = [NSMutableArray arrayWithArray:@[@{@"icon_sex.png icon_sex.png":@"性别  选择您的性别"}, @{@"icon_cake.png icon_cake.png":@"生日  输入您的生日"}, @{@"icon_height.png icon_height.png":@"身高  选择您的身高"}, @{@"icon_weight.png icon_weight.png":@"体重  输入您的体重"}, @{@"icon_blood_type.png icon_blood_type.png":@"血型  选择您的血型"},@{@"icon_system_of_units.png icon_system_of_units.png":@"单位制 选择您常用的单位制"}]];
    }
    return _informationArr;
}

//懒加载背景视图
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.frame = self.view.bounds;
        _bgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bgView];
        
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        tap.delegate = self;
        [_bgView addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeChange)];
        swipe.delegate = self;
        [_bgView addGestureRecognizer:swipe];
        _bgView.hidden = YES;                     //隐藏背景视图
        
    }
    return _bgView;
}

// 防止与cell点击方法重复
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    // NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

//视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;   //显示导航栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 改变状态栏颜色
    self.title = NSLocalizedString(@"个人", nil);
    
    _dict = @{@"Male":@"男",@"Female":@"女",@"Type A blood":@"A血型",@"Type B blood":@"B血型",@"Type AB blood":@"AB血型",@"Type O blood":@"O血型",@"Type H blood":@"H血型",@"Metric":@"公制",@"Inch":@"英制"};
    
    if (_protectArr.count == 0) {
        _protectArr =  [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"男", nil) ,@"1990-01-10",@"175cm",@"65kg",@"AB", NSLocalizedString(@"公制", nil),nil];
    }else
        [_protectArr removeAllObjects];
    //从数据库中加载数据
    [self getSearchDataFromFMDB];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isToAlbum) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; // 改变状态栏颜色
        _isToAlbum = NO;
    }
}

//从数据库中获取数据
-(void)getSearchDataFromFMDB
{
    NSArray * arr = [[FMDBHelper shareManager]queryAllWithName:KTableNameOne];
    if (arr.count == 0) {
        [[FMDBHelper shareManager]insertData:_protectArr andTableName:KTableNameOne andName:@"" andID:@"个人数据"];
        _textStr = @"";
    }else
    {
        [_protectArr removeAllObjects];
        for (int i = 0; i < arr.count; i++)
        {
            if (i < arr.count - 2)
            {
                NSString * str = [NSString new];
                NSString  *  strData = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"]objectAtIndex:0];
               
                if ([strData isEqualToString:@"zh-Hans"]||[strData isEqualToString:@"zh-Hans-US"])
                {
                       NSString * str11 = [_dict objectForKey:arr[i]];
                    if (str11)
                    {
                      NSString *  str999 = [NSString stringWithFormat:@"%@",NSLocalizedString(str11, nil)];
                        [_protectArr addObject:str999];
                    }else
                        [_protectArr addObject:arr[i]];
                    
                }else
                {
                 str = [NSString stringWithFormat:@"%@",NSLocalizedString(arr[i], nil)];
                [_protectArr addObject:str];
                }
                _textStr = arr[arr.count - 2];
            }
        }
    }
    [_tableView reloadData];
}

//视图已经加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectArr =  [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"选择性别", nil),NSLocalizedString(@"选择生日", nil),NSLocalizedString(@"选择身高", nil),NSLocalizedString(@"选择体重", nil),NSLocalizedString(@"选择血型", nil),NSLocalizedString(@"选择单位制", nil), nil];
    
    _informationData =[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"性别", nil),NSLocalizedString(@"生日", nil),NSLocalizedString(@"身高", nil),NSLocalizedString(@"体重", nil),NSLocalizedString(@"血型", nil),NSLocalizedString(@"单位制", nil), nil];

    
    self.view.backgroundColor = [UIColor blackColor];
    
    //创建选择项的数据源
    [self requestDataSelected];
    
    //个人界面GUI
    [self createPersonGUI];
}


#pragma mark 加载数据
// 创建选择项的数据源
- (void)requestDataSelected {
    
    //性别选择数据
    [self.dataSourceArr addObject:@[NSLocalizedString(@"男", nil), NSLocalizedString(@"女", nil)]];
    
    //身高选择数据
    NSMutableArray *mutArrOfPersonHeight = [NSMutableArray new];
    for (NSInteger i = 0; i < 250 - 60 + 1; i ++) {
        [mutArrOfPersonHeight addObject:[NSString stringWithFormat:@"%ldcm", 50 + i]];
    }
    [self.dataSourceArr addObject:mutArrOfPersonHeight];
    
    //体重选择数据
    NSMutableArray *mutArrOfPersonWeight = [NSMutableArray new];
    for (NSInteger i = 0; i < 250 - 30 + 1; i ++) {
        [mutArrOfPersonWeight addObject:[NSString stringWithFormat:@"%ldkg", 30 + i]];
    }
    [self.dataSourceArr addObject:mutArrOfPersonWeight];
    
    //血型选择数据
    [self.dataSourceArr addObject:@[NSLocalizedString(@"A血型", nil), NSLocalizedString(@"B血型", nil), NSLocalizedString(@"AB血型", nil), NSLocalizedString(@"O血型", nil), NSLocalizedString(@"H血型", nil)]];
    
    //单位制选择数据
    [self.dataSourceArr addObject:@[NSLocalizedString(@"公制", nil),NSLocalizedString(@"英制", nil)]];
}

#pragma mark bgViewClick  背景点击方法实现
//点击手势
-(void)tapClick
{
    [self isHide];
}

//上下拉手势
-(void)swipeChange
{
    [self isHide];
}

//隐藏图片
-(void)isHide
{
    [UIView animateWithDuration:0.2 animations:^{
        //隐藏透明层
        _bgView.hidden = YES;
        
        _birBgView.hidden = YES;
    }];
}

//显示图片
-(void)isShow:(NSInteger)number
{
    if (number == 0 || number > 1) {
        if (number > 1) {
            number = number - 1;
        }
        _selectBirDate.hidden = YES;  //隐藏UIDatePicker
        NSArray * arrrr= self.dataSourceArr[number];
        NSLog(@"%@",arrrr);
        if (arrrr.count < 5) {
            _KHIGHT1 = KHIGHT2 * arrrr.count + 40;
        }else
            _KHIGHT1 = 220;
        
        if (_showView != nil) {
            [_showView removeFromSuperview];      //将前一个视图从父视图中移除
        }
        _showView = [UIView new];
        _showView.frame = CGRectMake(0,KHIGHT - _KHIGHT1 , KWIDTH, _KHIGHT1);
        _showView.backgroundColor = [UIColor whiteColor];
        _showView.userInteractionEnabled = YES;
        [self.bgView addSubview:_showView];
        
        _kdkdkkArr = self.dataSourceArr[number];
        
        [self detailShowView:number];
        _bgView.hidden = NO;
        
    }else if(number == 1)
    {
        _selectBirDate.hidden = NO;    //显示UIDatePicker
        [self creatMyDataPick];        //生日显示界面
        _bgView.hidden = NO;           //显示背景
    }
}

//生日显示界面
- (void)creatMyDataPick {
    
    [self.bgView addSubview:self.selectBirDate];
    
    _birBgView = [[UIView alloc] initWithFrame:CGRectMake(0, KHIGHT - 230 - 39, KWIDTH, 39)];
    _birBgView .backgroundColor = [UIColor groupTableViewBackgroundColor];
    _birBgView .userInteractionEnabled = YES;
    _birBgView .tag = 999;
    [self.view addSubview:_birBgView ];
    [self.view bringSubviewToFront:_birBgView];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(10, 5, 65, 30);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_birBgView  addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * birLabel = [[UILabel alloc]initWithFrame:CGRectMake((KWIDTH - 180)/2, 5, 180, 30)];
    birLabel.text = _selectArr[1];
    birLabel.textColor = [UIColor lightGrayColor];
    birLabel.textAlignment = NSTextAlignmentCenter;
    birLabel.font = [UIFont systemFontOfSize:17];
    [_birBgView addSubview:birLabel];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(KWIDTH - 65 - 10, 5, 65, 30);
    confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_birBgView  addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * fengView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, KWIDTH, 1)];
    fengView.backgroundColor = [UIColor lightGrayColor];
    [_birBgView addSubview:fengView];
}

// 取消按钮
- (void)cancelBtnAction:(id)sender {
    
    [UIView animateWithDuration:1.0f animations:^{
        _bgView.hidden = YES;
        _birBgView.hidden = YES;
    }];
}

//确认按钮
-(void)confirmBtnAction:(UIButton *)button
{
    //隐藏生日显示视图
    [UIView animateWithDuration:1.0f animations:^{
        _bgView.hidden = YES;
        _birBgView.hidden = YES;
    }];
    
    //获取当前选择的日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:_selectBirDate.date];
    //保存点击cell的值
    [_protectArr replaceObjectAtIndex:1 withObject:destDateString];
    
    //更新数据
    [[FMDBHelper shareManager]updateData:_protectArr andTableName:KTableNameOne andName:_textField.text andID:@"个人数据"];
    
    [_tableView reloadData];
}

//详情显示界面
-(void)detailShowView:(NSInteger)index
{
    if (index >= 1) {
        index += 1;
    }
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 65, 30)];
    [cancelButton setTitle:NSLocalizedString(@"取消", nil)  forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchDown];
    [_showView addSubview:cancelButton];
    
    //选择Label
    UILabel * selectLabel =  [[UILabel alloc]initWithFrame:CGRectMake((KWIDTH - 180)/2, 5, 180, 30)];
    selectLabel.text = _selectArr[index];
    selectLabel.textColor = [UIColor lightGrayColor];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.font = [UIFont systemFontOfSize:17];
    [_showView addSubview:selectLabel];
    
    //确定按钮
    UIButton * nextButton = [[UIButton alloc]initWithFrame:CGRectMake(KWIDTH - 65 - 10, 5, 65, 30)];
    nextButton.tag = index;
    [nextButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [nextButton addTarget:self action:@selector(nextObjectButton:) forControlEvents:UIControlEventTouchDown];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_showView addSubview:nextButton];
    
    //分线割上下
    [self fengGeViewindex1:1];
    
    //创建表格视图
    [self createTableView:index];
}

//取消按钮点击方法
-(void)cancelButton
{
    [UIView animateWithDuration:1.0f animations:^{
        _bgView.hidden = YES;
        _birBgView.hidden = YES;
    }];
}

//确定钮点击方法
-(void)nextObjectButton:(UIButton *)sender
{
    //保存点击cell的值
    NSInteger ind = sender.tag;
    _dataString = _kdkdkkArr[_currentCount];
    [_protectArr replaceObjectAtIndex:ind withObject:_dataString];
    
    //更新数据
    [[FMDBHelper shareManager]updateData:_protectArr andTableName:KTableNameOne andName:_textField.text andID:@"个人数据"];
    
    [UIView animateWithDuration:1.0f animations:^{
        _bgView.hidden = YES;
        _birBgView.hidden = YES;
    }];
    [_tableView reloadData];
}

//创建表格视图
-(void)createTableView:(NSInteger)index
{
    _selectTableView = [[UITableView alloc]init];
    _selectTableView.dataSource = self;
    _selectTableView.delegate = self;
    _selectTableView.showsVerticalScrollIndicator = NO;
    _selectTableView.rowHeight = 36;
    _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏分割线
    _selectTableView.frame = CGRectMake(0, 41, KWIDTH, _KHIGHT1 - 41);
    [_showView addSubview:_selectTableView];
    [_selectTableView reloadData];                                       //刷新数据
}

//分割线
-(void)fengGeViewindex1:(NSInteger)ind
{
    if (ind == 1) {
        //分割线
        UIView * fengView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, KWIDTH, 1)];
        fengView1.backgroundColor = [UIColor lightGrayColor];
        [_showView addSubview:fengView1];
        
    }else if (ind == 2)
    {
        UIView * fengView2 = [[UIView alloc]initWithFrame:CGRectMake((KWIDTH - 40) / 2, (_KHIGHT1 - 80 ) / 2 - (_KHIGHT1 - 80 ) / 10 + 40, 40, 1)];
        fengView2.backgroundColor = [UIColor lightGrayColor];
        [_showView addSubview:fengView2];
        
        UIView * fengView3 = [[UIView alloc]initWithFrame:CGRectMake((KWIDTH - 40) / 2, (_KHIGHT1 - 80 ) / 2 + (_KHIGHT1 - 80 ) / 10 + 40, 40, 1)];
        fengView3.backgroundColor = [UIColor lightGrayColor];
        [_showView addSubview:fengView3];
        
    }else if (ind == 3)
    {
        UIView * fengView5 = [[UIView alloc]initWithFrame:CGRectMake((KWIDTH - 40) / 2, (_KHIGHT1 - 80 ) / 2 + 40, 40, 1)];
        fengView5.backgroundColor = [UIColor lightGrayColor];
        [_showView addSubview:fengView5];
        
    }else if (ind == 4)
    {
        UIView * fengView6 = [[UIView alloc]initWithFrame:CGRectMake((KWIDTH - 40) / 2, (_KHIGHT1 - 80)/2 + 40 , 40, 1)];
        fengView6.backgroundColor = [UIColor lightGrayColor];
        [_showView addSubview:fengView6];
    }
}

#pragma mark 个人界面GUI
-(void)createPersonGUI
{
    //创建UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.bounces = YES;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏分割线
    [self.view addSubview:_tableView];
    
}

#pragma mark  UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return 1;
    }else if(tableView == _selectTableView)
    {
        return 1;
    }
    return 0;
}

//组视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0) {
            return 130;
        }
        return 0;
    }else if(tableView == _selectTableView)
    {
        return 0;
    }
    return 0;
}

//分组头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0) {
            self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
            self.headView.userInteractionEnabled = YES;
            self.headView.backgroundColor = self.view.backgroundColor;
            
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSDictionary * dict = [user objectForKey:@"MyPersonalProfileSetting"];
            if (dict) {
                NSData * data = [dict objectForKey:@"myHMMHeadImage.png"];
                _imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
            }else
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_head_portrait.png"]];
            _imageView.userInteractionEnabled = YES;
            _imageView.layer.cornerRadius = 40;
            _imageView.layer.masksToBounds = YES;
            _imageView.frame = CGRectMake(20, 25, 80, 80);
            
            
            //添加手势
            UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            tapG.numberOfTapsRequired = 1;
            [_imageView addGestureRecognizer:tapG];
            
            [self.headView addSubview:_imageView];             //增加头视图
            
            //输入文本框
            _textField = [UITextField new];
            _textField.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, 45, 195, 30);
            _textField.placeholder =  NSLocalizedString(@"智能表芯", nil);
            [_textField setValue:kHexRGBAlpha(0xa2a2a2, 0.5f) forKeyPath:@"_placeholderLabel.textColor"];
            [_textField setValue:[UIFont boldSystemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];
            _textField.textColor = kHexRGBAlpha(0xffffff, 1.0);
            _textField.text = _textStr;
            _textField.keyboardType = UIKeyboardTypeDefault;
            _textField.delegate = self;
            [self.headView addSubview:_textField];
            
            UIImageView * fanxiangImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_inter.png"]];
            fanxiangImageView.frame = CGRectMake(KWIDTH - 26, 47, 21, 27);
            [self.headView addSubview:fanxiangImageView];
            return self.headView;
        }
        return nil;
    }else
        return nil;
}

//手势点击方法
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    _alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"更改头像", nil)  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HMMTakePicVC *myHMMTakePic = [HMMTakePicVC new];
        myHMMTakePic.isFromPersonInfo = YES;
        
        myHMMTakePic.myReturnBlockOfSelectedImage = ^(UIImage *comeLastImage) {
            NSString *resourcePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *realPath = [resourcePath stringByAppendingPathComponent:@"myHMMHeadImage.png"];
            
            NSData *imageData = UIImagePNGRepresentation(comeLastImage);
            [imageData writeToFile:realPath atomically:YES];
//            NSLog(@"965238745:%@", NSHomeDirectory());
            
            //保存照片
            NSData * data = UIImageJPEGRepresentation(comeLastImage, 1.0);
            NSDictionary * photoDic = @{@"myHMMHeadImage.png":data};
            
            [[NSUserDefaults standardUserDefaults] setObject:photoDic forKey:@"MyPersonalProfileSetting"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
             _imageView.image = comeLastImage;
        };
        [self.navigationController pushViewController:myHMMTakePic animated:YES];
    }];
    UIAlertAction * photoAlbum = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        picker.allowsEditing = YES;
        self.isToAlbum = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction * cancalAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [_alertController addAction:takePhotoAction];
    [_alertController addAction:photoAlbum];
    [_alertController addAction:cancalAction];
    
    [self presentViewController:_alertController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取用户点的的原图
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //获取用户编辑过后的照片
    UIImage *edit = info[UIImagePickerControllerEditedImage];
    
    UIImage * myImage = [UIImage new];
    if (edit) {
        myImage = edit;
    }else
    {
        myImage = image;
    }
    
    //UIImage --> PNG
    NSData *data = UIImagePNGRepresentation(myImage);
    
    /**
     上传照片的代码
     **/
     NSDictionary * photoDic = @{@"myHMMHeadImage.png":data};
    [[NSUserDefaults standardUserDefaults] setObject:photoDic forKey:@"MyPersonalProfileSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //回到上一个界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
    _imageView.image = [UIImage imageWithData:data];
    
}
//用户点击取消后会执行的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [[FMDBHelper shareManager]updateData:_protectArr andTableName:KTableNameOne andName:textField.text andID:@"个人数据"];
    [_textField resignFirstResponder];   //取消输入框的第一响应
    return YES;
}

#pragma mark UITableViewDelegate
//点击选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        if (indexPath.section == 0)
        {
            _index = indexPath.row;
            NSLog(@"index11:%ld",_index);
            //取消响应
            [_textField  resignFirstResponder];
            
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;      //去掉cell背景灰色
            
            switch (indexPath.row) {
                case 0:
                    _currentCount = 0;
                    break;
                case 2:
                    _currentCount = 25;
                    break;
                case 3:
                    _currentCount = 35;
                    break;
                case 4:
                    _currentCount = 2;
                    break;
                case 5:
                    _currentCount = 0;
                    break;
                    
                default:
                    break;
            }
            [self isShow:indexPath.row];
        }
    }else if(tableView == _selectTableView)
    {
        
        _currentCount = indexPath.row;
        
        NSLog(@"_currentCount11:%ld",_currentCount);
        
        if (_index == 5) {
            //使用通知进行传值（关于单位制）
            NSArray * arrrr = self.dataSourceArr[_index-1];
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            NSLog(@"klsdfjklas:%@",arrrr[_currentCount]);
            [center postNotificationName:@"unit system" object:nil userInfo:@{@"unit": arrrr[_currentCount]}];
        }
        
        [self.selectTableView reloadData];   //选中后重新加载数据
    }
}

- (UITableViewCellAccessoryType)tableView:(UITableView*)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == _tableView)
    {
        return  UITableViewCellAccessoryNone;
    }else
    {
        if(_currentCount == indexPath.row )
        {
            return UITableViewCellAccessoryCheckmark;
        }
        else
        {
            return UITableViewCellAccessoryNone;
        }
    }
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0) {
            return self.protectArr.count;
        }
        return 0;
    }else if(tableView == _selectTableView)
    {
        return _kdkdkkArr.count;
    }
    return 0;
}

//定义Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        static NSString * ID = @"PersonCell";
        PersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell =  [[[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:self options:nil]firstObject];
        }
        
        if (indexPath.section == 0) {
            
            cell.personImageView.image = [UIImage imageNamed:[[self.informationArr[indexPath.row] allKeys][0] substringToIndex:[[self.informationArr[indexPath.row] allKeys][0] rangeOfString:@" "].location]];
            cell.personText.text = _informationData[indexPath.row];
            cell.personText.font = [UIFont systemFontOfSize:16];
            cell.personText.textColor = [UIColor whiteColor];
            cell.detailPersonText.text = self.protectArr[indexPath.row];
            cell.detailPersonText.textColor = [UIColor whiteColor];
            cell.detailPersonText.font = [UIFont systemFontOfSize:16];
        }
        
        UIView *view1 = [[UIView alloc]initWithFrame:cell.frame];
        view1.backgroundColor = HexRGBAlpha(0x040b1d, 1);
        cell.backgroundView = view1;
        
        UIView *selectView = [[UIView alloc]initWithFrame:cell.frame];
        selectView.backgroundColor = HexRGBAlpha(0x060e24, 1);
        cell.selectedBackgroundView = selectView;
        
        return cell;
    } else if(tableView == _selectTableView)
        
    {
        static NSString * selectID = @"selectTableView";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:selectID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectID];
        }
        cell.textLabel.text = _kdkdkkArr[indexPath.row];
        
        //定位到具体的行
       // NSIndexPath * scrollIndexPath = [NSIndexPath indexPathForRow:_currentCount inSection:0];
      // [self.selectTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        return cell;
    }
    
    return nil;
}

@end


