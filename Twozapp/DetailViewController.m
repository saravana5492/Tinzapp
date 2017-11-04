//
//  DetailViewController.m
//  Twozapp
//
//  Created by Priya on 16/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "MyIconDownloader.h"
#import "HelpDesk.h"
#import "ChatViewController.h"
#import "allChatViewController.h"
#import "SlideAlertiOS7.h"
#import "MatchesViewController.h"
#import "AppDelegate.h"
#import "EDStarRating.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhoto.h>
#import "NYTExamplePhoto.h"


@interface DetailViewController ()<MBProgressHUDDelegate, MyIconDownloaderDelegate, EDStarRatingProtocol>
{
    MBProgressHUD *hudProgress;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *totalImages;
    BOOL matchfound;
    BOOL chatfound;
    NSMutableArray *keys;
    int y;
    float totalHeight;
    NSMutableArray *imgArray;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    totalImages = [[NSMutableArray alloc] init];
    matchfound = NO;
    chatfound = NO;
    keys = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextCount:) name:@"UPDATECHATCOUNT" object:nil];
//    StarRatingView *strVW = [[StarRatingView alloc]initWithFrame:CGRectMake(0, 0, _starRating.frame.size.width, _starRating.frame.size.height) andRating:(_selecteduserFriend.pointstar.intValue / 6)*100 withLabel:NO animated:YES];
//    strVW.userInteractionEnabled = NO;
//    [_starRating  addSubview: strVW];
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
//    _viewBazi.layer.cornerRadius = 7.0;
//    [_viewBazi.layer setMasksToBounds:YES];
//    _imgviewProfile.layer.cornerRadius = 7.0;
//    [_imgviewProfile.layer setMasksToBounds:YES];
//    _viewProfileContent.layer.cornerRadius = 7.0;
//    [_viewProfileContent.layer setMasksToBounds:YES];
    
//    _viewName.layer.cornerRadius = 7.0;
//    [_viewName.layer setMasksToBounds:YES];
    _viewMatch.layer.cornerRadius = 5.0;
    [_viewMatch.layer setMasksToBounds:YES];
    _viewChat.layer.cornerRadius = 5.0;
    [_viewChat.layer setMasksToBounds:YES];
    
    if ([_typeUser isEqualToString:@"new"]) {
        _viewChat.hidden = YES;
        _viewMatch.hidden = YES;
    }
    else
    {
        _viewChat.hidden = NO;
        _viewMatch.hidden = NO;
    }
    
    //_imgviewProfile.image = [UIImage imageNamed:@"imgSample.png"];
    // Do any additional setup after loading the view.
    [self requestProfileDetails];
//    UIImage *navImage =  [[UIImage imageNamed:@"navigationbar"]
//                          resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//    
//    [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsCompact];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    UILabel *fakeTitleView = [[UILabel alloc] init];
    //fakeTitleView.hidden = YES;
    [self.navigationItem setTitleView:fakeTitleView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
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
    
    UIButton *btnDelete = (UIButton *)[cell viewWithTag:10];
    [btnDelete.layer setMasksToBounds:YES];
    [btnDelete addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:20];
   // lblTitle.text = [keys objectAtIndex:indexPath.item];
    //lblTitle.text = @"Fun";
    
//    if (indexPath.item == 0) {
//        lblTitle.text = _selecteduserFriend.keyword1;
//    }
//    else if (indexPath.item == 1)
//    {
//        lblTitle.text = _selecteduserFriend.keyword2;
//    }
//    else if (indexPath.item == 2)
//    {
//        lblTitle.text = _selecteduserFriend.keyword3;
//    }
    lblTitle.text = keys[indexPath.item];
    return cell;
}

