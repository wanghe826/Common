//
//  ZhouYueSleepContainTableViewCell.m
//  Common
//
//  Created by HMM－MACmini on 16/2/26.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "ZhouYueSleepContainTableViewCell.h"

@interface ZhouYueSleepContainTableViewCell ()

@property (nonatomic, strong) UIView *myBackView; // 柱状图

@property (nonatomic, strong) CALayer *layerOfDeep;
@property (nonatomic, strong) CALayer *layerOfQian;
@property (nonatomic, strong) CALayer *layerOfXinZhe;
@property (nonatomic, strong) CALayer *layerOfLast;


@property (nonatomic, strong) CALayer *layerOfSportNum; // 运动界面 Layer 数据
@property (nonatomic, strong) UILabel *myTextLabelDisplay; // 数据 label 显示

@end

@implementation ZhouYueSleepContainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  给一个'数组'做升序、此时的数组元素比较特别，可以自行打印
 *
 *  @param mutArr 传入数组
 *
 *  @return 返回排序的'某个'数组
 */
- (NSArray *)wantArrOfOneToN:(NSMutableArray *)mutArr1 {
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0;  i < mutArr1.count; i ++) {
        [values addObject:[mutArr1[i] objectForKey:[mutArr1[i] allKeys][0]]];
    }
    return [values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] > [obj2 floatValue] ) {
            return NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue] ) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (void)drawRect:(CGRect)rect {
    if (_isSportVC) {

        [self.layerOfSportNum removeFromSuperlayer];
        self.layerOfSportNum = nil;
        [self.layerOfLast removeFromSuperlayer];
        self.layerOfLast = nil;
        
        [self.myTextLabelDisplay removeFromSuperview];
        self.myTextLabelDisplay = nil;
        
        
        CGFloat all = self.frame.size.width;
        CGFloat numOfAllDataMax = [[self wantArrOfOneToN:_mutArrOfT][_mutArrOfT.count - 1] floatValue]; // 最大值
        
        self.layerOfSportNum = [CALayer layer];
        if (_isZhou) {

            self.layerOfSportNum.frame = CGRectMake(self.frame.size.width - ((self.frame.size.width - 40) * ([[_mutArrOfT[_myIndex.row] allObjects][0] integerValue] / numOfAllDataMax)), self.frame.size.height / 3.0, (self.frame.size.width - 40) * ([[_mutArrOfT[_myIndex.row] allObjects][0] integerValue] / numOfAllDataMax), self.frame.size.height / 3.0);
        } else {
            self.layerOfSportNum.frame = CGRectMake(self.frame.size.width - (self.frame.size.width * ([[_mutArrOfT[_myIndex.row] allObjects][0] integerValue] / numOfAllDataMax)), self.frame.size.height / 3.0, self.frame.size.width * ([[_mutArrOfT[_myIndex.row] allObjects][0] integerValue] / numOfAllDataMax), self.frame.size.height / 3.0);
        }
        
        [self.layer addSublayer:self.layerOfSportNum];
        self.layerOfSportNum.backgroundColor = HexRGBAlpha(0x16709D, 0.7f).CGColor;
        
        if (_isZhou) {
            if (_isZhou) {
                
                self.myTextLabelDisplay = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - ((self.frame.size.width - 40) * ([[_mutArrOfT[_myIndex.row] allObjects][0] integerValue] / numOfAllDataMax)) - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
            } else {
//                self.myTextLabelDisplay = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - (self.frame.size.width * ([[_mutArrOfT[_myIndex.row] allObjects][0] integerValue] / numOfAllDataMax)) - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
            }
            
            self.myTextLabelDisplay.adjustsFontSizeToFitWidth = YES;
            self.myTextLabelDisplay.text = [NSString stringWithFormat:@"%@步", [_mutArrOfT[_myIndex.row] allObjects][0]];
            self.myTextLabelDisplay.transform = CGAffineTransformMakeRotation(-M_PI_2);
            self.myTextLabelDisplay.backgroundColor = kRandomColor(0.0f);
            self.myTextLabelDisplay.textColor = kHexRGBAlpha(0xd95536, 1.0);
            self.myTextLabelDisplay.alpha = 0;
            [self addSubview:self.myTextLabelDisplay];
        }

    } else {
        //    if (_isZhou) {
        //        [self.myBackView removeFromSuperview];
        //        self.myBackView = nil;
        //        self.myBackView = [UIView new];
        //        self.myBackView.backgroundColor = kRandomColor(0.6f);
        //        int distance = arc4random_uniform((int)self.bounds.size.width);
        ////        self.myBackView.frame = CGRectMake(self.bounds.size.width - distance, (self.frame.size.height) / (3.0), distance, (self.frame.size.height) / (3.0));
        //        self.myBackView.frame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height) / (3.0));
        //        [self addSubview:_myBackView];
        
        
        [self.layerOfDeep removeFromSuperlayer];
        self.layerOfDeep = nil;
        [self.layerOfQian removeFromSuperlayer];
        self.layerOfQian = nil;
        [self.layerOfXinZhe removeFromSuperlayer];
        self.layerOfXinZhe = nil;
        [self.layerOfLast removeFromSuperlayer];
        self.layerOfLast = nil;
        
        
        CGFloat all = self.frame.size.width;
        
        self.layerOfLast = [[CALayer alloc] init];
        self.layerOfLast.frame = CGRectMake(0, (self.frame.size.height) / (3.0), all * ([[_mutArrOfT[_myIndex.row] objectForKey:[NSString stringWithFormat:@"%ld", _myIndex.row]][3] intValue] / 24.0), (self.frame.size.height) / (3.0));
        [self.layer addSublayer:self.layerOfLast];
        self.layerOfLast.backgroundColor = kHexRGBAlpha(0xffffff, 0.0f).CGColor;
        
        self.layerOfXinZhe = [CALayer layer];
        self.layerOfXinZhe.frame = CGRectMake(self.layerOfLast.frame.size.width, (self.frame.size.height) / (3.0), all * ([[_mutArrOfT[_myIndex.row] objectForKey:[NSString stringWithFormat:@"%ld", _myIndex.row]][2] intValue] / 24.0), (self.frame.size.height) / (3.0));
        [self.layer addSublayer:self.layerOfXinZhe];
        self.layerOfXinZhe.backgroundColor = HexRGBAlpha(0x19bc9d, 0.6f).CGColor;
        
        self.layerOfQian = [CALayer layer];
        self.layerOfQian.frame = CGRectMake(self.layerOfXinZhe.frame.size.width + self.layerOfXinZhe.frame.origin.x, (self.frame.size.height) / (3.0), all * ([[_mutArrOfT[_myIndex.row] objectForKey:[NSString stringWithFormat:@"%ld", _myIndex.row]][1] intValue] / 24.0), (self.frame.size.height) / (3.0));
        [self.layer addSublayer:self.layerOfQian];
        self.layerOfQian.backgroundColor = HexRGBAlpha(0x0687e1, 0.6f).CGColor;
        
        self.layerOfDeep = [CALayer layer];
        self.layerOfDeep.frame = CGRectMake(self.layerOfQian.frame.size.width + self.layerOfQian.frame.origin.x, (self.frame.size.height) / (3.0), all * ([[_mutArrOfT[_myIndex.row] objectForKey:[NSString stringWithFormat:@"%ld", _myIndex.row]][0] intValue] / 24.0), (self.frame.size.height) / (3.0));
        [self.layer addSublayer:self.layerOfDeep];
        self.layerOfDeep.backgroundColor = HexRGBAlpha(0xbfa875, 0.6f).CGColor;
        
        //    }
        //    else {
        //        [self.myBackView removeFromSuperview];
        //        self.myBackView = nil;
        //        self.myBackView = [UIView new];
        //        self.myBackView.backgroundColor = kRandomColor(0.6f);
        //        int distance = arc4random_uniform((int)self.bounds.size.width);
        //        self.myBackView.frame = CGRectMake(self.bounds.size.width - distance, (self.frame.size.width) / (_mounthDay * 3.0), distance, (self.frame.size.width) / (_mounthDay * 3.0));
        //        [self addSubview:_myBackView];
        
        
        //    }
    }
}

