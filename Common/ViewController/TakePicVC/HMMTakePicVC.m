//
//  HMMTakePicVC.m
//  Common
//
//  Created by HuMingmin on 16/3/4.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "HMMTakePicVC.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomViewController.h"

@interface HMMTakePicVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSTimer *_timer;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;                     // 输入、输出设备之间数据传递对象
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;             // 出入流
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;   // 照片输出对象，单拍照功能、够用
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer; // 预览图层
@property (nonatomic, strong) UIView *cameraShowView;                               // 放置预览图层
@property (nonatomic, strong)  AVCaptureDevice *device;

@property (nonatomic, strong) NSString *timeLastCap;                                // 上一次几秒拍照
@property (nonatomic, assign) NSInteger timeLastCapInterg;                          // 上一次几秒拍照
@property (nonatomic, strong) NSTimer *myTimeTakePic;                               // 倒计时拍照
@property (nonatomic, strong) NSTimer *myTimeTakePicOfDisPlay;                      // 倒计时效果

@property (nonatomic, assign) BOOL isDelayingTakepic;                               // 是否正在拍照
@property (nonatomic, assign) BOOL isNeedFlashlight;                                // 是否需要闪光灯

@end

@implementation HMMTakePicVC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSession];
    }
    return self;
}

- (void)initSession {
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
    self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 这是输出流的设置参数，AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.captureStillImageOutput setOutputSettings:outputSettings];
    
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    if ([self.captureSession canAddOutput:self.captureStillImageOutput]) {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
} // 初始化captureSession、在init方法里面执行

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devicesArr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *captureDevice in devicesArr) {
        if ([captureDevice position] == position) {
            return captureDevice;
        }
    }
    return nil;
} // 获取前后摄像头的方法
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createCameraBackView]; // 创建相机底层承接视图
}

