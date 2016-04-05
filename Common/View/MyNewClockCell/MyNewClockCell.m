//
//  MyNewClockCell.m
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "MyNewClockCell.h"

@interface MyNewClockCell ()

@property (weak, nonatomic) IBOutlet UIView *myLeftBackView;
@property (weak, nonatomic) IBOutlet UISwitch *mySitch;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UILabel *mySubTitle;
@property (weak, nonatomic) IBOutlet UILabel *myClockTime;
@property (weak, nonatomic) IBOutlet UILabel *myLabelOfAM;
@property (weak, nonatomic) IBOutlet UILabel *myLabelOfPM;

@end

@implementation MyNewClockCell

- (void)awakeFromNib {
    // Initialization code
    
    _myLeftBackView.clipsToBounds = YES;
    _myLeftBackView.layer.cornerRadius = _myLeftBackView.frame.size.width / 2.0;
    _myLeftBackView.layer.borderWidth = 2;
    _myLeftBackView.backgroundColor = kRandomColor(0.0f);
    [_myLeftBackView setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
    _myLeftBackView.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];

    _myLabelOfAM.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    _myLabelOfAM.backgroundColor = kRandomColor(0.0f);
    _myLabelOfPM.backgroundColor = kRandomColor(0.0f);
    _myLabelOfPM.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    
    _myClockTime.adjustsFontSizeToFitWidth = YES;
    _myClockTime.textColor = kHexRGBAlpha(0xffffff, 1.0f);
    _myClockTime.backgroundColor = kRandomColor(0.0f);

    _myTitle.adjustsFontSizeToFitWidth = YES;
    _myTitle.textColor = kHexRGBAlpha(0xffffff, 1.0f);
    _myTitle.font = [UIFont boldSystemFontOfSize:16];

    _mySubTitle.adjustsFontSizeToFitWidth = YES;
    _mySubTitle.font = [UIFont boldSystemFontOfSize:10];
    _mySubTitle.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    
     _mySitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
     _mySitch.tintColor = kRandomColor(0.0f);
    _mySitch.alpha = 1;

}
- (IBAction)mySwichValueChange:(id)sender {
    if (![sender isOn]) {
        self.myReturnBlockIsOn(NO, self.myIndexPath.section);

    } else {
        self.myReturnBlockIsOn(YES, self.myIndexPath.section);

    }
}


- (void)refreshUI2:(NSMutableArray *)arrOfAllSwitch andIndexPath:(NSIndexPath *)indexPath {
    [_mySitch setOn:[arrOfAllSwitch[indexPath.section] boolValue] animated:YES];

    NSLog(@"%@", arrOfAllSwitch);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI1:(NSMutableArray *)arrOfAllInfo andIndexPath:(NSIndexPath *)indexPath {
    if ([arrOfAllInfo[indexPath.section][0][0] integerValue] > 12) {
        _myClockTime.text = [NSString stringWithFormat:@"%02ld:%02ld", [arrOfAllInfo[indexPath.section][0][0] integerValue] - 12, [arrOfAllInfo[indexPath.section][0][1] integerValue]];
        _myLabelOfPM.textColor = kHexRGBAlpha(0xffffff, 1.0f);
        _myLabelOfAM.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
    } else {
        _myClockTime.text = [NSString stringWithFormat:@"%02ld:%02ld", [arrOfAllInfo[indexPath.section][0][0] integerValue], [arrOfAllInfo[indexPath.section][0][1] integerValue]];
        _myLabelOfPM.textColor = kHexRGBAlpha(0xa2a2a2, 1.0f);
        _myLabelOfAM.textColor = kHexRGBAlpha(0xffffff, 1.0f);
    }
    
    NSArray *testArr = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]||[currentLanguage isEqualToString:@"zh-Hans"]) {
        NSMutableString *mySleectedStra = [NSMutableString new];
        for (NSInteger i = 0; i < 7; i ++) {
            if ([arrOfAllInfo[indexPath.section][1][i] isEqualToString:@"1"]) {
                [mySleectedStra appendString:[testArr[i] substringFromIndex:1]];
                [mySleectedStra appendString:@"/"];
            }
        }
        if (mySleectedStra.length == 2) {
            mySleectedStra = [NSMutableString stringWithString:[mySleectedStra substringToIndex:1]];
            [mySleectedStra insertString:@"周" atIndex:0];
        } else if (mySleectedStra.length == 14) {
            mySleectedStra = [NSMutableString stringWithString:NSLocalizedString(@"每天", nil)];
        } else {
            if (mySleectedStra.length != 0) {
                [mySleectedStra insertString:@"周" atIndex:0];
            }
        }
        _myTitle.text = mySleectedStra;

    } else {
        
        NSMutableString *mySleectedStra = [NSMutableString new];
        for (NSInteger i = 0; i < 7; i ++) {
            if ([arrOfAllInfo[indexPath.section][1][i] isEqualToString:@"1"]) {
                [mySleectedStra appendString:[testArr[i] substringFromIndex:1]];
                [mySleectedStra appendString:@"/"];
            }
        }
        
        if (mySleectedStra.length == 2) {
            mySleectedStra = [NSMutableString stringWithString:[mySleectedStra substringToIndex:1]];
            [mySleectedStra insertString:@"" atIndex:0];
        } else if (mySleectedStra.length == 14) {
            mySleectedStra = [NSMutableString stringWithString:NSLocalizedString(@"每天", nil)];
        } else {
            if (mySleectedStra.length != 0) {
                [mySleectedStra insertString:@"" atIndex:0];
            }
        }
        
        if ([mySleectedStra containsString:@"一"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"一" withString:@"Mon." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"二"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"二" withString:@"Tue." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"三"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"三" withString:@"Wed." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"四"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"四" withString:@"Thur." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"五"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"五" withString:@"Fri." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"六"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"六" withString:@"Sat." options:NSCaseInsensitiveSearch range:range];
        }
        if ([mySleectedStra containsString:@"日"]) {
            NSRange range = NSMakeRange(0, [mySleectedStra length]);
            [mySleectedStra replaceOccurrencesOfString:@"日" withString:@"Sun." options:NSCaseInsensitiveSearch range:range];
        }
        if (mySleectedStra.length != 0) {
            if ([mySleectedStra isEqualToString:NSLocalizedString(@"每天", nil)]) {
                _myTitle.text = mySleectedStra;
            } else {
                _myTitle.text = [mySleectedStra substringToIndex:mySleectedStra.length - 1];
            }
        } else {
            _myTitle.text = mySleectedStra;
        }
        
    }

    
    if ([arrOfAllInfo[indexPath.section][2] integerValue] == 0) {
        _mySubTitle.text = NSLocalizedString(@"贪睡未开启", nil);
    } else {
        _mySubTitle.text = [NSString stringWithFormat:@"%@%ld%@", NSLocalizedString(@"贪睡 ", nil), [arrOfAllInfo[indexPath.section][2] integerValue], NSLocalizedString(@"分钟", nil)];
    }
}

@end