/*- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *key = keys[indexPath.item];
//    UIFont *myFont = [UIFont fontWithName:@"Segoe Print" size:17.0];
//    
//    NSAttributedString *attributedText =
//    [[NSAttributedString alloc] initWithString:key
//                                    attributes:@{NSFontAttributeName: myFont}];
//    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, 30}
//                                               options:NSStringDrawingUsesLineFragmentOrigin
//                                               context:nil];
    return 1;
}*/

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
    NSString *string = [NSString stringWithFormat:@"fb_id=%@",_selecteduserFriend.frd_fb_Id];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Intrest result : %@", result);
            
            [self hudWasHidden:hudProgress];
            
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    
                    _selecteduserFriend.fndEmail = result[@"email"];//
                    _selecteduserFriend.frdName = result[@"fullname"];//
                    _selecteduserFriend.frdLat = result[@"latitude"];//
                    _selecteduserFriend.frdLong = result[@"longitude"];//
                    _selecteduserFriend.frddob = result[@"dob"];//
                    //_selecteduserFriend.birthtime = result[@"birthtime"];
                    _selecteduserFriend.fndGender = result[@"gender"];//
                    _selecteduserFriend.height = result[@"height"];//
                    _selecteduserFriend.weight = result[@"weight"];//
                    _selecteduserFriend.datingid = result[@"datingid"];//
                    _selecteduserFriend.keyword1 = result[@"keyword1"];//
                    _selecteduserFriend.keyword2 = result[@"keyword2"];//
                    _selecteduserFriend.keyword3 = result[@"keyword3"];//
                    _selecteduserFriend.image1 = result[@"profile_picture"];//
                    _selecteduserFriend.image2 = result[@"imageurl2"];//
                    _selecteduserFriend.image3 = result[@"imageurl3"];//
                    //_selecteduserFriend.image3 = result[@"img3"];
                    _selecteduserFriend.fndDescription = result[@"description"];//
                    
                    [keys removeAllObjects];
                    
                    NSLog(@"Images List: %@, %@, %@", _selecteduserFriend.image1, _selecteduserFriend.image2, _selecteduserFriend.image3);

