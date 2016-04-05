//
//  MyNewClockVC.m
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "MyNewClockVC.h" // 闹钟选择界面

#import "MyNewClockCell.h" // 自定义闹钟选择界面 cell

#import "MyNewClockSettingVC.h" // 闹钟设置界面

#import "MJRefresh.h"

@interface MyNewClockVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTabelView;

@property (nonatomic, strong) NSMutableArray *mutArrAllInfo;

@property (nonatomic, strong) NSMutableArray *mySwitchAllArr; // 各个开关的存储状态

@end

@implementation MyNewClockVC

- (NSMutableArray *)mutArrAllInfo {
    if (!_mutArrAllInfo) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"AllClockInfo"]) {
            _mutArrAllInfo = [NSMutableArray array];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"AllClockInfo"]];
            
            for (NSInteger i = 0; i < arr.count; i ++) {
                NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr[i][0]];
                NSMutableArray *arr2 = [NSMutableArray arrayWithArray:arr[i][1]];
                NSMutableString *str = [NSMutableString stringWithString:arr[i][2]];
                NSMutableArray *tempArr1 = [NSMutableArray arrayWithArray:[NSMutableArray arrayWithArray:@[arr1, arr2, str]]];
                [_mutArrAllInfo addObject:tempArr1];
            }

        } else {
            _mutArrAllInfo = [NSMutableArray array];
            for (NSInteger i = 0; i < 3; i ++) {
                NSMutableArray *arr1 = [NSMutableArray arrayWithArray:@[@"02", @"02"]];
                NSMutableArray *arr2 = [NSMutableArray arrayWithArray:@[@"1", @"1", @"1", @"1", @"1", @"1", @"1"]];
                NSMutableString *str = [NSMutableString stringWithString:@"0"];
                [_mutArrAllInfo addObject:[NSMutableArray arrayWithArray:@[arr1, arr2, str]]];
            }
        }
    }
    return _mutArrAllInfo;
}

- (NSMutableArray *)mySwitchAllArr {
    if (!_mySwitchAllArr) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mySwitchSave"]) {
            _mySwitchAllArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"mySwitchSave"]];
        } else {
            _mySwitchAllArr = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0"]];
        }
    }
    return _mySwitchAllArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.title = NSLocalizedString(@"健康闹钟", nil);
    
    [self createMyTabeleView]; // 创建闹钟选择界面的 TableView UI
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self addClockObserver];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:self.mutArrAllInfo forKey:@"AllClockInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:self.mySwitchAllArr forKey:@"mySwitchSave"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  创建闹钟选择界面的 TableView UI
 */
- (void)createMyTabeleView {
    self.myTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTabelView.delegate = self;
    self.myTabelView.dataSource = self;
    self.myTabelView.backgroundColor = kRandomColor(0.0f);
    [self.myTabelView registerNib:[UINib nibWithNibName:@"MyNewClockCell" bundle:nil] forCellReuseIdentifier:@"MyNewClockCell"];
    [self.view addSubview:self.myTabelView];
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestClockData:1];
    }];

    [header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"正在同步闹钟...", nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"正在刷新数据中...", nil) forState:MJRefreshStateRefreshing];
    self.myTabelView.mj_header = header;
}

#pragma mark - 
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNewClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyNewClockCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kHexRGBAlpha(0x040b1d, 1.0f);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell refreshUI1:self.mutArrAllInfo andIndexPath:indexPath];
    cell.myIndexPath = indexPath;
    cell.myReturnBlockIsOn = ^(BOOL isON, NSInteger section) {
        if(!ApplicationDelegate.currentPeripheral)
        {
           self.mySwitchAllArr[section] = [NSString stringWithFormat:@"%d", !isON];
            [self.myTabelView  reloadData];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手表未连接", nil)];
            return ;
        }
        
        self.mySwitchAllArr[section] = [NSString stringWithFormat:@"%d", isON];
        [[NSUserDefaults standardUserDefaults] setObject:self.mySwitchAllArr forKey:@"mySwitchSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self asyncClockToWatch:section];
        
    };
    [cell refreshUI2:self.mySwitchAllArr andIndexPath:indexPath];
    return cell;
}

