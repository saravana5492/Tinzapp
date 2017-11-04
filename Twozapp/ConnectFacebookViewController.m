//
//  ConnectFacebookViewController.m
//  Twozapp
//
//  Created by Priya on 09/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ConnectFacebookViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Reachability.h"
#import "NetworkManager.h"
#import "SlideAlertiOS7.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserDetails.h"
#import "MyIconDownloader.h"
#import "termAndCondVC.h"

@interface ConnectFacebookViewController ()<MBProgressHUDDelegate, MyIconDownloaderDelegate>{
    MBProgressHUD *hudProgress;
    NSMutableDictionary *imageDownloadsInProgress;

}
@end

@implementation ConnectFacebookViewController

- (void)viewDidLoad
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"FacebookLogin"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [super viewDidLoad];
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    _viewFacebook.layer.cornerRadius = 5.0f;
    _viewFacebook.layer.borderColor = [[UIColor whiteColor] CGColor];
    _viewFacebook.layer.borderWidth = 1.0f;
    [_viewFacebook.layer setMasksToBounds:YES];
    
    
    
    self.acceptTVLbl.text = [NSString stringWithFormat:@"I Accept Terms and Conditions"];
    NSRange range3 = [self.acceptTVLbl.text rangeOfString:@"I Accept "];
    NSRange range4 = [self.acceptTVLbl.text rangeOfString:@"Terms and Conditions"];
    NSMutableAttributedString *loginattributedText = [[NSMutableAttributedString alloc] initWithString:self.acceptTVLbl.text];
    
    NSDictionary *attrDictDummy = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    NSDictionary *attrDictLogin = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0],
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:63/255.0f green:92/255.0f blue:122/255.0f alpha:1.0f]
                                    
                                    };
    [loginattributedText setAttributes:attrDictDummy
                                 range:range3];
    [loginattributedText setAttributes:attrDictLogin
                                 range:range4];
    self.acceptTVLbl.attributedText = loginattributedText;
    

    
    NSLog(@"Signed In Email: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]);
    
    // Do any additional setup after loading the view.
}


- (IBAction)termsBtn:(id)sender{
    if ([self.acceptTCBtn tag] == 0) {
        self.acceptTCBtn.tag = 1;
        _acceptImgView.image = [UIImage imageNamed:@"checkIcon"];
    } else {
        self.acceptTCBtn.tag = 0;
        _acceptImgView.image = [UIImage imageNamed:@"uncheckIcon"];
    }
    
}