//                    if (_selecteduserFriend.keyword1.length > 0) {
//                        [keys addObject:_selecteduserFriend.keyword1];
//                    }
//                    if (_selecteduserFriend.keyword2.length > 0) {
//                        [keys addObject:_selecteduserFriend.keyword2];
//                    }
//                    if (_selecteduserFriend.keyword3.length > 0) {
//                        [keys addObject:_selecteduserFriend.keyword3];
//                    }
//                    if (_selecteduserFriend.keyword4.length > 0) {
//                        [keys addObject:_selecteduserFriend.keyword4];
//                    }
//                    if (_selecteduserFriend.keyword5.length > 0) {
//                        [keys addObject:_selecteduserFriend.keyword5];
//                    }
                    
                    if (_selecteduserFriend.keyword1.length > 0) {
                        [keys insertObject:_selecteduserFriend.keyword1 atIndex:0];
                        //[keys addObject:userDetails.keyword1];
                    }
                    if (_selecteduserFriend.keyword2.length > 0) {
                        [keys insertObject:_selecteduserFriend.keyword2 atIndex:0];
                        //[keys addObject:userDetails.keyword2];
                    }
                    if (_selecteduserFriend.keyword3.length > 0) {
                        //[keys addObject:userDetails.keyword3];
                        [keys insertObject:_selecteduserFriend.keyword3 atIndex:0];
                    }
                    
                    if ([_selecteduserFriend.image1 rangeOfString:IMAGEBASEURL].location != NSNotFound) {
                        [totalImages addObject:_selecteduserFriend.image1];
                    }
                    if ([_selecteduserFriend.image2 rangeOfString:IMAGEBASEURL].location != NSNotFound) {
                        [totalImages addObject:_selecteduserFriend.image2];
                    }
                    if ([_selecteduserFriend.image3 rangeOfString:IMAGEBASEURL].location != NSNotFound) {
                        [totalImages addObject:_selecteduserFriend.image3];
                    }
                    
                    NSString *img1 = _selecteduserFriend.image1;
                    NSString *img2 = _selecteduserFriend.image2;
                    NSString *img3 = _selecteduserFriend.image3;
                    
                    imgArray = [[NSMutableArray alloc] init];

                    if (img1.length != 0) {
                        [imgArray addObject:img1];
                    }
                    if (img2.length != 0) {
                        [imgArray addObject:img2];
                    }
                    if (img3.length != 0) {
                        [imgArray addObject:img3];
                    }
                    
                    NSLog(@"Images Array: %@, %@", _selecteduserFriend.image3, imgArray);
                    
                    [self getUnreadMessageCountforFriendId:_selecteduserFriend.frd_fb_Id];

                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate* birthday = [formatter dateFromString:_selecteduserFriend.frddob];
                    
                    
                    NSInteger age = [self age:birthday];
                    _lblName.text = [NSString stringWithFormat:@"%@, %ld",_selecteduserFriend.frdName,(long)age];
                    if ([[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image1] == nil){
                        [self startDownloadOtherImage:_selecteduserFriend.image1 withID:@"1"];
                    }
                    if ([[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image2] == nil){
                        [self startDownloadOtherImage:_selecteduserFriend.image2 withID:@"2"];
                    }
                    if ([[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image3] == nil){
                        [self startDownloadOtherImage:_selecteduserFriend.image3 withID:@"3"];
                    }
                    
                    
                    if ([[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image1] != nil) {
                        
                        [_tblView reloadData];

                        [self hudWasHidden:hudProgress];
                    }
                    
                    UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    UIView *view = (UIView *)[cell viewWithTag:10];
                    UICollectionView *cllctnView = (UICollectionView *)[view viewWithTag:1000];

                    [cllctnView reloadData];
                }
                
                
            }else{
                
            }
        }
        
        
        
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


- (IBAction)actionDelete:(id)sender {
}



- (IBAction)actionChat:(id)sender {
    NSArray *viewcontrollers = [self.navigationController viewControllers];
    NSInteger index = 0;
    BOOL found = NO;
    for (UIViewController *viewcontroller in viewcontrollers) {
        if ([viewcontroller isKindOfClass:[ChatViewController class]]) {
            index = [viewcontrollers indexOfObject:viewcontroller];
            found = YES;
        }
    }
    if (found) {
        ChatViewController *chat = (ChatViewController *)[viewcontrollers objectAtIndex:index];
        [self.navigationController popToViewController:chat animated:YES];
    }
    else if([_typeUser isEqualToString:@"friend"])
    {
        [self performSegueWithIdentifier:@"tochat" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"toAllchat" sender:nil];
    }
}




- (IBAction)actionMatch:(id)sender {
    
    NSArray *viewcontrollers = [self.navigationController viewControllers];
    NSInteger index = 0;
    BOOL found = NO;
    for (UIViewController *viewcontroller in viewcontrollers) {
        if ([viewcontroller isKindOfClass:[MatchesViewController class]]) {
            index = [viewcontrollers indexOfObject:viewcontroller];
            found = YES;
        }
    }
    if (found) {
        MatchesViewController *match = (MatchesViewController *)[viewcontrollers objectAtIndex:index];
        [self.navigationController popToViewController:match animated:YES];
    }
    else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MatchesViewController *matches = [story instantiateViewControllerWithIdentifier:@"MatchesViewController"];
        [self.navigationController pushViewController:matches animated:YES];
    }
    
}

- (IBAction)actionShowPhotos:(id)sender {
    
    
 /*
    UIImage *img1 = [[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image1];
    UIImage *img2 = [[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image2];
    UIImage *img3 = [[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image3];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    if (img1 != nil) {
        NYTExamplePhoto *photo1 = [[NYTExamplePhoto alloc] init];
        photo1.image = img1;
        [imgArray addObject:photo1];
    }
    if (img2 != nil) {
        NYTExamplePhoto *photo2 = [[NYTExamplePhoto alloc] init];
        photo2.image = img2;
        [imgArray addObject:photo2];
    }
    if (img3 != nil) {
        NYTExamplePhoto *photo3 = [[NYTExamplePhoto alloc] init];
        photo3.image = img3;
        [imgArray addObject:photo3];
    }
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:imgArray];
    photosViewController.rightBarButtonItem = nil;
    [self presentViewController:photosViewController animated:YES completion:nil]; */
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (void)startDownloadImage:(NSString*)imgURL
{
    MyIconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:@"1"];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[MyIconDownloader alloc] init];
        iconDownloader.imageURL = imgURL;
        iconDownloader.url = @"1";
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:@"1"];
        [iconDownloader startDownload];
    }
}

- (void)startDownloadOtherImage:(NSString*)imgURL withID:(NSString *)string
{
    MyIconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:string];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[MyIconDownloader alloc] init];
        iconDownloader.imageURL = imgURL;
        iconDownloader.url = string;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:string];
        [iconDownloader startDownload];
    }
}


