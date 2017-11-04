//
//  MatchesViewController.m
//  Twozapp
//
//  Created by Priya on 10/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "MatchesViewController.h"
#import "NetworkManager.h"
#import "UserFriends.h"
#import "UserDetails.h"
#import "HelpDesk.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "SlideAlertiOS7.h"
#import "StarRatingView.h"
#import "EDStarRating.h"
#import "SWRevealViewController.h"


@interface MatchesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MBProgressHUDDelegate, EDStarRatingProtocol>
{
    NSMutableArray *arrayMatches;
    NSMutableDictionary *imageDownloadsInProgress;
    MBProgressHUD *hudProgress;

}
@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SWRevealViewController *revealController = [self revealViewController];

    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton"]
                                                 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = _leftMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    arrayMatches = [[NSMutableArray alloc] init];
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMatches:) name:@"RefreshMatches" object:nil];
    //self.navigationController.navigationBarHidden = NO;
    
    
    //[self.collectionView setContentInset:UIEdgeInsetsMake(topMargin, 0, 0, 0)];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    //self.navigationController.navigationBar.translucent = YES;

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
    hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudProgress.delegate = self;
    
    hudProgress.mode = MBProgressHUDModeIndeterminate;
    hudProgress.labelText = @"Loading";
    hudProgress.dimBackground = YES;
    //infowebtechsolutions.com/demo/twzapp/match.php?user_id=11
        
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/message_list_contacts.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Matches result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if (result[@"result"] != [NSNull null]) {
                        
                        
                        NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                        arrResponse = result[@"result"];
                        if (arrResponse.count > 0) {
                            
                            [arrayMatches removeAllObjects];
                            for (NSDictionary *dict in arrResponse) {
                                
                                UserFriends *listfriends = [[UserFriends alloc] init];
                                listfriends.frdId = [dict objectForKey:@"registerid"];
                                listfriends.frdName = [dict objectForKey:@"name"];
                                listfriends.frddob = [dict objectForKey:@"dob"];
                                listfriends.fndImage = [dict objectForKey:@"profilepicture"];
                                listfriends.fndEmail = [dict objectForKey:@"email"];
                                listfriends.fndDescription = [dict objectForKey:@"description"];
                                listfriends.fndGender = [dict objectForKey:@"gender"];
                                //listfriends.birthtime = [dict objectForKey:@"birthtime"];
                                listfriends.height = [dict objectForKey:@"height"];
                                listfriends.weight = [dict objectForKey:@"weight"];
                                listfriends.frd_fb_Id = [dict objectForKey:@"facebookid"];
                                //listfriends.pointstar = [dict objectForKey:@"pointstar"];
                                //listfriends.pointstar = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pointstar"]];
                                listfriends.onlineStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
                                [arrayMatches addObject:listfriends];
                                
                            }
                            [_collectionView reloadData];
                        }
                    }
                    
                }else{
                    
                }
            }
            
            
        }
        
        [self hudWasHidden:hudProgress];
        
    }];
    }

}



- (NSInteger)age:(NSDate *)dateOfBirth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.parentViewController.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayMatches count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UserFriends *userFriends = [arrayMatches objectAtIndex:indexPath.item];
    
    NSLog(@"User details: %@", userFriends.onlineStatus);
    
    UIImageView *imgViewProfile = (UIImageView *)[cell viewWithTag:10];
    //imgViewProfile.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",userFriends.fndImage]];
    [imgViewProfile layoutIfNeeded];
    imgViewProfile.layer.cornerRadius = 35.0f;
    [imgViewProfile.layer setMasksToBounds:YES];
    imgViewProfile.contentMode = UIViewContentModeScaleAspectFill;
    [imgViewProfile setClipsToBounds:YES];
    imgViewProfile.backgroundColor = [UIColor blackColor];

    UIView *viewName = (UIView *)[cell viewWithTag:30];
    //viewName.layer.cornerRadius = 5.0;
    //[viewName.layer setMasksToBounds:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* birthday = [formatter dateFromString:userFriends.frddob];
    
    //                                                                 NSDate* now = [NSDate date];
    //                                                                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
    //                                                                                                    components:NSCalendarUnitYear
    //                                                                                                    fromDate:birthday
    //                                                                                                    toDate:now
    //                                                                                                    options:0];
    
    NSInteger age = [self age:birthday];
   // lblName.text = [NSString stringWithFormat:@"%@, %ld",[_selecteduserFriend.frdName capitalizedString],age];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:40];
    lblName.text =  [NSString stringWithFormat:@"%@",[userFriends.frdName capitalizedString]];
    
    UILabel *lblOnline = (UILabel *)[cell viewWithTag:20];
    lblOnline.layer.cornerRadius = 5.0f;
    lblOnline.layer.borderWidth = 1.0f;
    lblOnline.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.contentView.layer.cornerRadius = 5.0;
    [cell.contentView.layer setMasksToBounds:YES];
    
     UILabel *lblAge = (UILabel *)[cell viewWithTag:45];
    lblAge.text =  [NSString stringWithFormat:@"%ld",(long)age];
    
    if ([userFriends.onlineStatus isEqualToString:@"1"]) {
        lblOnline.layer.borderColor = [[UIColor greenColor] CGColor];
        lblOnline.text = @"ONLINE";
        lblOnline.textColor = [UIColor greenColor];
    }
    else
    {
        lblOnline.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        lblOnline.text = @"OFFLINE";
        lblOnline.textColor = [UIColor lightGrayColor];
    }
    
   // UIView *strView = (UIView *)[cell viewWithTag:300];
   // float rating = (userFriends.pointstar.intValue)*100/6;
   // if ((userFriends.pointstar.intValue) != 0) {

