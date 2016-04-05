//
//  AnotherSportVC.h
//  Common
//
//  Created by HuMingmin on 16/3/11.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "CustomViewController.h"

#import "CalendarKit.h"

@interface AnotherSportVC : CustomViewController

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;

@end
