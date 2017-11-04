//
//  ContentViewController.m
//  Twozapp
//
//  Created by Dipin on 21/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ContentViewController.h"
#import "MatchesViewController.h"
#import "MainViewController.h"
#import "ProfileOneViewController.h"
#import "UserDetails.h"
#import "ChatListViewController.h"
#import "allChatListViewController.h"
#import "HelpDesk.h"
#import "SplashViewController.h"
#import "ConnectFacebookViewController.h"
#import "ProfileTwoViewController.h"
#import "MyIconDownloader.h"
#import "NetworkManager.h"
#import "SlideAlertiOS7.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SWRevealViewController.h"



@interface ContentViewController ()<MyIconDownloaderDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
//@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
//@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation ContentViewController
{
    BOOL sideViewShown;
     NSMutableDictionary *imageDownloadsInProgress;
    MBProgressHUD *hudProgress;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = _leftMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    self.title = @"";
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainViewController *main = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    [self addChildViewController:main];
    [self.view addSubview:main.view];
    
/*    _titleLbl = [[UILabel alloc] init];
    CGSize labelSize = CGSizeMake(120, 20);
    //CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    
    _titleLbl.frame = CGRectMake(60.0, 12.0, labelSize.width, labelSize.height);
    [self.navigationController.navigationBar addSubview:_titleLbl];
    _titleLbl.textColor = [UIColor whiteColor];
    [_titleLbl setFont:[UIFont systemFontOfSize:15]]; */
    
    // Do any additional setup after loading the view.
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


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}
@end