- (void)appDidDownloadImagewithURl:(NSString *)url
{
    UIImage *image = [[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image1];
    _imgviewProfile.image = image;
    [imageDownloadsInProgress removeObjectForKey:url];
    if (imageDownloadsInProgress.count == 0) {
        [self hudWasHidden:hudProgress];
    }
    
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
    if ([segue.identifier isEqualToString:@"tochat"]) {
        ChatViewController *chatView = (ChatViewController *)segue.destinationViewController;
        chatView.selectedFriend = _selecteduserFriend;
    }
    else if ([segue.identifier isEqualToString:@"toAllchat"]) {
        allChatViewController *allChatView = (allChatViewController *)segue.destinationViewController;
        allChatView.selectedFriend = _selecteduserFriend;
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
        return [[UIScreen mainScreen] bounds].size.width + 50;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"Screen Width: %f", [[UIScreen mainScreen] bounds].size.width);
        return [[UIScreen mainScreen] bounds].size.width + 50;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"image" forIndexPath:indexPath];
        
        UIView *view = [cell viewWithTag:100];
        UIImageView *imgView = (UIImageView *)[view viewWithTag:20];
        
        scrollView = (UIScrollView *)[view viewWithTag:13];
        pageControl = (UIPageControl *)[view viewWithTag:97];
        //NSLog(@"Imagesssssss: %@", imgArray);
        
        int a=0;
        scrollView.pagingEnabled=YES;
        
        if (imgArray.count <= 3) {
            for (int i=0; i<imgArray.count; i++)
            {
                NSLog(@"Image: %d", i);
                UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(a, 0, view.frame.size.width, scrollView.frame.size.height)];
                img.backgroundColor = [UIColor blackColor];
                img.contentMode = UIViewContentModeScaleAspectFill;
                [img setClipsToBounds:YES];
                int indexValue = [imgArray indexOfObject:[imgArray objectAtIndex:i]];

                pageControl.backgroundColor=[UIColor clearColor];
                pageControl.numberOfPages=imgArray.count;
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
                a=a+view.frame.size.width;
                [scrollView addSubview:img];
                [scrollView addSubview:activity];
            }
        }
        
        scrollView.contentSize=CGSizeMake(a, scrollView.frame.size.height);
        scrollView.contentOffset=CGPointMake(0, 0);
        
        
        view.layer.cornerRadius = 7.0f;
        [view.layer setMasksToBounds:YES];

        
        UIButton *btnView = (UIButton *)[view viewWithTag:30];
        [btnView addTarget:self action:@selector(actionShowPhotos:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *viewName = (UIView *)[cell viewWithTag:40];
        viewName.layer.cornerRadius = 7.0f;
        [viewName.layer setMasksToBounds:YES];
        UILabel *lblName = (UILabel *)[viewName viewWithTag:10];
        UILabel *lblPicCount = (UILabel *)[viewName viewWithTag:20];
        lblPicCount.text = [NSString stringWithFormat:@"%lu X",(unsigned long)totalImages.count];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* birthday = [formatter dateFromString:_selecteduserFriend.frddob];
        
        //                                                                 NSDate* now = [NSDate date];
        //                                                                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
        //                                                                                                    components:NSCalendarUnitYear
        //                                                                                                    fromDate:birthday
        //                                                                                                    toDate:now
        //                                                                                                    options:0];
        
        NSInteger age = [self age:birthday];
        lblName.text = [NSString stringWithFormat:@"%@, %ld",[_selecteduserFriend.frdName capitalizedString],age];
        
        if([[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image1]){
            UIImage *image = [[HelpDesk sharedInstance] loadImageFromCache:_selecteduserFriend.image1];
            imgView.image = image;
        } else {
            imgView.image = [UIImage imageNamed:@"placeHolder.png"];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:indexPath];
        UIView *view = (UIView *)[cell viewWithTag:10];
        UILabel *lblDesc = (UILabel *)[view viewWithTag:20];
        if ([_selecteduserFriend.fndDescription isEqualToString:@"(null)"]) {
            lblDesc.text = @"";
        }
        else
        {
            lblDesc.text = _selecteduserFriend.fndDescription;
        }
        
        UIView *keywordView = (UIView *)[cell viewWithTag:500];
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
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, rect.size.width + 10, rect.size.height + 10)];
            view.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
            view.layer.cornerRadius = 5.0f;
            view.layer.masksToBounds = YES;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, rect.size.width + 5, rect.size.height + 5)];
            lbl.font = [UIFont systemFontOfSize:13];
            lbl.textColor = [UIColor whiteColor];
            lbl.text = key;
            [view addSubview:lbl];
            [keywordView addSubview:view];
            x = totalWidth + 10;
        }
        
        [self performSelector:@selector(reloadConstraints) withObject:nil afterDelay:0.25];

