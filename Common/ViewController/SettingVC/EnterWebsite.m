//
//  EnterWebsite.m
//  Common
//
//  Created by Ling on 16/3/3.
//  Copyright © 2016年 Smartmovt. All rights reserved.
//

#import "EnterWebsite.h"

@interface EnterWebsite ()<UIWebViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView *myIdctView;
@property (nonatomic,strong)UIWebView *myWebView;

@end

@implementation EnterWebsite

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize titleSize =self.navigationController.navigationBar.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width/3,titleSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGBAlpha(0xffffff, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.text= NSLocalizedString(@"访问官网",nil);
    self.navigationItem.titleView = label;

    [self creatMyWebView];
}

- (UIWebView *)myWebView {
    
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _myWebView.backgroundColor = [UIColor clearColor];
        _myWebView.delegate = self;
        
    }
    return _myWebView;
}

- (void)creatMyWebView {
    
    [self.view addSubview:self.myWebView];
    [self.myIdctView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(-10, 0, 0, 0));
    }];
    
    self.myIdctView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.myIdctView setCenter:self.view.center];
    [self.myIdctView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.myIdctView];
    NSURL *url = [NSURL URLWithString:@"http://www.smartmovt.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
     NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
     NSLog(@"didFailLoadWithError");
    
    UIAlertView *alrtView = [[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alrtView show];
    
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