#pragma mark - 
#pragma mnak - UITableViewDelegate
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
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 7.5;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyNewClockSettingVC *myMyNewClockSettingVC = [MyNewClockSettingVC new];
    myMyNewClockSettingVC.numOfSelectedClock = indexPath.section + 1;
    
    __block NSIndexPath *tempIndexPath;
    myMyNewClockSettingVC.myReturnBlockOfAllInfo = ^(NSArray *arrOfInfo) {
        tempIndexPath = indexPath;
        NSMutableArray *tempMutArr = [NSMutableArray array];
        for (NSInteger i = 0; i < arrOfInfo.count; i ++) {
            if (i != arrOfInfo.count - 1) {
                [tempMutArr addObject:[NSMutableArray arrayWithArray:arrOfInfo[i]]];
            } else {
                [tempMutArr addObject:[NSMutableString stringWithString:arrOfInfo[i]]];
            }
        }
        self.mutArrAllInfo[tempIndexPath.section] = [NSMutableArray arrayWithArray:tempMutArr];
        [self.myTabelView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.mutArrAllInfo forKey:@"AllClockInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    
    [self.navigationController pushViewController:myMyNewClockSettingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma 闹钟的蓝牙操作
- (void) requestClockData:(int)index{
    if(!ApplicationDelegate.currentPeripheral || ApplicationDelegate.isC007)
    {
        [self.myTabelView.mj_header endRefreshing];
        return;
    }
    [WriteData2BleUtil requestAlarmWithIndex:index withPeripheral:ApplicationDelegate.currentPeripheral];
}

- (void) addClockObserver{
    __weak typeof(self) weakSelf = self;
    
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"闹钟---> %@", characteristic.value);
        Byte* recBytes = (Byte*)[characteristic.value bytes];
        [weakSelf decodeBytesInAlarm:recBytes];
    }];
    
    [_baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if(error)
        {
            NSLog(@"写入错误--> %@", error);
            return ;
        }
        NSLog(@"闹钟写入成功--> %@", characteristic.value);
    }];
}


- (void)decodeBytesInAlarm:(Byte*)recBytes
{
    if(recBytes[0]==0x24 && recBytes[1]==0x09 && recBytes[2]==0x02 && recBytes[3]==0x19 && recBytes[4]==0x02)
    {
        //时
        int hour = recBytes[5];
        NSString* hourStr = [NSString stringWithFormat:@"%d", hour];
        if(hour<10){
            hourStr = [@"0" stringByAppendingString:hourStr];
        }
        //分
        int min = recBytes[6];
        NSString* minuteStr = [NSString stringWithFormat:@"%d", min];
        if(min<10){
            minuteStr = [@"0" stringByAppendingString:minuteStr];
        }
        //星期
        NSString* str1 = recBytes[7]&0x80 ? @"1" : @"0";        //周日
        NSString* str2 = recBytes[7]&0x40 ? @"1" : @"0";
        NSString* str3 = recBytes[7]&0x20 ? @"1" : @"0";
        NSString* str4 = recBytes[7]&0x10 ? @"1" : @"0";
        NSString* str5 = recBytes[7]&0x08 ? @"1" : @"0";
        NSString* str6 = recBytes[7]&0x04 ? @"1" : @"0";
        NSString* str7 = recBytes[7]&0x02 ? @"1" : @"0";
        NSArray* weekArray = @[str1,str2,str3,str4,str5,str6,str7];
        
        //是否重复
        int isRepeat = recBytes[8];
        int isClockOpen = recBytes[10];
        int index = recBytes[9];
       
        NSLog(@"1->%@", @[hourStr, minuteStr]);
        NSLog(@"2->%@", weekArray);
        
        
        _mutArrAllInfo[index-1][0] = @[hourStr, minuteStr];
        _mutArrAllInfo[index-1][1] = weekArray;
        _mySwitchAllArr[index-1] = [NSString stringWithFormat:@"%d", isClockOpen];
        
        [self.myTabelView reloadData];
        
        if(index!=3)
        {
            [self requestClockData:index+1];
        }
        else
        {
            [self.myTabelView.mj_header endRefreshing];
        }
    }
}

