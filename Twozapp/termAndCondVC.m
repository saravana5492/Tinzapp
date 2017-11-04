//
//  termAndCondVC.m
//  Tinzapp
//
//  Created by Apple on 16/06/17.
//  Copyright © 2017 Priya. All rights reserved.
//

#import "termAndCondVC.h"
#import "MBProgressHUD.h"


@interface termAndCondVC () <MBProgressHUDDelegate, UIWebViewDelegate>
{
    MBProgressHUD *hudProgress;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation termAndCondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudProgress.delegate = self;
    
    hudProgress.mode = MBProgressHUDModeIndeterminate;
    hudProgress.labelText = @"Loading";
    hudProgress.dimBackground = YES;

    
    NSURL *targetURL = [NSURL URLWithString:@"http://www.tinzapp.com/terms-of-service/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_webView loadRequest:request];
    
    // Do any additional setup after loading the view.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)backBtnAction:(id)sender {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
