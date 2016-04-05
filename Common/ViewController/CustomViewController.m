//
//  CustomViewController.m
//  Common
//
//  Created by QFITS－iOS on 16/1/7.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//
#import "Constants.h"
#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _baby = ApplicationDelegate.babyBluetooth;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self commonDelegate];
    [self babyDelegate];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar viewWithTag:1090].hidden = YES;
    [self.navigationController.navigationBar viewWithTag:1091].hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNavigationBar];
}

- (void)initialNavigationBar {
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kHexRGBAlpha(0xffffff, 1.0f), NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    
    self.view.backgroundColor = kHexRGBAlpha(0x030918, 1.0);
    self.navigationController.navigationBar.barTintColor = kHexRGBAlpha(0x030918, 1.0);
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : HexRGBAlpha(0xffffff, 1.0f),
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:18]};
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 44);
    [backBtn setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)doBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commonDelegate {
//    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
//        NSLog(@"父类蓝牙方法检测到蓝牙状态改变了！");
//    }];
//    
//    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        NSLog(@"父类蓝牙方法检测到蓝牙断开连接！");
//    }];
//    
//    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        NSLog(@"父类蓝牙方法检测到蓝牙连接上了！");
//    }];
}

// 父类蓝牙方法
- (void)babyDelegate {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
