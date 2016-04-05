//
//  SleepVC.h
//  Common
//
//  Created by HMM－MACmini on 16/2/25.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

#import "CalendarKit.h"

@interface SleepVC : CustomViewController <CKCalendarViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;

@end
