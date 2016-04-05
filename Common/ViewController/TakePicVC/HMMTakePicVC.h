//
//  HMMTakePicVC.h
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "ViewController.h"
#import "CustomViewController.h"

typedef void(^ReturnBlockOfSelectedImage)(UIImage *myImage);

@interface HMMTakePicVC : CustomViewController

@property (nonatomic, assign) BOOL isFromPersonInfo;                                    // 是否来自个人
@property (nonatomic, copy) ReturnBlockOfSelectedImage myReturnBlockOfSelectedImage;    // 回传拍照数据

@end