- (IBAction)showTCAction:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    termAndCondVC * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"termAndCondVC"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self presentViewController:UIVC animated:NO completion:nil];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionFacebook:(id)sender
{
    
    if([self.acceptTCBtn tag] == 0) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please accept terms and conditions."];
        
    } else {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
            // [self performSegueWithIdentifier:@"tofacebook" sender:nil];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
            
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logInWithReadPermissions: @[@"public_profile",@"user_friends",@"email",@"user_birthday"]
                         fromViewController:self
                                    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"Process error");
                                        } else if (result.isCancelled) {
                                            NSLog(@"Cancelled");
                                        } else {
                                            NSLog(@"Logged in");
                                            
                                            NSLog(@"Result %@",result);
                                            
                                            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                                          initWithGraphPath:@"/me"
                                                                          parameters:@{ @"fields": @"id,name,email,birthday"}
                                                                          HTTPMethod:@"GET"];
                                            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                
                                                NSLog(@"resds %@",result);
                                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                [defaults setObject:[result valueForKey:@"email"] forKey:@"email"];
                                                [defaults setObject:[result valueForKey:@"id"] forKey:@"fb_id"];
                                                [defaults synchronize];
                                                
                                                Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                                                NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                                                if (networkStatus == NotReachable) {
                                                    [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
                                                    [self performSegueWithIdentifier:@"tofacebook" sender:nil];
                                                } else {
                                                    
                                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                    
                                                    
                                                    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/login.php",BASEURL];
                                                    NSString *string = [NSString stringWithFormat:@"fb_id=%@&lat=%f&lng=%f&device_token=%@",[defaults stringForKey:@"fb_id"],  [self appDelegate].location.coordinate.latitude, [self appDelegate].location.coordinate.longitude, /*@"11.0169117", @"76.9792926",*/ [self appDelegate].deviceToken];
                                                    
                                                    NSLog(@"Facebook register param: %@", string);
                                                    
                                                    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                                                    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                                                        if(error) {
                                                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                            UIViewController *profileOne = [story instantiateViewControllerWithIdentifier:@"ProfileOneViewControllerNavi"];
                                                            [self presentViewController:profileOne animated:YES completion:nil];
                                                            NSLog(@"error : %@", [error description]);
                                                        } else {
                                                            
                                                            NSLog(@"Facebook login result : %@", result);
                                                            if (result.count >0) {
                                                                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                                    
                                                                    
                                                                    [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Successfully Logged in"];
                                                                    
                                                                    UserDetails *userDetails = [UserDetails sharedInstance];
                                                                    userDetails.dob = result[@"dob"];
                                                                    
                                                                    userDetails.birthtime = result[@"birthtime"];
                                                                    userDetails.height = result[@"height"];
                                                                    
                                                                    userDetails.email = result[@"email"];
                                                                    userDetails.fb_id = result[@"facebookid"];
                                                                    
                                                                    userDetails.gender = result[@"gender"];
                                                                    userDetails.latitude = result[@"latitude"];
                                                                    userDetails.descriptions = result[@"description"];
                                                                    userDetails.lookingfor = result[@"lookingfor"];
                                                                    NSMutableArray *arrKeywords = [[NSMutableArray alloc] init];
                                                                    NSArray *keywords = result[@"keywords"];
                                                                    for (NSDictionary *dict in keywords) {
                                                                        [arrKeywords addObject:dict[@"keyword"]];
                                                                    }
                                                                    userDetails.keywords = arrKeywords;
                                                                    userDetails.logitude = result[@"longitude"];
                                                                    userDetails.weight = result[@"weight"];
                                                                    
                                                                    userDetails.status = result[@"status"];
                                                                    userDetails.datingid = result[@"datingid"];
                                                                    userDetails.devicetoken = result[@"devicetoken"];
                                                                    userDetails.full_name = result[@"fullname"];
                                                                    userDetails.profilepicture = result[@"profilepicture"];
                                                                    
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogedInSuccessfully" object:nil];
                                                                    
                                                                    [self startDownloadImage:userDetails];
                                                                    
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    
                                                                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                                    UIViewController *profileOne = [story instantiateViewControllerWithIdentifier:@"ProfileOneViewControllerNavi"];
                                                                    [self presentViewController:profileOne animated:YES completion:nil];
                                                                    
                                                                }
                                                            }
                                                            else
                                                            {
                                                                
                                                                [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Error in connectivity. Please try again."];
                                                            }
                                                            
                                                        }
                                                        
                                                        [self hudWasHidden:hudProgress];
                                                    }];
                                                }
                                                
                                                
                                                
                                            }];
                                        }
                                    }];
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me"
                                          parameters:@{ @"fields": @"id,name,email,birthday"}
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                NSLog(@"resds %@",result);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[result valueForKey:@"email"] forKey:@"email"];
                [defaults setObject:[result valueForKey:@"id"] forKey:@"fb_id"];
                [defaults synchronize];
                
                //        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                //        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                //        if (networkStatus == NotReachable) {
                //            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
                //           // [self performSegueWithIdentifier:@"tofacebook" sender:nil];
                //        } else {
                //
                //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //
                //
                //            NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_webservices/login.php",BASEURL];
                //            NSString *string = [NSString stringWithFormat:@"fb_id=%@&lat=%f&lng=%f&device_token=%@",[defaults stringForKey:@"fb_id"],[self appDelegate].location.coordinate.latitude, [self appDelegate].location.coordinate.longitude,[self appDelegate].deviceToken];
                //            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                //            [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                //                if(error) {
                //                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                //                    UIViewController *profileOne = [story instantiateViewControllerWithIdentifier:@"ProfileOneViewControllerNavi"];
                //                    [self presentViewController:profileOne animated:YES completion:nil];
                //                    NSLog(@"error : %@", [error description]);
                //                } else {
                //
                //                    NSLog(@"Facebook login result : %@", result);
                //                    if (result.count >0) {
                //                        if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                //
                //
                //                            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Successfully Logged in"];
                //
                //                            UserDetails *userDetails = [UserDetails sharedInstance];
                //                            userDetails.dob = result[@"dob"];
                //
                //                            userDetails.birthtime = result[@"birthtime"];
                //                            userDetails.height = result[@"height"];
                //
                //                            userDetails.email = result[@"email"];
                //                            userDetails.fb_id = result[@"facebookid"];
                //
                //                            userDetails.gender = result[@"gender"];
                //                            userDetails.bazivalue1 = result[@"bazivalue1"];
                //                            userDetails.bazivalue2 = result[@"bazivalue2"];
                //                            userDetails.bazivalue3 = result[@"bazivalue3"];
                //                            userDetails.bazivalue4 = result[@"bazivalue4"];
                //                            userDetails.bazivalue5 = result[@"bazivalue5"];
                //                            userDetails.bazivalue6 = result[@"bazivalue6"];
                //                            userDetails.bazivalue7 = result[@"bazivalue7"];
                //                            userDetails.bazivalue8 = result[@"bazivalue8"];
                //                            userDetails.latitude = result[@"latitude"];
                //                            userDetails.descriptions = result[@"description"];
                //                            userDetails.lookingfor = result[@"lookingfor"];
                //                            NSMutableArray *arrKeywords = [[NSMutableArray alloc] init];
                //                            NSArray *keywords = result[@"keywords"];
                //                            for (NSDictionary *dict in keywords) {
                //                                [arrKeywords addObject:dict[@"keyword"]];
                //                            }
                //                            userDetails.keywords = arrKeywords;
                //                            userDetails.logitude = result[@"longitude"];
                //                            userDetails.weight = result[@"weight"];
                //                            
                //                            userDetails.status = result[@"status"];
                //                            userDetails.datingid = result[@"datingid"];
                //                            userDetails.devicetoken = result[@"devicetoken"];
                //                            userDetails.full_name = result[@"fullname"];
                //                            userDetails.profilepicture = result[@"profilepicture"];
                //                            
                //                            
                //                            
                //                            [self startDownloadImage:userDetails];
                //                            
                //                            
                //                        }
                //                        else
                //                        {
                //                            
                //                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                //                            UIViewController *profileOne = [story instantiateViewControllerWithIdentifier:@"ProfileOneViewControllerNavi"];
                //                            [self presentViewController:profileOne animated:YES completion:nil];
                //                            
                //                        }
                //                    }
                //                    else
                //                    {
                //                        
                //                        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Error in connectivity. Please try again."];
                //                    }
                //                    
                //                }
                //                
                //                [self hudWasHidden:hudProgress];
                //            }];
                //        }
                
            }];
        }
    }
    

}



#pragma mark - Smart Function

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (void)startDownloadImage:(UserDetails*)userDetails
{
    MyIconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:@"1"];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[MyIconDownloader alloc] init];
        iconDownloader.imageURL = [UserDetails sharedInstance].profilepicture;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:@"1"];
        [iconDownloader startDownload];
    }
}

- (void)appDidDownloadImage
{
    [imageDownloadsInProgress removeObjectForKey:@"1"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *profileTwo = [story instantiateViewControllerWithIdentifier:@"revealCont"];
    NSLog(@"self = %@",self.description);
    [self presentViewController:profileTwo animated:YES completion:nil];}

@end


//8ce24e589e36bded57b9b407327bdee70b85f557

