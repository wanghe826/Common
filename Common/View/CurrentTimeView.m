//
//  CurrentTimeView.m
//  Common
//
//  Created by QFITS－iOS on 16/3/6.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "CurrentTimeView.h"

@implementation CurrentTimeView

+ (instancetype) currentTimeView:(CGRect)frame
{
    UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"CurrentTimeView" owner:nil options:nil] lastObject];
    view.frame = frame;
    return (CurrentTimeView*)view;
}

- (IBAction)hourSelected:(id)sender {
    [(UIButton*)sender setTitleColor:RGBColor(0xe8, 0x10, 0x10) forState:UIControlStateNormal];
    [self.minBtn setTitleColor:RGBColor(0xa2, 0xa2, 0xa2) forState:UIControlStateNormal];
    [self.secBtn setTitleColor:RGBColor(0xa2, 0xa2, 0xa2) forState:UIControlStateNormal];
    if(self.hourPressed)
    {
        _hourPressed();
    }
}

- (IBAction)minSelected:(id)sender {
    [(UIButton*)sender setTitleColor:RGBColor(0xe8, 0x10, 0x10) forState:UIControlStateNormal];
    [self.hourBtn setTitleColor:RGBColor(0xa2, 0xa2, 0xa2) forState:UIControlStateNormal];
    [self.secBtn setTitleColor:RGBColor(0xa2, 0xa2, 0xa2) forState:UIControlStateNormal];
    if(self.minPressed)
    {
        _minPressed();
    }
}

- (IBAction)secSelected:(id)sender {
    [(UIButton*)sender setTitleColor:RGBColor(0xe8, 0x10, 0x10) forState:UIControlStateNormal];
    [self.hourBtn setTitleColor:RGBColor(0xa2, 0xa2, 0xa2) forState:UIControlStateNormal];
    [self.minBtn setTitleColor:RGBColor(0xa2, 0xa2, 0xa2) forState:UIControlStateNormal];
    if(self.secPressed)
    {
        _secPressed();
    }
}
@end
