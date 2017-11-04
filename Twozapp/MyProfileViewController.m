//
//  MyProfileViewController.m
//  Twozapp
//
//  Created by Priya on 16/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "MyProfileViewController.h"
#import "UserDetails.h"
#import "NetworkManager.h"
#import "UserDetails.h"
#import "MBProgressHUD.h"
#import "MyIconDownloader.h"
#import "HelpDesk.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhoto.h>
#import "NYTExamplePhoto.h"
#import "SlideAlertiOS7.h"
#import "ProfileOneViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"



@interface MyProfileViewController ()<MBProgressHUDDelegate, MyIconDownloaderDelegate>
{
    MBProgressHUD *hudProgress;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *keys;
    NSMutableArray *imgArray;
    int y;
    float totalHeight;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (imgArray.count > 0){
        [imgArray removeAllObjects];
    }
    
    keys = [[NSMutableArray alloc] init];
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    //[self performSelector:@selector(requestIntrestList) withObject:nil afterDelay:0.25];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton"]
                                                 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = _leftMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    
    // Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated{
    [self requestProfileDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)requestProfileDetails{
    
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
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/viewprofile.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                                                     if(error) {
                                                         NSLog(@"error : %@", [error description]);
                                                     } else {
                                                         // This is the expected result
                                                         NSLog(@"Intrest result : %@", result);
                                                         if (result.count >0) {
                                                             if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                                
                                                                 
                                                                 UserDetails *userDetails = [UserDetails sharedInstance];
                                                                 userDetails.fb_id = result[@"facebookid"];
                                                                 userDetails.email = result[@"email"];
                                                                 userDetails.full_name = result[@"fullname"];
                                                                 userDetails.latitude = result[@"latitude"];
                                                                 userDetails.logitude = result[@"longitude"];
                                                                 userDetails.dob = result[@"dob"];
                                                                 userDetails.birthtime = result[@"birthtime"];
                                                                 if ([result[@"birthtime"] isEqualToString:@"00:01:00"]) {
                                                                     userDetails.birthtime = @"-- --";
                                                                 }
                                                                 
                                                                 userDetails.descriptions = result[@"description"];
                                                                 userDetails.gender = result[@"gender"];
                                                                 userDetails.height = result[@"height"];
                                                                 userDetails.lookingfor = result[@"lookingfor"];
                                                                 userDetails.profileDistance = result[@"profile_distance"];               userDetails.weight = result[@"weight"];
                                                                 userDetails.datingid = result[@"datingid"];
                                                                 userDetails.keyword1 = result[@"keyword1"];
                                                                 userDetails.keyword2 = result[@"keyword2"];
                                                                 userDetails.keyword3 = result[@"keyword3"];
                                                                 [keys removeAllObjects];
                                                                 if (userDetails.keyword1.length > 0) {
                                                                     [keys insertObject:userDetails.keyword1 atIndex:0];
                                                                     //[keys addObject:userDetails.keyword1];
                                                                 }
                                                                 if (userDetails.keyword2.length > 0) {
                                                                     [keys insertObject:userDetails.keyword2 atIndex:0];
                                                                     //[keys addObject:userDetails.keyword2];
                                                                 }
                                                                 if (userDetails.keyword3.length > 0) {
                                                                     //[keys addObject:userDetails.keyword3];
                                                                     [keys insertObject:userDetails.keyword3 atIndex:0];
                                                                 }
                                                                 
                                                                 userDetails.keywords = keys;
                                                                 
                                                                 userDetails.image1 = result[@"profile_picture"];
                                                                 userDetails.image2 = result[@"imageurl2"];
                                                                 userDetails.image3 = result[@"imageurl3"];

                                                                 
                                                                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                 [formatter setDateFormat:@"yyyy-MM-dd"];
                                                                 NSDate* birthday = [formatter dateFromString:[UserDetails sharedInstance].dob];
                                                                 
//                                                                 NSDate* now = [NSDate date];
//                                                                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
//                                                                                                    components:NSCalendarUnitYear
//                                                                                                    fromDate:birthday
//                                                                                                    toDate:now
//                                                                                                    options:0];
                                                                 
                                                                 NSInteger age = [self age:birthday];
                                                                 //_lblName.text = [NSString stringWithFormat:@"%@, %ld",[UserDetails sharedInstance].full_name,age];
                                                               //  _txtView.text = [UserDetails sharedInstance].descriptions;
                                                                 if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image1] == nil){
                                                                     [self startDownloadImage:userDetails.image1 withID:@"1"];
                                                                 }
                                                                 if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image2] == nil){
                                                                     [self startDownloadImage:userDetails.image2 withID:@"2"];
                                                                 }
                                                                 if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image3] == nil){
                                                                     [self startDownloadImage:userDetails.image3 withID:@"3"];
                                                                 }
                                                                 
                                                                 if ([[HelpDesk sharedInstance] loadImageFromCache:userDetails.image1] != nil)  {
//                                                                     UIImage *image = [[HelpDesk sharedInstance] loadImageFromCache:userDetails.image1];
//                                                                     _imagViewMyProfilePic.image = image;
                                                                     
                                                                     imgArray = [[NSMutableArray alloc] init];
                                                                     
                                                                     NSString *img1 = userDetails.image1;
                                                                     NSString *img2 = userDetails.image2;
                                                                     NSString *img3 = userDetails.image3;
                                                                     
                                                                     if (![img1 isEqualToString:@"(null)"] && img1.length != 0) {
                                                                         [imgArray addObject:img1];
                                                                     }
                                                                     if (![img2 isEqualToString:@"(null)"] && img2.length != 0) {
                                                                         [imgArray addObject:img2];
                                                                     }
                                                                     if (![img3 isEqualToString:@"(null)"] && img3.length != 0) {
                                                                         [imgArray addObject:img3];
                                                                     }
                                                                     
                                                                     NSLog(@"Images Array: %@", imgArray);
                                                                     
                                                                     [_tblView reloadData];
                                                                     
                                                                     
                                                                 }
                                                                 //[_CollectionViewIntrest reloadData];
                                                                 [self hudWasHidden:hudProgress];
                                                                 }
                                                                 
                                                                 
                                                             }else{
                                                                 
                                                             }
                                                         }
                                                     
                                                     
                                                     
                                                 }];
    }

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return keys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 3.0f;
    [cell.layer setMasksToBounds:YES];
    
   
    
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:20];
    // lblTitle.text = [keys objectAtIndex:indexPath.item];