//        [cllctnView reloadData];
        UIView *chatView = (UIView *)[view viewWithTag:30];
        UIView *matchView = (UIView *)[view viewWithTag:50];
        
        UILabel *lblCount = (UILabel *)[chatView viewWithTag:4000];
        
        lblCount.layer.cornerRadius = 10.0f;
        lblCount.layer.masksToBounds = YES;
        lblCount.hidden = YES;
        
        UILabel *heightLabel = (UILabel *)[cell viewWithTag:2000];
        UILabel *weightLabel = (UILabel *)[cell viewWithTag:2010];
        UILabel *heightHeaderLabel = (UILabel *)[cell viewWithTag:3000];
        UILabel *weightHeaderLabel = (UILabel *)[cell viewWithTag:3010];
        if (_selecteduserFriend.height.length == 0) {
            for (NSLayoutConstraint *constraint in heightLabel.constraints) {
                if ([constraint.identifier isEqualToString:@"heightHeight"]) {
                    constraint.constant = 0;
                }
            }
            for (NSLayoutConstraint *constraint in heightHeaderLabel.constraints) {
                if ([constraint.identifier isEqualToString:@"heightHeight"]) {
                    constraint.constant = 0;
                }
            }
        }
        else
        {
            
            NSLocale *locale = [NSLocale currentLocale];
            
            NSLog(@"User Country check: %@", [locale objectForKey: NSLocaleCountryCode]);
            
            if([[locale objectForKey: NSLocaleCountryCode] isEqualToString:@"IN"]){
                heightLabel.text = [NSString stringWithFormat:@"%@ ft", _selecteduserFriend.height];
            } else {
                heightLabel.text = [NSString stringWithFormat:@"%@ cm", _selecteduserFriend.height];
            }
        }
        if (_selecteduserFriend.weight.length == 0) {
            for (NSLayoutConstraint *constraint in weightLabel.constraints) {
                if ([constraint.identifier isEqualToString:@"weightHeight"]) {
                    constraint.constant = 0;
                }
            }
            for (NSLayoutConstraint *constraint in weightHeaderLabel.constraints) {
                if ([constraint.identifier isEqualToString:@"weightHeight"]) {
                    constraint.constant = 0;
                }
            }
        }
        else
        {
            weightLabel.text = [NSString stringWithFormat:@"%@ kg",_selecteduserFriend.weight];
        }
        UIButton *btnChat = (UIButton *)[cell viewWithTag:40];
        UIButton *btnMatch = (UIButton *)[cell viewWithTag:60];
        [btnChat addTarget:self action:@selector(actionChat:) forControlEvents:UIControlEventTouchUpInside];
        [btnMatch addTarget:self action:@selector(actionMatch:) forControlEvents:UIControlEventTouchUpInside];
        
        matchView.layer.cornerRadius = 5.0;
        [matchView.layer setMasksToBounds:YES];
        chatView.layer.cornerRadius = 5.0;
        [chatView.layer setMasksToBounds:YES];
        
        if ([_typeUser isEqualToString:@"new"]) {
            matchView.hidden = YES;
            chatView.hidden = NO;
            
            [btnChat addTarget:self action:@selector(actionChat:) forControlEvents:UIControlEventTouchUpInside];
            
            //chatView.center = self.view.superview.center;
            
 /*           NSArray *constraints = [chatView constraints];
            int chatindex = 0;
            
            
            while (!chatfound && chatindex < [constraints count]) {
                NSLayoutConstraint *constraint = constraints[chatindex];
                if ( [constraint.identifier isEqualToString:@"chatHeight"] ) {
                    //save the reference to constraint
                    
                    chatfound = YES;
                    constraint.constant = 0;
                    [_tblView reloadData];
                    
                }
                chatindex ++;
            }
            
            NSArray *matchesConstraints = [matchView constraints];
            int matchindex = 0;
            
            
            while (!matchfound && matchindex < [matchesConstraints count]) {
                NSLayoutConstraint *constraint = matchesConstraints[matchindex];
                if ( [constraint.identifier isEqualToString:@"matchesHeight"] ) {
                    //save the reference to constraint
                    
                    matchfound = YES;
                    constraint.constant = 0;
                    [_tblView reloadData];
                }
                matchindex ++;
            }
            
        }
        else
        {
            chatView.hidden = NO;
            matchView.hidden = NO; */
        }
        
        return cell;
        
    }
}
- (void)reloadConstraints
{
    UITableViewCell *tblcell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIView *view = [tblcell viewWithTag:10];
    UIView *cllctionView = (UIView *)[view viewWithTag:500];
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



- (void)getUnreadMessageCountforFriendId:(NSString *)friendId
{
    NSBlockOperation *downloadOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakDownloadOperation = downloadOperation;
    
    [weakDownloadOperation addExecutionBlock:^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet connection Available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        } else {
            [self requestGetUnreadMessagesfor:friendId];
        }
    }];
    
    //    NSBlockOperation *saveToDataBaseOperation = [[NSBlockOperation alloc] init];
    //    __weak NSBlockOperation *weakSaveToDataBaseOperation = saveToDataBaseOperation;
    //
    //    [weakSaveToDataBaseOperation addExecutionBlock:^{
    //        [self updateTableViewCellwithIndexPath:indexpath];
    //    }];
    //
    //    [saveToDataBaseOperation addDependency:downloadOperation];
    //
    //    [[NSOperationQueue mainQueue] addOperation:saveToDataBaseOperation];
    [[NSOperationQueue mainQueue] addOperation:downloadOperation];
}

