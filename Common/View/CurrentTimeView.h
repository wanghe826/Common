//
//  CurrentTimeView.h
//  Common
//
//  Created by QFITS－iOS on 16/3/6.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentTimeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *hourBtn;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet UIButton *secBtn;

+ (instancetype) currentTimeView:(CGRect)frame;

- (IBAction)hourSelected:(id)sender;
- (IBAction)minSelected:(id)sender;
- (IBAction)secSelected:(id)sender;

@property (nonatomic, strong) void (^hourPressed)(void);
@property (nonatomic, strong) void (^minPressed)(void);
@property (nonatomic, strong) void (^secPressed)(void);

@end