//    if (indexPath.item == 0) {
//      lblTitle.text = [UserDetails sharedInstance].keyword1;
//    }
//    else if (indexPath.item == 1)
//    {
//        lblTitle.text = [UserDetails sharedInstance].keyword2;
//    }
//    else if (indexPath.item == 2)
//    {
//        lblTitle.text = [UserDetails sharedInstance].keyword3;
//    }
    lblTitle.text = keys[indexPath.item];
    
    
    return cell;
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

//- (NSString *)age:(NSDate *)dateOfBirth {
//    
//    NSInteger years;
//    NSInteger months;
//    NSInteger days = 0;
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
//    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
//    
//    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
//        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
//        years = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
//    } else {
//        years = [dateComponentsNow year] - [dateComponentsBirth year];
//    }
//    
//    NSLog(@"years:%ld", (long)years);
//    
//    if ([dateComponentsNow year] == [dateComponentsBirth year]) {
//      return @"0";
//    } else if ([dateComponentsNow year] > [dateComponentsBirth year] && [dateComponentsNow month] > [dateComponentsBirth month]) {
//        return [NSString stringWithFormat:@"%ld",[dateComponentsNow year] - [dateComponentsBirth year]];
//    } else if ([dateComponentsNow year] > [dateComponentsBirth year] && [dateComponentsNow month] < [dateComponentsBirth month]) {
//        return [NSString stringWithFormat:@"%ld",[dateComponentsNow year] - [dateComponentsBirth year] - 1];
//    } else if ([dateComponentsNow year] > [dateComponentsBirth year] && [dateComponentsNow month] == [dateComponentsBirth month]) {
//        return [NSString stringWithFormat:@"%ld",[dateComponentsNow year] - [dateComponentsBirth year]];
//    } else {
//        return [NSString stringWithFormat:@"%ld",[dateComponentsNow year] - [dateComponentsBirth year]];
//    }
//    
//    
////    if ([dateComponentsNow year] == [dateComponentsBirth year] && [dateComponentsNow month] == [dateComponentsBirth month]) {
////        days = [dateComponentsNow day] - [dateComponentsBirth day];
////    }
////    
////    if (years == 0 && months == 0) {
////        if (days == 1) {
////            return @"0";
////        } else {
////            return @"0";
////        }
////    } else if (years == 0) {
////        return @"0";
////    } else if ((years != 0) && (months == 0)) {
////        if (years == 1) {
////            return @"1";
////        } else {
////            return [NSString stringWithFormat:@"%ld", (long)years];
////        }
////    } else {
////        if ((years == 1) && (months == 1)) {
////            return @"1";
////        } else if (years == 1) {
////            return @"1";
////        } else if (months == 1) {
////            return [NSString stringWithFormat:@"%ld", (long)years];
////        } else {
////            return [NSString stringWithFormat:@"%ld", (long)years];
////        }
////        
////    }
//    
//}