- (void)createlayer {
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    [self setUpCameraLayer];
    
    //
    UIView *likeNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    likeNavView.backgroundColor = kHexRGBAlpha(0x000000, 0.4);
    [self.view addSubview:likeNavView];
    likeNavView.userInteractionEnabled = YES;
    likeNavView.tag = 101;
    
    //
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 30, 20, 25);
    backBtn.backgroundColor = kRandomColor(0.0f);
    [backBtn addTarget:self action:@selector(backBtnClcike:) forControlEvents:UIControlEventTouchUpInside];
    [likeNavView addSubview:backBtn];
    
    if (self.isFromPersonInfo) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + (2 * kScreenWidth / 2.0 / 7.0) * 3 - 20, backBtn.frame.origin.y, backBtn.frame.size.height, backBtn.frame.size.height)];
        btn.backgroundColor = kRandomColor(0.0f);
        [btn setImage:[UIImage imageNamed:@"overturn_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(paiZhaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [likeNavView addSubview:btn];
    } else {
        NSArray *teatArr = @[@"0", @"3", @"5", @"10"];
        for (NSInteger i = 0; i < 4; i ++) {
            UIButton *myLastTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            myLastTimeBtn.frame = CGRectMake(kScreenWidth / 2.0 + (2 * kScreenWidth / 2.0 / 7.0 - 5) * i - 5, backBtn.frame.origin.y, backBtn.frame.size.height, backBtn.frame.size.height);
            [myLastTimeBtn setTitleColor:kHexRGBAlpha(0xa2a2a2, 1.0f) forState:UIControlStateNormal];
            myLastTimeBtn.backgroundColor = kRandomColor(0.0f);
            [myLastTimeBtn setTitle:teatArr[i] forState:UIControlStateNormal];
            
            [myLastTimeBtn addTarget:self action:@selector(myLastTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [likeNavView addSubview:myLastTimeBtn];
            myLastTimeBtn.tag = 10 + i;
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TimeLastCap"]) {
                self.timeLastCap = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeLastCap"]];
            } else {
                self.timeLastCap = @"0";
            }
            
            if ([self.timeLastCap integerValue] == 0) {
                if (i == 0) {
                    myLastTimeBtn.selected = YES;
                    myLastTimeBtn.clipsToBounds = YES;
                    myLastTimeBtn.layer.cornerRadius = 5;
                    myLastTimeBtn.layer.borderWidth = 1;
                    [myLastTimeBtn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
                    myLastTimeBtn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];
                    [myLastTimeBtn setTitleColor:kHexRGBAlpha(0xffffff, 1.0f) forState:UIControlStateNormal];
                }
            } else if ([self.timeLastCap integerValue] == 3) {
                if (i == 1) {
                    myLastTimeBtn.selected = YES;
                    myLastTimeBtn.clipsToBounds = YES;
                    myLastTimeBtn.layer.cornerRadius = 5;
                    myLastTimeBtn.layer.borderWidth = 1;
                    [myLastTimeBtn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
                    myLastTimeBtn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];
                    [myLastTimeBtn setTitleColor:kHexRGBAlpha(0xffffff, 1.0f) forState:UIControlStateNormal];
                }
            } else if ([self.timeLastCap integerValue] == 5) {
                if (i == 2) {
                    myLastTimeBtn.selected = YES;
                    myLastTimeBtn.clipsToBounds = YES;
                    myLastTimeBtn.layer.cornerRadius = 5;
                    myLastTimeBtn.layer.borderWidth = 1;
                    [myLastTimeBtn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
                    myLastTimeBtn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];
                    [myLastTimeBtn setTitleColor:kHexRGBAlpha(0xffffff, 1.0f) forState:UIControlStateNormal];
                }
            } else {
                if (i == 3) {
                    myLastTimeBtn.selected = YES;
                    myLastTimeBtn.clipsToBounds = YES;
                    myLastTimeBtn.layer.cornerRadius = 5;
                    myLastTimeBtn.layer.borderWidth = 1;
                    [myLastTimeBtn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
                    myLastTimeBtn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];
                    [myLastTimeBtn setTitleColor:kHexRGBAlpha(0xffffff, 1.0f) forState:UIControlStateNormal];
                }
            }
            
        }
    }
    
    // 下方
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64)];
    bottomImageView.tag = 30901;
    bottomImageView.backgroundColor = kHexRGBAlpha(0xa2a2a2, 0.0);
    bottomImageView.image = [UIImage imageNamed:@"bg_camera"];
    [self.view addSubview:bottomImageView];
    bottomImageView.userInteractionEnabled = YES;
    
    NSArray *testArr2 = [NSArray array];
    if (self.isFromPersonInfo) {
        testArr2 = @[@"album_icon", @"icon_photograph1", @"btn_flash_lights_avr"];
    } else {
        testArr2 = @[@"album_icon", @"overturn_icon", @"btn_flash_lights_avr"];
    }
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.frame = CGRectMake(16 + i * ((kScreenWidth - 16 - 33.5 - 16) / 2.0), 15, 33.5, 33.5);
        changeBtn.backgroundColor = kRandomColor(0.0);
        [bottomImageView addSubview:changeBtn];
        [changeBtn setBackgroundImage:[UIImage imageNamed:testArr2[i]] forState:UIControlStateNormal];
        changeBtn.tag = 30 + i;
        [changeBtn addTarget:self action:@selector(changeBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)paiZhaoAction:(id)sender {
    [self toggleCamera];
}

- (void)createCameraBackView {
    if (!self.cameraShowView) {
        self.cameraShowView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.cameraShowView.backgroundColor = kHexRGBAlpha(0x2a2a2a, 1.0);
        [self.view addSubview:_cameraShowView];
        
        [self createlayer];
    }
} // 创建相机底层承接视图

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createStillInCameraTimer];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 改变状态栏颜色
    
    //进入拍照页面
    [self stillInCamera];
    //处理拍照
    [self processTakePhoto];
    
    [self.captureSession startRunning];
}

- (void)changeBtnClcik:(id)sender {
    if ([sender tag] == 30) {
        [self gotoAlbum];
    } else if ([sender tag] == 31) {
        if (self.isFromPersonInfo) {
            if (!_isDelayingTakepic) {
                [self needFlash:self.isNeedFlashlight];
                [self shutterCamera:0];
            } else {
                NSLog(@"正在拍照中，请稍后。。。");
            }
        } else {
            [self toggleCamera];
        }
    } else {

        self.isNeedFlashlight = !((UIButton *)sender).selected;
        [((UIButton *)sender) setSelected:!((UIButton *)sender).selected];
        
        if (((UIButton *)sender).selected) {
            [sender setBackgroundImage:[UIImage imageNamed:@"btn_flash_lights_sel"] forState:UIControlStateNormal];
        } else {
            [sender setBackgroundImage:[UIImage imageNamed:@"btn_flash_lights_avr"] forState:UIControlStateNormal];
        }
    
    }
}

// 拍照闪光灯
- (void)needFlash:(BOOL)isNeedFlash {
    AVCaptureDevicePosition position = [[_captureDeviceInput device] position];
    
    if (isNeedFlash) {
        if (position == AVCaptureDevicePositionBack) {
        } else if (position == AVCaptureDevicePositionFront) {
//            [self toggleCamera];
            return;
        }
        
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device unlockForConfiguration];
        [_captureSession commitConfiguration];
    } else {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    }
    
}

