//
//  UltravioletDetailCell.m
//  Common
//
//  Created by HuMingmin on 16/3/1.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "UltravioletDetailCell.h"

@interface UltravioletDetailCell ()

@property (nonatomic, strong) UILabel *myLabelOne; // 最左边第一个 UILabel
@property (nonatomic, strong) UILabel *myLabelTwo; // 最左边第二个 UILabel
@property (nonatomic, strong) UILabel *myLabelThree; // 最左边第三个 UILabel
@property (nonatomic, strong) UILabel *myLabelFour; // 最左边第四个 UILabel

@end

@implementation UltravioletDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    
    if (!_myLabelTwo) {
        self.myLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, self.frame.size.height)];
        _myLabelOne.font = [UIFont boldSystemFontOfSize:13];
        _myLabelOne.adjustsFontSizeToFitWidth = YES;
        _myLabelOne.textColor = HexRGBAlpha(0xffffff, 1.0);
        _myLabelOne.text = [NSString stringWithFormat:@"%02d月%02d日", arc4random_uniform(12) + 1, arc4random_uniform(27) + 1];
        [self addSubview:_myLabelOne];
        
        self.myLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(20 + _myLabelOne.frame.size.width + 10, 0, 50, self.frame.size.height)];
        _myLabelTwo.font = [UIFont boldSystemFontOfSize:11];
        _myLabelTwo.text = [NSString stringWithFormat:@"%02d:%02d", arc4random_uniform(25), arc4random_uniform(60)];
        _myLabelTwo.textColor = kHexRGBAlpha(0xe1dfdf, 1.0);
        _myLabelTwo.adjustsFontSizeToFitWidth  = YES;
        [self addSubview:_myLabelTwo];
        
        self.myLabelThree = [[UILabel alloc] initWithFrame:CGRectMake(_myLabelTwo.frame.size.width + _myLabelTwo.frame.origin.x, 0, self.frame.size.width - _myLabelTwo.frame.size.width - _myLabelTwo.frame.origin.x - 50, self.frame.size.height)];
        _myLabelThree.textAlignment = NSTextAlignmentRight;
        _myLabelThree.textColor = HexRGBAlpha(0xf84e34, 1.0);
        _myLabelThree.font = [UIFont boldSystemFontOfSize:18];
        _myLabelThree.text = [NSString stringWithFormat:@"%02d.", arc4random_uniform(12) + 1];
        [self addSubview:_myLabelThree];
        
        self.myLabelFour = [[UILabel alloc] initWithFrame:CGRectMake(_myLabelThree.frame.size.width, 2, 40, self.frame.size.height)];
        _myLabelFour.font = [UIFont boldSystemFontOfSize:12];
        _myLabelFour.text = @"0";
        _myLabelFour.textColor = HexRGBAlpha(0xf84e34, 1.0);
        [_myLabelThree addSubview:_myLabelFour];
    }
}

@end
