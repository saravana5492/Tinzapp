//
//  SplashViewController.m
//  Twozapp
//
//  Created by Priya on 13/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "SplashViewController.h"
#import "Reachability.h"
#import "SlideAlertiOS7.h"
#import "MBProgressHUD.h"
#import "OnDeck.h"
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "UserDetails.h"
#import "MyIconDownloader.h"

@interface SplashViewController ()<MBProgressHUDDelegate, MyIconDownloaderDelegate>{
    MBProgressHUD *hudProgress;
    NSMutableDictionary *imageDownloadsInProgress;
}

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self appDelegate].locationManager startUpdatingLocation];
    //[self performSelector:@selector(stopLocationFetching) withObject:nil afterDelay:3.0];
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    [_activityIndicator startAnimating];
    [self performSelector:@selector(actionStop) withObject:nil afterDelay:3.0];
}

- (void)actionStop
{
    [_activityIndicator stopAnimating];
    [[self appDelegate].locationManager stopUpdatingLocation];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] == nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_id"] == nil) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *profileTwo = [story instantiateViewControllerWithIdentifier:@"ConnectFacebookViewController"];
        [self presentViewController:profileTwo animated:YES completion:nil];
    }
    else{
        
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable) {
                [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
                [self performSegueWithIdentifier:@"tofacebook" sender:nil];
            } else {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                
                NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/login.php",BASEURL];
                NSString *string = [NSString stringWithFormat:@"fb_id=%@&lat=%f&lng=%f&device_token=%@",[defaults stringForKey:@"fb_id"], [self appDelegate].location.coordinate.latitude, [self appDelegate].location.coordinate.longitude, /*@"11.0169117", @"76.9792926",*/ [self appDelegate].deviceToken];
                
                 NSLog(@"Facebook register param: %@", string);
                
                NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                 
                                                                 if(error) {
                                                                     [self performSegueWithIdentifier:@"tofacebook" sender:nil];
                                                                     NSLog(@"error : %@", [error description]);
                                                                 } else {
                                                                     // This is the expected result
                                                                     NSLog(@"result : %@", result);
                                                                     if (result.count >0) {
                                                                         if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                                             
                                                                           
                                                                                 [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Successfully Logged in"];
                                                                                 
                                                                                 UserDetails *userDetails = [UserDetails sharedInstance];
                                                                                 userDetails.dob = result[@"dob"];
                                                                             
                                                                             userDetails.birthtime = result[@"birthtime"];
                                                                             if ([result[@"birthtime"] isEqualToString:@"00:01:00"]) {
                                                                                 userDetails.birthtime = @"-- --";
                                                                             }
                                                                                 userDetails.height = result[@"height"];
                                                                             
                                                                                 userDetails.email = result[@"email"];
                                                                                 userDetails.fb_id = result[@"facebookid"];
                                                                             
                                                                                 userDetails.gender = result[@"gender"];
                                                                                 userDetails.latitude = result[@"latitude"];
                                                                                 userDetails.logitude = result[@"longitude"];
                                                                                 userDetails.weight = result[@"weight"];
                                                                             userDetails.descriptions = result[@"description"];
                                                                             
                                                                             NSMutableArray *arrKeywords = [[NSMutableArray alloc] init];
                                                                             NSArray *keywords = result[@"keywords"];
                                                                             for (NSDictionary *dict in keywords) {
                                                                                 [arrKeywords addObject:dict[@"keyword"]];
                                                                             }
                                                                             userDetails.keywords = arrKeywords;
                                                                                 userDetails.status = result[@"status"];
                                                                             userDetails.lookingfor = result[@"lookingfor"];
                                                                                 userDetails.datingid = result[@"datingid"];
                                                                                 userDetails.devicetoken = result[@"devicetoken"];
                                                                             userDetails.full_name = result[@"fullname"];
                                                                             userDetails.profilepicture = result[@"profilepicture"];
                                                                                 
                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"LogedInSuccessfully" object:nil];
                                                                             [self startDownloadImage:userDetails];
                                                                             
                                                                                                                                              }
                                                                     else
                                                                     {
                                                                         
                                                                         [self performSegueWithIdentifier:@"tofacebook" sender:nil];
                                                                     }
                                                                     
                                                                 }
                                                                     else
                                                                     {
                                                                       [self performSegueWithIdentifier:@"tofacebook" sender:nil];  
                                                                     }
                                                                 }
                                                                 [self hudWasHidden:hudProgress];
                                                             }];
            }
            
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *profileTwo = [story instantiateViewControllerWithIdentifier:@"revealCont"];
    [self presentViewController:profileTwo animated:YES completion:nil];
}

- (void)stopLocationFetching
{
    [[self appDelegate].locationManager stopUpdatingLocation];
}


@end