- (void)requestGetUnreadMessagesfor:(NSString *)friendId
{
    
    NSString * urlString = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/get_unread_msg_count.php",BASEURL];
    NSURL * url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
    [request1 setHTTPMethod:@"POST"];
    [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@",[defaults stringForKey:@"fb_id"],friendId];
    NSLog(@"unread message alert = %@",string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    request1.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request1
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
     {
         
         NSDictionary * unreadMessages = nil;
         
         
         if([data1 length] >= 1) {
             unreadMessages = [NSJSONSerialization JSONObjectWithData:data1 options: 0 error: nil];
             
             if(unreadMessages != nil) {
                 
                 if ([unreadMessages[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                     UITableViewCell *cell = (UITableViewCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                     
                     UIView *view = (UIView *)[cell viewWithTag:10];
                     UILabel *lblCount = (UILabel *)[view viewWithTag:4000];
                     if ([[NSString stringWithFormat:@"%@",unreadMessages[@"unreadmessages_count"]] intValue] > 0) {
                         lblCount.text = [NSString stringWithFormat:@"%@",unreadMessages[@"unreadmessages_count"]];
                         NSLog(@"unread message = %@ for %@",unreadMessages[@"unreadmessages_count"],friendId);
                         lblCount.hidden = NO;
                     }
                     
                 }
                 else
                 {
                     
                 }
                 
             }
         }
         
     }];
}

- (void)updateTextCount:(NSNotification *)notification
{
    UITableViewCell *cell = (UITableViewCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    UIView *view = (UIView *)[cell viewWithTag:10];
    UILabel *lblCount = (UILabel *)[view viewWithTag:4000];
    NSLog(@"Count  = %@",[[[self appDelegate] chatCounts] objectForKey:_selecteduserFriend.frd_fb_Id]);
    NSLog(@"total dict  = %@",[[self appDelegate] chatCounts]);
    NSLog(@"facebook ID   = %@",_selecteduserFriend.frd_fb_Id);
    if ([[[[self appDelegate] chatCounts] objectForKey:_selecteduserFriend.frd_fb_Id] intValue]  > 0) {
        lblCount.text = [[[self appDelegate] chatCounts] objectForKey:_selecteduserFriend.frd_fb_Id];
        lblCount.hidden = NO;
    }
    
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