- (void)backBtnClcike:(id)sender {
    if (kScreenHeight == 480) {
        if (_isFromPersonInfo) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}
- (void)myLastTimeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    self.timeLastCap = btn.titleLabel.text;
    
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *lastBtn = (UIButton *)[[self.view viewWithTag:101] viewWithTag:10 + i];
        lastBtn.clipsToBounds = YES;
        lastBtn.layer.cornerRadius = 0;
        lastBtn.layer.borderWidth = 0;
        lastBtn.layer.borderColor = [kHexRGBAlpha(0xffffff, 0.0) CGColor];
        [lastBtn setTitleColor:kHexRGBAlpha(0xa2a2a2, 1.0f) forState:UIControlStateNormal];
    }
    
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    [btn setTintColor:kHexRGBAlpha(0xffffff, 1.0)];
    btn.layer.borderColor = [kHexRGBAlpha(0xffffff, 1.0) CGColor];
    [btn setTitleColor:kHexRGBAlpha(0xffffff, 1.0f) forState:UIControlStateNormal];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; // 改变状态栏颜色
    
    [self leaveCameraVc];
    [_timer invalidate];
    
    if (_isFromPersonInfo) {
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.timeLastCap forKey:@"TimeLastCap"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.myTimeTakePicOfDisPlay invalidate];
    [self.myTimeTakePic invalidate];
    
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)setUpCameraLayer {
    if (self.captureVideoPreviewLayer == nil) {
        self.cameraShowView.frame = self.view.bounds;
        self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        UIView *view = self.cameraShowView;
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [self.captureVideoPreviewLayer setFrame:bounds];
        [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:self.captureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    }
} // 接下来在viewWillAppear方法里执行加载预览图层的方法

- (void)toggleCamera {
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_captureDeviceInput device] position];
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        if (newVideoInput != nil) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.captureDeviceInput];
            
            if ([self.captureSession canAddInput:newVideoInput]) {
                [self.captureSession addInput:newVideoInput];
                [self setCaptureDeviceInput:newVideoInput];
            } else {
                [self.captureSession addInput:self.captureDeviceInput];
            }
            [self.captureSession commitConfiguration];
            
        } else if (error) {
            NSLog(@"错误！error = %@", error);
        }
    }
} // 接着我们就来实现切换前后镜头的按钮

- (void)shutterCamera:(CGFloat)sleepTimeToTakePic {
    _isDelayingTakepic = YES;
    if (_isNeedFlashlight) {
        self.myTimeTakePic = [NSTimer scheduledTimerWithTimeInterval:sleepTimeToTakePic + 1.0f target:self selector:@selector(GotoTaking:) userInfo:nil repeats:NO];
    } else {
        self.myTimeTakePic = [NSTimer scheduledTimerWithTimeInterval:sleepTimeToTakePic + 0.0f target:self selector:@selector(GotoTaking:) userInfo:nil repeats:NO];
    }
    
    if (sleepTimeToTakePic > 0) {
        self.myTimeTakePicOfDisPlay = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(LabelTImeLast:) userInfo:nil repeats:YES];
        self.timeLastCapInterg = [self.timeLastCap integerValue];
        UIButton *lastTimeBtnDisplay = [UIButton buttonWithType:UIButtonTypeCustom];
        lastTimeBtnDisplay.frame = CGRectMake(0, 0, kScreenWidth / 3.0, kScreenWidth / 3.0);
        lastTimeBtnDisplay.tag = 31101;
        [lastTimeBtnDisplay setBackgroundImage:[UIImage imageNamed:@"icon_focus"] forState:UIControlStateNormal];
        lastTimeBtnDisplay.center = self.view.center;
        [lastTimeBtnDisplay setTitle:[NSString stringWithFormat:@"%ld", self.timeLastCapInterg] forState:UIControlStateNormal];
        [lastTimeBtnDisplay setTitleColor:kHexRGBAlpha(0x01f6c4, 1.0f) forState:UIControlStateNormal];
        lastTimeBtnDisplay.titleLabel.font = [UIFont systemFontOfSize:60];
        [self.view addSubview:lastTimeBtnDisplay];
    }
} // 拍照按钮方法
- (void)GotoTaking:(id)sender {
    AVCaptureConnection *videoConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"拍照失败");
        [self needFlash:NO];
        _isDelayingTakepic = NO;
        return;
    }
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
        [self saveImageToPhotos:image];
        

        [((UIButton *)[[self.view viewWithTag:30901] viewWithTag:30]) setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            ((UIButton *)[[self.view viewWithTag:30901] viewWithTag:30]).transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7f animations:^{
                ((UIButton *)[[self.view viewWithTag:30901] viewWithTag:30]).transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }];
        
    }];
    
    [self needFlash:NO];
    _isDelayingTakepic = NO;
}
- (void)LabelTImeLast:(id)sender {
    [[self.view viewWithTag:31101] removeFromSuperview];
    self.timeLastCapInterg -= 1;
    
    UIButton *lastTimeBtnDisplay = [UIButton buttonWithType:UIButtonTypeCustom];
    lastTimeBtnDisplay.frame = CGRectMake(0, 0, kScreenWidth / 3.0, kScreenWidth / 3.0);
    lastTimeBtnDisplay.tag = 31101;
    [lastTimeBtnDisplay setBackgroundImage:[UIImage imageNamed:@"icon_focus"] forState:UIControlStateNormal];
    lastTimeBtnDisplay.center = self.view.center;
    [lastTimeBtnDisplay setTitle:[NSString stringWithFormat:@"%ld", self.timeLastCapInterg] forState:UIControlStateNormal];
    [lastTimeBtnDisplay setTitleColor:kHexRGBAlpha(0x01f6c4, 1.0f) forState:UIControlStateNormal];
    lastTimeBtnDisplay.titleLabel.font = [UIFont systemFontOfSize:60];
    [self.view addSubview:lastTimeBtnDisplay];
    
    if (self.timeLastCapInterg == 0) {
        if (self.timeLastCapInterg == 0) {
            [self needFlash:self.isNeedFlashlight];
        } // 开启闪光灯
        [self.myTimeTakePicOfDisPlay invalidate];
        [lastTimeBtnDisplay setTitle:[NSString stringWithFormat:@"%d", 0] forState:UIControlStateNormal];
        [lastTimeBtnDisplay removeFromSuperview];
    }
}

