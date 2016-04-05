//
//  CustomViewController.h
//  Common
//
//  Created by QFITS－iOS on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController {
@protected
    BabyBluetooth *_baby;
}

- (void)babyDelegate;

@end