// 刷新 UI 操作
- (void)refreshUI:(NSIndexPath *)indexPath {

    if (_isSportVC) {
        self.layerOfSportNum.backgroundColor = kHexRGBAlpha(0xd95536, 1.0).CGColor;
        self.myTextLabelDisplay.alpha = 1.0f;
    } else {
        self.layerOfLast.backgroundColor = kHexRGBAlpha(0xffffff, 0.0f).CGColor;
        self.layerOfXinZhe.backgroundColor = HexRGBAlpha(0x19bc9d, 1.0f).CGColor;
        self.layerOfQian.backgroundColor = HexRGBAlpha(0x0687e1, 1.0f).CGColor;
        self.layerOfDeep.backgroundColor = HexRGBAlpha(0xbfa875, 1.0f).CGColor;
    }
}
// 刷新 UI 操作
- (void)refreshUIA:(NSIndexPath *)indexPathA {

    if (_isSportVC) {
        self.layerOfSportNum.backgroundColor = kHexRGBAlpha(0x16709D, 0.7).CGColor;
        self.myTextLabelDisplay.alpha = 0;
    } else {
        self.layerOfLast.backgroundColor = kHexRGBAlpha(0xffffff, 0.0f).CGColor;
        self.layerOfXinZhe.backgroundColor = HexRGBAlpha(0x19bc9d, 0.6f).CGColor;
        self.layerOfQian.backgroundColor = HexRGBAlpha(0x0687e1, 0.6f).CGColor;
        self.layerOfDeep.backgroundColor = HexRGBAlpha(0xbfa875, 0.6f).CGColor;
    }
}
@end