- (void) asyncClockToWatch:(NSUInteger)index
{
    Byte clock1[12] = {'$', 0x09, 0x02, 0x09, 0x01};
    NSString* hourStr = [_mutArrAllInfo[index][0] firstObject];
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    UInt16 hourHex = strtoul([hourStr UTF8String],0,16);
    clock1[5] = hourHex;
    int minute = [[_mutArrAllInfo[index][0] lastObject] intValue];
    NSString* minuteStr = [NSString stringWithFormat:@"%x", minute];
    UInt16 minuteHex = strtoul([minuteStr UTF8String], 0, 16);
    clock1[6] = minuteHex;
    UInt16 dayHex = 0x00;
    
    NSArray* array2  = _mutArrAllInfo[index][1];

    if([array2[0] isEqualToString:@"1"])    dayHex |= 0x80;
    if([array2[1] isEqualToString:@"1"])    dayHex |= 0x40;
    if([array2[2] isEqualToString:@"1"])    dayHex |= 0x20;
    if([array2[3] isEqualToString:@"1"])    dayHex |= 0x10;
    if([array2[4] isEqualToString:@"1"])    dayHex |= 0x08;
    if([array2[5] isEqualToString:@"1"])    dayHex |= 0x04;
    if([array2[6] isEqualToString:@"1"])    dayHex |= 0x02;
    
    clock1[7] = dayHex;
    if([_mySwitchAllArr[index] isEqualToString:@"1"]){
        clock1[8] = 0x01;
    }else{
        clock1[8] = 0x00;
    }
    
    if(index == 0){
        clock1[9] = 0x01;
    }else if (index == 1){
        clock1[9] = 0x02;
    }else{
        clock1[9] = 0x03;
    }
    if([_mySwitchAllArr[index] isEqualToString:@"1"]){
        clock1[10] = 0x01;
    }else{
        clock1[10] = 0x00;
    }
    UInt16 checkSum = clock1[3] + clock1[4] + clock1[5] + clock1[6] + clock1[7] + clock1[8] + clock1[9] + clock1[10];
    clock1[11] = checkSum;
    
    Byte c007[14] = {'#', 0x01, 0x08, 0x31, 0x81, 0x01, 0x01, 0x11};
    c007[8] = hourHex;
    c007[9] = minuteHex;
    c007[10] = 0x00;
    if([_mySwitchAllArr[index] isEqualToString:@"1"]){
        clock1[11] = 0x01;
    }else{
        clock1[11] = 0x00;
    }
    c007[12] = 0x00;
    c007[13] = 0xaa;
    
    NSData* data = [NSData dataWithBytes:clock1 length:12];
    if(ApplicationDelegate.isC007)
    {
        data = [NSData dataWithBytes:c007 length:14];
    }
    
    CBCharacteristic* ch = [WriteData2BleUtil characteristicByUUID:ApplicationDelegate.currentPeripheral svUUID:TOUCHUAN_COMMAND_SERVICE_UUID chUUID:CHANNEL_2];
    [ApplicationDelegate.currentPeripheral writeValue:data forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
}

/*收到MCU发来的闹钟信息  Byte clock1[12] = {'$', 0x09, 0x02, 0x09, 0x01};
if(recBytes[0]==0x24 && recBytes[1]==0x09 && recBytes[2]==0x02 && recBytes[3]==0x19 && recBytes[4]==0x02)
{
    ClockModel* model = [[ClockModel alloc] init];
    int hour = recBytes[5];
    NSString* hourStr = [NSString stringWithFormat:@"%d", hour];
    if(hour<10){
        hourStr = [@"0" stringByAppendingString:hourStr];
    }
    int min = recBytes[6];
    NSString* minuteStr = [NSString stringWithFormat:@"%d", min];
    if(min<10){
        minuteStr = [@"0" stringByAppendingString:minuteStr];
    }
    model.clockTime = [[hourStr stringByAppendingString:@":"] stringByAppendingString:minuteStr];
    
    NSMutableString* clockDate = [[NSMutableString alloc] initWithCapacity:10];
    [clockDate appendString:recBytes[7]&0x80 ? NSLocalizedString(@"周日 ", @"") : @""];
    [clockDate appendString:recBytes[7]&0x40 ? NSLocalizedString(@"周一 ", @"") : @""];
    [clockDate appendString:recBytes[7]&0x20 ? NSLocalizedString(@"周二 ", @"") : @""];
    [clockDate appendString:recBytes[7]&0x10 ? NSLocalizedString(@"周三 ", @"") : @""];
    [clockDate appendString:recBytes[7]&0x08 ? NSLocalizedString(@"周四 ", @"") : @""];
    [clockDate appendString:recBytes[7]&0x04 ? NSLocalizedString(@"周五 ", @"") : @""];
    [clockDate appendString:recBytes[7]&0x02 ? NSLocalizedString(@"周六 ", @"") : @""];
    model.clockDate = clockDate;
    model.isClockRepeat = [NSNumber numberWithBool:recBytes[8]];
    NSLog(@"-----mmmmmm----> %@", model.isClockRepeat);
    model.isClockOpen = [NSNumber numberWithBool:recBytes[10]];
    
    int clockIndex = recBytes[9];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshClockData" object:nil userInfo:@{@"clock":model,@"index":[NSNumber numberWithInt:clockIndex]}];
    
}
 */

/*
- (NSData*) assembleClockData:(int)index
{
    ClockModel* model = [self.clockModelArray objectAtIndex:index];
    Byte clock1[12] = {'$', 0x09, 0x02, 0x09, 0x01};
    NSArray* array = [model.clockTime componentsSeparatedByString:@":"];
    int hour = [[array objectAtIndex:0] intValue];
    NSString* hourStr = [NSString stringWithFormat:@"%x", hour];
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    UInt16 hourHex = strtoul([hourStr UTF8String],0,16);
    clock1[5] = hourHex;
    //    strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    //    unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    
    int minute = [[array objectAtIndex:1] intValue];
    NSString* minuteStr = [NSString stringWithFormat:@"%x", minute];
    UInt16 minuteHex = strtoul([minuteStr UTF8String], 0, 16);
    clock1[6] = minuteHex;
    
    UInt16 dayHex = 0x00;
    NSArray* array2 = [model.clockDate componentsSeparatedByString:@" "];
    for(NSString* dayStr in array2){
        if ([[AppUtils getCurrentLanguagesStr] isEqualToString:@"en-CN"])
        {
            if([dayStr isEqualToString:@"Mon"]){
                dayHex |= 0x40;
            }else if([dayStr isEqualToString:@"Tus"]){
                dayHex |= 0x20;
            }else if([dayStr isEqualToString:@"Wed"]){
                dayHex |= 0x10;
            }else if ([dayStr isEqualToString:@"Thu"]){
                dayHex |= 0x08;
            }else if([dayStr isEqualToString:@"Fri"]){
                dayHex |= 0x04;
            }else if([dayStr isEqualToString:@"Sat"]){
                dayHex |= 0x02;
            }else if([dayStr isEqualToString:@"Sun"]){
                dayHex |= 0x80;
            }
        }
        else
        {
            if([dayStr isEqualToString:@"周一"]){
                dayHex |= 0x40;
            }else if([dayStr isEqualToString:@"周二"]){
                dayHex |= 0x20;
            }else if([dayStr isEqualToString:@"周三"]){
                dayHex |= 0x10;
            }else if ([dayStr isEqualToString:@"周四"]){
                dayHex |= 0x08;
            }else if([dayStr isEqualToString:@"周五"]){
                dayHex |= 0x04;
            }else if([dayStr isEqualToString:@"周六"]){
                dayHex |= 0x02;
            }else if([dayStr isEqualToString:@"周日"]){
                dayHex |= 0x80;
            }
        }
        
    }
    clock1[7] = dayHex;
    if([model.isClockRepeat boolValue]){
        clock1[8] = 0x01;
    }else{
        clock1[8] = 0x00;
    }
    
    if(index == 0){
        clock1[9] = 0x01;
    }else if (index == 1){
        clock1[9] = 0x02;
    }else{
        clock1[9] = 0x03;
    }
    if([model.isClockOpen boolValue]){
        clock1[10] = 0x01;
    }else{
        clock1[10] = 0x00;
    }
    UInt16 checkSum = clock1[3] + clock1[4] + clock1[5] + clock1[6] + clock1[7] + clock1[8] + clock1[9] + clock1[10];
    clock1[11] = checkSum;
    NSData* data = [NSData dataWithBytes:clock1 length:12];
    return data;
}
 */

@end