- (IBAction)actionEdit:(id)sender {
    
    [self performSegueWithIdentifier:@"toeditProfile" sender:nil];
    self.navigationItem.title = @"";
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (void)startDownloadImage:(NSString*)imageUrl withID:(NSString *)url
{
    MyIconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:url];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[MyIconDownloader alloc] init];
        iconDownloader.imageURL = imageUrl;
        iconDownloader.url = url;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:url];
        [iconDownloader startDownload];
    }
}

- (void)appDidDownloadImagewithURl:(NSString *)url
{
    UIImage *image = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].profilepicture];
    _imagViewMyProfilePic.image = image;
    [imageDownloadsInProgress removeObjectForKey:url];
    if (imageDownloadsInProgress.count == 0) {
        [self hudWasHidden:hudProgress];
    }
    
}

- (IBAction)actionShowProfilePic:(id)sender {
    
    UIImage *img1 = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1];
    //UIImage *img2 = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2];
    //UIImage *img3 = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    if (img1 != nil) {
        NYTExamplePhoto *photo1 = [[NYTExamplePhoto alloc] init];
        photo1.image = img1;
        [imgArray addObject:photo1];
    }
    /*if (img2 != nil) {
        NYTExamplePhoto *photo2 = [[NYTExamplePhoto alloc] init];
        photo2.image = img2;
        [imgArray addObject:photo2];
    }
    if (img3 != nil) {
        NYTExamplePhoto *photo3 = [[NYTExamplePhoto alloc] init];
        photo3.image = img3;
        [imgArray addObject:photo3];
    }*/
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:imgArray];
    photosViewController.rightBarButtonItem = nil;
    [self presentViewController:photosViewController animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = keys[indexPath.row];
    UIFont *myFont = [UIFont systemFontOfSize:13];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:key
                                    attributes:@{NSFontAttributeName: myFont}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, 30}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return CGSizeMake(rect.size.width + 30, 30);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toeditProfile"]) {
        ProfileOneViewController *profile = (ProfileOneViewController *)segue.destinationViewController;
        profile.actionType = @"edit";
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    if (indexPath.row == 0) {
        
        NSLog(@"Screen Width: %f", [[UIScreen mainScreen] bounds].size.width);
        return [[UIScreen mainScreen] bounds].size.width + 115;
    }
    else
    {
    return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        NSLog(@"Screen Width: %f", [[UIScreen mainScreen] bounds].size.width);
        return [[UIScreen mainScreen] bounds].size.width + 115;
    }
    else
    {
        return UITableViewAutomaticDimension;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"image" forIndexPath:indexPath];
        
        UIView *view = [cell viewWithTag:100];
        
        
        scrollView = (UIScrollView *)[view viewWithTag:13];
        pageControl = (UIPageControl *)[view viewWithTag:97];
        NSLog(@"Imagesssssss: %@", imgArray);
        
        int a=0;
        scrollView.pagingEnabled=YES;
        
        if (imgArray.count <= 3) {
            for (int i=0; i<imgArray.count; i++)
            {
                NSLog(@"Image: %d", i);
                UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(a, 0,[[UIScreen mainScreen] bounds].size.width, scrollView.frame.size.height)];
                img.backgroundColor = [UIColor blackColor];
                img.contentMode = UIViewContentModeScaleAspectFill;
                [img setClipsToBounds:YES];
                int indexValue = [imgArray indexOfObject:[imgArray objectAtIndex:i]];
                //NSURL *url = [NSURL URLWithString:[imgArray objectAtIndex:i]];
                //NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                //UIImage *tmpImage = [[UIImage alloc] initWithData:data];
                //img.image = tmpImage;
                pageControl.backgroundColor=[UIColor clearColor];
                if (imgArray.count <= 3){
                    pageControl.numberOfPages=imgArray.count;
                } else {
                    pageControl.numberOfPages=3;
                }
                pageControl.currentPage = 0;
                
                
                UIActivityIndicatorView  *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                activity.frame = CGRectMake(round(([[UIScreen mainScreen] bounds].size.width - 25) / 2), round((scrollView.frame.size.height - 25) / 2), 25, 25);
                activity.hidden = NO;
                [activity startAnimating];
                [img sd_setImageWithURL:[NSURL URLWithString:[imgArray objectAtIndex:i]] placeholderImage:nil options:indexPath.row == 0 ? SDWebImageRefreshCached : 0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [activity stopAnimating];
                    activity.hidden = YES;
                }];
                
                //img.image=[UIImage imageNamed:[image objectAtIndex:i]];
                a=a+[[UIScreen mainScreen] bounds].size.width;
                [scrollView addSubview:img];
                [scrollView addSubview:activity];
            }
        } else {
            for (int i=3; i<=5; i++)
            {
                NSLog(@"Image: %d", i);
                UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(a, 0,[[UIScreen mainScreen] bounds].size.width, scrollView.frame.size.height)];
                
                int indexValue = [imgArray indexOfObject:[imgArray objectAtIndex:i]];
                //NSURL *url = [NSURL URLWithString:[imgArray objectAtIndex:i]];
                //NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                //UIImage *tmpImage = [[UIImage alloc] initWithData:data];
                //img.image = tmpImage;
                pageControl.backgroundColor=[UIColor clearColor];
                pageControl.numberOfPages=3;
                pageControl.currentPage = 0;
                
                
                UIActivityIndicatorView  *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activity.frame = CGRectMake(round(([[UIScreen mainScreen] bounds].size.width - 25) / 2), round((scrollView.frame.size.height - 25) / 2), 25, 25);
                activity.hidden = NO;
                [activity startAnimating];
                [img sd_setImageWithURL:[NSURL URLWithString:[imgArray objectAtIndex:i]] placeholderImage:nil options:indexPath.row == 0 ? SDWebImageRefreshCached : 0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [activity stopAnimating];
                    activity.hidden = YES;
                }];
                
                //img.image=[UIImage imageNamed:[image objectAtIndex:i]];
                a=a+[[UIScreen mainScreen] bounds].size.width;
                [scrollView addSubview:img];
                //[scrollView addSubview:activity];
            }
        }
        

        scrollView.contentSize=CGSizeMake(a, scrollView.frame.size.height);
        scrollView.contentOffset=CGPointMake(0, 0);
        
        UIButton *btnView = (UIButton *)[view viewWithTag:20];
        [btnView addTarget:self action:@selector(actionShowProfilePic:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnEdit = (UIButton *)[view viewWithTag:40];
        [btnEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *viewName = (UIView *)[cell viewWithTag:30];
        //viewName.layer.cornerRadius = 7.0f;
        [viewName.layer setMasksToBounds:YES];
        UILabel *lblName = (UILabel *)[viewName viewWithTag:10];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* birthday = [formatter dateFromString:[UserDetails sharedInstance].dob];
        
        //                                                                 NSDate* now = [NSDate date];
        //                                                                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
        //                                                                                                    components:NSCalendarUnitYear
        //                                                                                                    fromDate:birthday
        //                                                                                                    toDate:now
        //                                                                                                    options:0];
        
        NSInteger age = [self age:birthday];
        lblName.text = [NSString stringWithFormat:@"%@, %ld",[[UserDetails sharedInstance].full_name capitalizedString],age];
        
        //UIImage *image = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1];
        //imgView.image = image;
        
        
        UIView *keywordView = (UIView *)[cell viewWithTag:31];
        for (UIView *vw in keywordView.subviews) {
            [vw removeFromSuperview];
        }
        
        int x = 0;
        y = 5;
        float totalWidth = 0;
        totalHeight = 44;
        for (int i = 0; i < keys.count; i++) {
            NSString *key = keys[i];
            UIFont *myFont = [UIFont systemFontOfSize:14];
            
            NSAttributedString *attributedText =
            [[NSAttributedString alloc] initWithString:key
                                            attributes:@{NSFontAttributeName: myFont}];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, 30}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            totalWidth = x + rect.size.width + 10;
            if (totalWidth > cell.frame.size.width) {
                x = 0;
                totalWidth = x + rect.size.width + 10;
                y = y + rect.size.height + 20;
                totalHeight = y + rect.size.height + 20;
                
            }
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(x, y, rect.size.width + 10, rect.size.height + 10)];
            view1.backgroundColor = [UIColor clearColor];
            view1.layer.borderWidth = 1.0f;
            view1.layer.borderColor = [[UIColor whiteColor] CGColor];
            view1.layer.cornerRadius = 10.0f;
            view1.layer.masksToBounds = YES;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, rect.size.width + 5, rect.size.height + 5)];
            [lbl setFont:[UIFont systemFontOfSize:11]];
            lbl.textColor = [UIColor whiteColor];
            lbl.text = key;
            [view1 addSubview:lbl];
            [keywordView addSubview:view1];
            x = totalWidth + 10;
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:indexPath];
        
        UICollectionView *clnView = (UICollectionView *)[cell viewWithTag:10];
        [clnView reloadData];
        UILabel *lblDesc = (UILabel *)[cell viewWithTag:30];
        if ([[UserDetails sharedInstance].descriptions isEqualToString:@"(null)"]) {
            lblDesc.text = @"";
        }
        else
        {
            lblDesc.text = [UserDetails sharedInstance].descriptions;
        }
        
        UILabel *lblDesc1 = (UILabel *)[cell viewWithTag:54];
        
        lblDesc1.layer.cornerRadius = 3.0f;
        lblDesc1.layer.borderWidth = 1.0f;
        lblDesc1.layer.borderColor = [[UIColor colorWithRed:47/255.0 green:193/255.0 blue:242/255.0 alpha:1.0f] CGColor];
        UIImageView *roughImg = (UIImageView *)[cell viewWithTag:45];
        
        lblDesc1.text = [NSString stringWithFormat:@"%@ km", [UserDetails sharedInstance].profileDistance];
        
        [self performSelector:@selector(reloadConstraints) withObject:nil afterDelay:0.25];
        return cell;
        
    } else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"kilometer" forIndexPath:indexPath];
        
        return cell;
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self->scrollView.frame.size.width;
    float fractionalPage = self->scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self->pageControl.currentPage = page;
}

- (void)reloadConstraints
{
    UITableViewCell *tblcell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIView *cllctionView = (UIView *)[tblcell viewWithTag:50];
    NSArray *colconstraints = [cllctionView constraints];
    int colindex = 0;
    BOOL colfound = NO;
    
    while (!colfound && colindex < [colconstraints count]) {
        NSLayoutConstraint *constraint = colconstraints[colindex];
        if ( [constraint.identifier isEqualToString:@"collectionHeight"] ) {
            //save the reference to constraint
            colfound = YES;
            [_tblView beginUpdates];
            constraint.constant = totalHeight;
            [tblcell needsUpdateConstraints];
            [_tblView endUpdates];
        }
        colindex ++;
    }
    
    
    
}




@end