//    EDStarRating *starRating = (EDStarRating *)[cell viewWithTag:300];
//    if (starRating.subviews.count == 0) {
//        //float rating = (_selecteduserFriend.pointstar.intValue)*100/6;
//        rating = 3;
//        //  if ((_selecteduserFriend.pointstar.intValue) != 0) {
//        starRating.backgroundColor  = [UIColor whiteColor];
//        starRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        starRating.maxRating = 6.0;
//        starRating.delegate = self;
//        starRating.horizontalMargin = 0.0;
//        starRating.editable=NO;
//        starRating.rating = rating;
//        starRating.displayMode=EDStarRatingDisplayHalf;
//        [starRating  setNeedsDisplay];
//        starRating.tintColor = [UIColor colorWithRed:157.0/255.0 green:0 blue:33.0/255.0 alpha:1.0];
//        //[self starsSelectionChanged:_starRating rating:2.5];
//        //}
//    }

    //}
    if ([[HelpDesk sharedInstance] loadImageFromCache:userFriends.fndImage] != nil){
        imgViewProfile.image = [[HelpDesk sharedInstance] loadImageFromCache:userFriends.fndImage];
    }
    else
    {
        if (!userFriends.imageIcon && userFriends.fndImage.length > 0)
        {
            imgViewProfile.image = [UIImage imageNamed:@""];
            [self startDownloadImage:userFriends withTag:indexPath];
        }
    }
    
        return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserFriends *userFriends = [arrayMatches objectAtIndex:indexPath.item];
    DetailViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    details.selecteduserFriend = userFriends;
    details.typeUser = @"friend";
    [self.navigationController pushViewController:details animated:YES];


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        CGFloat side = collectionView.frame.size.width-20;
        return CGSizeMake(side, 98.0f);
}

- (void)startDownloadImage:(UserFriends*)friendDetails withTag:(NSIndexPath *)indexpath
{
    IconDownloaderImage *iconDownloader = [imageDownloadsInProgress objectForKey:indexpath];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloaderImage alloc] init];
        iconDownloader.userFriends = friendDetails;
        iconDownloader.indexPathinCollectionView = indexpath;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexpath];
        [iconDownloader startDownload];
    }
}


- (void)appDidDownloadImage:(NSIndexPath *)indexpath;
{
    IconDownloaderImage *iconDownloader = [imageDownloadsInProgress objectForKey:indexpath];
    
    if (iconDownloader != nil)
    {
        [[HelpDesk sharedInstance] saveImageToCache:iconDownloader.userFriends.imageIcon withName:iconDownloader.userFriends.fndImage];
        
        [_collectionView reloadItemsAtIndexPaths:@[indexpath]];
        
        
    }
    [imageDownloadsInProgress removeObjectForKey:indexpath];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (void)refreshMatches:(NSNotification *)notification
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudProgress.delegate = self;
        
        hudProgress.mode = MBProgressHUDModeIndeterminate;
        hudProgress.labelText = @"Loading";
        hudProgress.dimBackground = YES;
        //infowebtechsolutions.com/demo/twzapp/match.php?user_id=11
        NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/message_list_contacts.php",BASEURL];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
            
            if(error) {
                NSLog(@"error : %@", [error description]);
            } else {
                // This is the expected result
                NSLog(@"Matches result : %@", result);
                if (result.count >0) {
                    if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        if (result[@"result"] != [NSNull null]) {
                            
                            
                            NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                            arrResponse = result[@"result"];
                            if (arrResponse.count > 0) {
                                
                                [arrayMatches removeAllObjects];
                                for (NSDictionary *dict in arrResponse) {
                                    
                                    UserFriends *listfriends = [[UserFriends alloc] init];
                                    listfriends.frdId = [dict objectForKey:@"registerid"];
                                    listfriends.frdName = [dict objectForKey:@"name"];
                                    listfriends.frddob = [dict objectForKey:@"dob"];
                                    listfriends.fndImage = [dict objectForKey:@"profilepicture"];
                                    listfriends.fndEmail = [dict objectForKey:@"email"];
                                    listfriends.fndDescription = [dict objectForKey:@"description"];
                                    listfriends.fndGender = [dict objectForKey:@"gender"];
                                    listfriends.birthtime = [dict objectForKey:@"birthtime"];
                                    listfriends.height = [dict objectForKey:@"height"];
                                    listfriends.weight = [dict objectForKey:@"weight"];
                                    listfriends.frd_fb_Id = [dict objectForKey:@"facebookid"];
                                    
                                    
                                    [arrayMatches addObject:listfriends];
                                    
                                    
                                }
                                [_collectionView reloadData];
                            }
                        }
                        
                    }else{
                        
                    }
                }
                
                
            }
            
            [self hudWasHidden:hudProgress];
            
        }];
    }
}
@end


