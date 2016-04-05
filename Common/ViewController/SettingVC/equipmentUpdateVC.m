//
//  equipmentUpdateVC.m
//  Common
//
//  Created by Ling on 16/3/2.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "equipmentUpdateVC.h"

@interface equipmentUpdateVC ()

@property (nonatomic,strong)CAShapeLayer *shapeLayer;
@property (nonatomic,strong)CAShapeLayer *firstShapeLayer;
@property (nonatomic,strong)NSTimer *dataTimer;
@property (nonatomic,assign)CGFloat rate;

@end

@implementation equipmentUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
      self.view.backgroundColor = HexRGBAlpha(0x030919, 1);
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNavitionBar];
}

- (void)initNavitionBar {
    
    self.title = NSLocalizedString(@"设备固件升级", nil);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: HexRGBAlpha(0xffffff, 1) ,                                                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)initView {
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70,kScreenWidth, 60)];
    topLabel.text =NSLocalizedString(@"固件升级请保持手表与手机处于连接状态", nil);
    topLabel.numberOfLines = 0;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = HexRGBAlpha(0xa2a2a2, 1);
    topLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:topLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y - 30, 200, 60)];
    label.tag = 1000;
    label.text = @"0%";
    label.font = [UIFont systemFontOfSize:60];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = HexRGBAlpha(0xffffff, 1);
    [self.view addSubview:label];
    
    self.firstShapeLayer = [CAShapeLayer layer];
    self.firstShapeLayer.frame = CGRectMake(0, 0, 100, 100);
    self.firstShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.firstShapeLayer.strokeColor = HexRGBAlpha(0xa2a2a2, 1).CGColor;
    self.firstShapeLayer.opacity = 1;
    
    CGPoint point1 = CGPointMake(self.view.center.x, self.view.center.y);
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:point1 radius:105 startAngle:-M_PI * 1.5 endAngle:1.5 * M_PI clockwise:YES];
    self.firstShapeLayer.path = arcPath.CGPath;
    self.firstShapeLayer.lineWidth = 6;
    self.firstShapeLayer.strokeEnd = 0;
    self.firstShapeLayer.strokeEnd = 1;
    [self.view.layer insertSublayer:self.firstShapeLayer atIndex:0];
    
    //创建shapeLayer,并且设置相关属性
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 100,100);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = HexRGBAlpha(0x4cdac4, 1).CGColor;
    self.shapeLayer.opacity = 1;
    
    //贝塞尔曲线
    CGPoint point2 = CGPointMake(self.view.center.x, self.view.center.y);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:point2 radius:105 startAngle:-M_PI * 0.5 endAngle: 1.5*M_PI clockwise:YES];
    self.shapeLayer.path = circlePath.CGPath;
    self.shapeLayer.lineWidth = 6;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.frame;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)HexRGBAlpha(0x4cdac4, 1).CGColor,HexRGBAlpha(0x009ef4,1).CGColor, nil]];
    [gradientLayer setLocations:@[@0,@1]];
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    [gradientLayer setMask:self.shapeLayer];
    [self.view.layer addSublayer:gradientLayer];

    //设置画笔的起点和终点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0.005;
    

    self.dataTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(circleAnimation) userInfo:nil repeats:YES];
}

- (void)circleAnimation
{
    
    if (self.rate > 0) {
        
        self.rate += 0.009;
        
        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.strokeEnd =self.rate;

        if (self.shapeLayer.strokeEnd >= 1) {
            [self.dataTimer invalidate];
        }
        
        UILabel *percentLabel =(UILabel *)[self.view viewWithTag:1000];
        percentLabel.text = [NSString stringWithFormat:@"%.0lf%@",100 * self.rate,@"%"];
        NSLog(@"%lf",self.shapeLayer.strokeEnd);
        
    }else{
        
        self.rate += 0.01;
        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.strokeEnd = self.rate;

        if (self.shapeLayer.strokeEnd >= 1) {
            [self.dataTimer invalidate];
        }
        UILabel *perLabel = (UILabel *)[self.view viewWithTag:1000];
        perLabel.text = [NSString stringWithFormat:@"%.0lf%@",100 * self.rate,@"%"];
        NSLog(@"%lf",self.shapeLayer.strokeEnd);
    }
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
