//
//  ClockSelectedView.m
//  Common
//
//  Created by HuMingmin on 16/3/5.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//


#import "ClockSelectedView.h"

@interface ClockSelectedView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView_1;
@property (nonatomic, strong) UITableView *myTableView_2;
@property (nonatomic, strong) NSMutableArray *myTableViewMutArr;

@property (nonatomic, assign) CGFloat selfFramWidth;
@property (nonatomic, assign) CGFloat selfFramHeight;
@property (nonatomic, assign) CGFloat midDistanceWidth; // 中间间距宽度

@end

@implementation ClockSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _myTableViewMutArr = [NSMutableArray array];
        _midDistanceWidth = 10;
        
    }
    return self;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    _selfFramWidth = self.frame.size.width;
    _selfFramHeight = self.frame.size.height;
    [self createMyTableView]; // 创建 myTableView
}   

// 创建 createMyTableView
- (void)createMyTableView {
    for (NSInteger i = 0; i < _selectedNum; i ++) {
        UITableView *myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0 + i * ((_selfFramWidth - _midDistanceWidth * (_selectedNum - 1)) / _selectedNum + _midDistanceWidth), 0, (_selfFramWidth - _midDistanceWidth * (_selectedNum - 1)) / _selectedNum, _selfFramHeight) style:UITableViewStylePlain];
        myTabelView.tag = 303 + i;
        myTabelView.backgroundColor = kRandomColor(0.0f);
        myTabelView.delegate = self;
        myTabelView.dataSource = self;
        myTabelView.showsHorizontalScrollIndicator = NO;
        myTabelView.showsVerticalScrollIndicator = NO;
        myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:myTabelView];
        
        if (self.isSingle) {
            _huaDongLeDiJiGe = [self.tempArrOfHuaDongDiJiGe[i] integerValue];
        } else {
            _huaDongLeDiJiGe = [self.tempArrOfHuaDongDiJiGe[i] integerValue] + 2;
        }

        [myTabelView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_huaDongLeDiJiGe inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
//        UITableViewCell *cell = [myTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_huaDongLeDiJiGe inSection:0]];
//        NSLog(@"%ld😞", [self.tempArrOfHuaDongDiJiGe[i] integerValue] + 2);
//        NSLog(@"%@😞", cell);
//        cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
        self.myReturnBlockOfSelectedOfInfo(_huaDongLeDiJiGe);
        self.myReturnBlockOfSelected(myTabelView.tag - 303);
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(myTabelView.frame.size.width + myTabelView.frame.origin.x, 0, _midDistanceWidth, _selfFramHeight)];
        myLabel.text = @":";
        myLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
        myLabel.tag = 404 + i;
        myLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:myLabel];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_myLetfToRightEachNumMutArr[tableView.tag - 303] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%ld", (long)tableView.tag]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyCell%ld", (long)tableView.tag]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _myLetfToRightEachNumMutArr[tableView.tag - 303][indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.backgroundColor = kRandomColor(0.0f);
    cell.textLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.isSingle) {
        if (indexPath.row == ([self.tempArrOfHuaDongDiJiGe[tableView.tag - 303] integerValue])) {
            cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        }
    } else {
        if (indexPath.row == ([self.tempArrOfHuaDongDiJiGe[tableView.tag - 303] integerValue] + 2)) {
            cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _selfFramHeight / 5.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    self.huaDongLeDiJiGe = indexPath.row;
    
    self.myReturnBlockOfSelected(tableView.tag - 303);
    self.myReturnBlockOfSelectedOfInfo(_huaDongLeDiJiGe);
    
    for (NSInteger i = 0; i < [_myLetfToRightEachNumMutArr[tableView.tag - 303] count]; i ++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.textLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    if (indexPath.row >= [_myLetfToRightEachNumMutArr[tableView.tag - 303] count] - 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_myLetfToRightEachNumMutArr[tableView.tag - 303] count] - 2 - 1 inSection:0]];
        cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
    } else if (indexPath.row <= 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.huaDongLeDiJiGe = ((NSInteger)(scrollView.contentOffset.y)) / ((NSInteger)(_selfFramHeight / 5.0)) + 2;
//    NSLog(@"%ld", _huaDongLeDiJiGe);
    [((UITableView *)scrollView) selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.huaDongLeDiJiGe  inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    self.myReturnBlockOfSelectedOfInfo(_huaDongLeDiJiGe);
    
    
    for (NSInteger i = 0; i < [_myLetfToRightEachNumMutArr[scrollView.tag - 303] count]; i ++) {
        UITableViewCell *cell = [((UITableView *)scrollView) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.textLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    UITableViewCell *cell = [((UITableView *)scrollView) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_huaDongLeDiJiGe inSection:0]];
    cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
    cell.textLabel.font = [UIFont systemFontOfSize:20];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.huaDongLeDiJiGe = ((NSInteger)(scrollView.contentOffset.y)) / ((NSInteger)(_selfFramHeight / 5.0)) + 2;
//    NSLog(@"%ld", _huaDongLeDiJiGe);
    [((UITableView *)scrollView) selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.huaDongLeDiJiGe  inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    self.myReturnBlockOfSelectedOfInfo(_huaDongLeDiJiGe);
    
    
    for (NSInteger i = 0; i < [_myLetfToRightEachNumMutArr[scrollView.tag - 303] count]; i ++) {
        UITableViewCell *cell = [((UITableView *)scrollView) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.textLabel.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    UITableViewCell *cell = [((UITableView *)scrollView) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_huaDongLeDiJiGe inSection:0]];
    cell.textLabel.textColor = kHexRGBAlpha(0x2ea5ac, 1.0f);
    cell.textLabel.font = [UIFont systemFontOfSize:20];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.myReturnBlockOfSelected(scrollView.tag - 303);
}

@end
