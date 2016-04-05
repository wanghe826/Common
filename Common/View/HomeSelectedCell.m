//
//  HomeSelectedCell.m
//  运动健康Demo
//
//  Created by HMM－MACmini on 16/1/7.
//  Copyright © 2016年 HMM－MACmini. All rights reserved.
//

#import "HomeSelectedCell.h"

@interface HomeSelectedCell ()

@property (nonatomic, strong) UILabel *myLable; // tittle
@property (nonatomic, strong) UIImageView *myImageView; // myImageView

@end

@implementation HomeSelectedCell

// 懒加载初始化 myLable
- (UILabel *)myLable {
    if (!_myLable) {
        if (_isSpecial) {
            _myLable = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 40, self.frame.size.height / 2.0 - 15, self.frame.size.width / 2.0, 30)];
            _myLable.center = CGPointMake(self.frame.size.width / 2.0 + 30, self.frame.size.height / 2.0);
        } else {
            _myLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, self.frame.size.width, 30)];
        }
    }
    return _myLable;
}
// 懒加载初始化 myImageView
- (UIImageView *)myImageView {
    if (!_myImageView) {
        if (_isSpecial) {
            _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - (self.frame.size.height - 50) - 40, self.frame.size.height / 2.0 - (self.frame.size.height - 45) / 2.0, 55, 55)];
            _myImageView.center = CGPointMake(self.frame.size.width / 2.0 - 55, self.frame.size.height / 2.0);
            
            if (kScreenHeight == 480) {
                _myImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.7, 0.7), 0, -10);
            } else if (kScreenHeight == 568) {
                _myImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.75, 0.75), 0, -5);
            } else if (kScreenHeight == 736) {
                _myImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.1, 1.1), -20, 0);
            }
        } else {
            _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.myLable.center.x - (self.frame.size.height - 50) * 0.5 + 0, 10 + 15, 55, 55)];
            _myImageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
            
            if (kScreenHeight == 480) {
                _myImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.7, 0.7), 0, -10);
            } else if (kScreenHeight == 568) {
                _myImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.75, 0.75), 0, -5);
            } else if (kScreenHeight == 736) {
                _myImageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.1, 1.1), 0, 0);
            }
        }
    }
    return _myImageView;
}

- (void)drawRect:(CGRect)rect {
    self.myLable.font = [UIFont boldSystemFontOfSize:13];
    _myLable.textColor = kHexRGBAlpha(0x6a7ea1, 0.4);
    _myLable.backgroundColor = kRandomColor(0.0);
    _myLable.textAlignment = NSTextAlignmentCenter;
    _myLable.text = self.strOfTitle;
    _myLable.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_myLable];
    
    [self.myImageView setImage:[UIImage imageNamed:self.strOfImageName]];
    _myImageView.backgroundColor = kRandomColor(0.0f);
    _myImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_myImageView];
    
    if (!_isSpecial) {
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 10, 5, 10);
        [_myLable mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.edges.equalTo(self).with.insets(padding);
            // make.top.equalTo(self.mas_top).with.offset(padding.top); //with is an optional semantic filler
            make.left.equalTo(self.mas_left).with.offset(padding.left);
            make.bottom.equalTo(self.mas_bottom).with.offset(-padding.bottom);
            make.right.equalTo(self.mas_right).with.offset(-padding.right);
        }];
        
        _myImageView.center = CGPointMake(_myLable.center.x, _myImageView.center.y);
    }
}

@end