- (void)gotoAlbum {
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    if (self.isFromPersonInfo) {
        pickerImage.allowsEditing = YES;
    } else {
        pickerImage.allowsEditing = YES;
    }
    
    [self presentViewController:pickerImage animated:YES completion:nil];
} // 相册

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image1= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image2= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *myImage = [UIImage new];
    if (image2) {
        myImage = image2;
    } else {
        myImage = image1;
    }

    NSData *imageData = UIImageJPEGRepresentation(myImage,0.01);
    
    if (self.isFromPersonInfo) {
        self.myReturnBlockOfSelectedImage([UIImage imageWithData:imageData]);
    }
    
    if (self.isFromPersonInfo) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            ViewController *tempVC =  [ViewController new];
            UIImageView *myTempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            myTempImageView.image = image1;
            tempVC.navigationController.navigationBar.alpha = 0;
            tempVC.view.backgroundColor = kHexRGBAlpha(0x000000, 1.0f);
            [tempVC.view addSubview:myTempImageView];
            
            [self.navigationController pushViewController:tempVC animated:YES];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if(error != NULL){
        msg = @"保存图片失败";
    }else {
        msg = @"保存图片成功";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
//    [alert show];
} // 指定回调方法

// 屏幕翻转会回调
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}
#pragma 遥控拍照的实现
- (void) createStillInCameraTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(stillInCamera) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void) stillInCamera
{
    if(ApplicationDelegate.currentPeripheral)
    {
        [WriteData2BleUtil cameInTakePhotoVc:ApplicationDelegate.currentPeripheral withStatus:YES];
    }
}

- (void) leaveCameraVc
{
    if(ApplicationDelegate.currentPeripheral)
    {
        [WriteData2BleUtil cameInTakePhotoVc:ApplicationDelegate.currentPeripheral withStatus:NO];
    }
}

- (void) processTakePhoto
{
    [ApplicationDelegate.babyBluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        Byte* byteArray = (Byte*)[characteristic.value bytes];
        if((byteArray[0]==0x24 && byteArray[1]==0x03 && byteArray[2]==0x02 && byteArray[3]==0x13 && byteArray[4]==0x02 && byteArray[5]==0x15) || (byteArray[0]==0x23 && byteArray[1]==0x01 && byteArray[2]==0x04 && byteArray[3]==0x013 && byteArray[4]==0x87 && byteArray[5]==0x08 && byteArray[6]==0x01 && byteArray[7]==0x01 && byteArray[8]==0x01))
        {
            NSLog(@"收到拍照命令");
            if (self.isFromPersonInfo) {
                if (!_isDelayingTakepic) {
                    [self shutterCamera:0];
                } else {
                    NSLog(@"正在拍照中，请稍后。。。");
                }
            } else {
                if (!_isDelayingTakepic) {
                    [self shutterCamera:[self.timeLastCap floatValue]];
                } else {
                    NSLog(@"正在拍照中，请稍后。。。");
                }
            }

        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
