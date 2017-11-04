//
//  ProfileTwoViewController.m
//  Twozapp
//
//  Created by Priya on 11/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ProfileTwoViewController.h"
#import "SlideAlertiOS7.h"
#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UserDetails.h"
#import "MyIconDownloader.h"
#import "HelpDesk.h"
#import "SplashViewController.h"
#import "ConnectFacebookViewController.h"
//#import "GKImagePicker.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

@interface ProfileTwoViewController ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, MyIconDownloaderDelegate, UIAlertViewDelegate, UITextFieldDelegate>{
    NSMutableString *strInterest;
    NSMutableDictionary *dictImageDatas;
    NSMutableDictionary *dictImageURLs;
    NSString *blackboxStatus;
    NSMutableDictionary *imageDownloadsInProgress;
    NSString *strTellUs;
    NSString *ProfDist;
    float resety;
    int y;
    float totalHeight;
    IBOutlet UITextField *txtKiloMter;
    IBOutlet UITextView *txtView;
    CGFloat animatedDistance;
}

@property (weak, nonatomic) IBOutlet UITextView *txtViewKeyword;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblTopConstraints;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
//@property (nonatomic, retain) IBOutlet UITextField *txtKiloMter;



@end

@implementation ProfileTwoViewController
{
    MBProgressHUD *hudProgress;
    BOOL updatedImages;
    
}
@synthesize keys;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    txtKiloMter.delegate = self;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    [[self appDelegate].locationManager startUpdatingLocation];
    //self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    dictImageURLs = [[NSMutableDictionary alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewCharDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    strInterest = [[NSMutableString alloc] init];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if ([_actionType isEqualToString:@"edit"]) {
        
        self.navigationController.navigationBar.translucent = NO;
        self.navigationItem.titleView.hidden = NO;
        _btnBack.frame = CGRectMake(_btnBack.frame.origin.x, _btnBack.frame.origin.y, 30, 30);
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
        _tblTopConstraints.constant = 0;
        [self.view needsUpdateConstraints];
        resety = 0;
        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] == nil){
            [self startDownloadImage:[UserDetails sharedInstance].image1 withID:@"1"];
        }
        else
        {
            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] forKey:[NSString stringWithFormat:@"1"]];
            [dictImageURLs setObject:[UserDetails sharedInstance].image1 forKey:@"1"];
            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] forKey:[NSString stringWithFormat:@"1"]];

        }
        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2] == nil){
            [self startDownloadImage:[UserDetails sharedInstance].image2 withID:@"2"];
        }
        else
        {
            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2] forKey:[NSString stringWithFormat:@"2"]];
            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2] forKey:[NSString stringWithFormat:@"2"]];

            [dictImageURLs setObject:[UserDetails sharedInstance].image2 forKey:@"2"];
        }
        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3] == nil){
            [self startDownloadImage:[UserDetails sharedInstance].image3 withID:@"3"];
        }
        else
        {
            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3] forKey:[NSString stringWithFormat:@"3"]];
            [dictImageURLs setObject:[UserDetails sharedInstance].image3 forKey:@"3"];
            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3] forKey:[NSString stringWithFormat:@"3"]];

        }
        
        NSLog(@"Images Array: %@, %@, %@", [UserDetails sharedInstance].image1, [UserDetails sharedInstance].image2, [UserDetails sharedInstance].image3);
        
//        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] != nil ) {
//            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] forKey:[NSString stringWithFormat:@"1"]];
//            [dictImageURLs setObject:[UserDetails sharedInstance].image1 forKey:@"1"];
//        }
//        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2] != nil) {
//            [dictImageURLs setObject:[UserDetails sharedInstance].image2 forKey:@"2"];
//        }
//        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3] != nil) {
//            [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3] forKey:[NSString stringWithFormat:@"3"]];
//            [dictImageURLs setObject:[UserDetails sharedInstance].image3 forKey:@"3"];
//        }
//        
 //       }
        strTellUs = [UserDetails sharedInstance].descriptions;
        keys = [[NSMutableArray alloc] initWithArray:[UserDetails sharedInstance].keywords];
        ProfDist = [UserDetails sharedInstance].profileDistance;
        
        NSLog(@"Prof Distance: %@", [UserDetails sharedInstance].profileDistance);
//        for (NSString *key in [UserDetails sharedInstance].keywords) {
//            if (key.length > 0) {
//                [keys addObject:key];
//            }
//            
//        }
        
        UITableViewCell *cell = (UITableViewCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        UICollectionView *cllctnView = (UICollectionView *)[cell viewWithTag:20];
        [cllctnView reloadData];
        [self performSelector:@selector(reloadConstraints) withObject:nil afterDelay:0.25];
    }
    else
    {
//        self.navigationItem.titleView.hidden = YES;
//        _btnBack.frame = CGRectMake(_btnBack.frame.origin.x, _btnBack.frame.origin.y, 102, 24);
//        [_btnBack setBackgroundImage:[UIImage imageNamed:@"twozapp"] forState:UIControlStateNormal];
        
        self.automaticallyAdjustsScrollViewInsets = NO;

        self.navigationItem.titleView.hidden = NO;
        _btnBack.frame = CGRectMake(_btnBack.frame.origin.x, _btnBack.frame.origin.y, 30, 30);
        [_btnBack setBackgroundImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
        //self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"twozapp"];
        resety = 64;
        _tblTopConstraints.constant = 0;
        [self.view needsUpdateConstraints];
        keys = [[NSMutableArray alloc] init];
    }
    
    

    
//
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"twozapp"]] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack:)];
//    
//    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self appDelegate].locationManager stopUpdatingLocation];
}

- (IBAction)actionBack:(id)sender {
    
    //if ([_actionType isEqualToString:@"edit"]) {
        [self.navigationController popViewControllerAnimated:YES];
    //}
    
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
    lblTitle.text = [keys objectAtIndex:indexPath.item];
    
    
   // [strInterest appendString:[keys objectAtIndex:indexPath.item]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = keys[indexPath.item];
    UIFont *myFont = [UIFont systemFontOfSize:14.0];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:key
                                    attributes:@{NSFontAttributeName: myFont}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){collectionView.frame.size.width,CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
   
    if (rect.size.width <= collectionView.frame.size.width - 30) {
        return CGSizeMake(rect.size.width + 30, 30);
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width, 30);
    }
    
}


- (IBAction)actionSave:(id)sender {
    
    if ([[OnDeck sharedInstance].dictImages count] == 0) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please upload at least 1 picture"];
    }
    else if (keys.count < 3)
    {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please add at least 3 keywords about yourself"];
    }
    else
    {
        
        if ([_actionType isEqualToString:@"edit"]) {
            
            if (updatedImages) {
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
                    [self uploadImages:[OnDeck sharedInstance].dictImages];
                }
  
            }
            else
            {
                [self actionUpdateProfile];
                [self updateKeywords];
            }
        }
        else
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
            [self uploadImages:[OnDeck sharedInstance].dictImages];
        }
        }
    }
}

- (void)actionRegister
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ProfDist = txtKiloMter.text;
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/register_webservice.php",BASEURL];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *birthDate = [formatter dateFromString:[OnDeck sharedInstance].strBirthday];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"firstname=%@&email=%@&gender=%@&description=%@&lat=%f&lang=%f&fb_id=%@&dob=%@&height=%@&weight=%@&profile_image=%@&imageurl2=%@&imageurl3=%@&device_token=%@&keyword1=%@&keyword2=%@&keyword3=%@&looking_for=%@&profile_distance=%@&device_type=%@",[OnDeck sharedInstance].strName, [OnDeck sharedInstance].strEmail, [OnDeck sharedInstance].strGender, strTellUs, [self appDelegate].location.coordinate.latitude, [self appDelegate].location.coordinate.longitude, [defaults stringForKey:@"fb_id"],[newFormatter stringFromDate:birthDate],[OnDeck sharedInstance].strHeight,[OnDeck sharedInstance].strWeight,[dictImageURLs objectForKey:@"1"],![dictImageURLs objectForKey:@"2"] ? @"" : [dictImageURLs objectForKey:@"2"],![dictImageURLs objectForKey:@"3"] ? @"" : [dictImageURLs objectForKey:@"3"],[self appDelegate].deviceToken,keys[0],keys[1],keys[2], [OnDeck sharedInstance].strLookingfor, ProfDist, @"2"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    NSLog(@"Request Full String: %@", string);
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                                                     if(error) {
                                                         NSLog(@"error : %@", [error description]);
                                                     } else {
                                                         // This is the expected result
                                                         NSLog(@"result : %@", result);
                                                         if (result.count >0) {
                                                             
                                                             if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                                 
                                                                 [defaults setObject:[OnDeck sharedInstance].strEmail forKey:@"email"];
                                                                 
                                                                 
                                                                     UserDetails *userDetails = [UserDetails sharedInstance];
                                                                     userDetails.dob = result[@"dob"];
                                                                     
                                                                    userDetails.height = result[@"height"];
                                                                     
                                                                     userDetails.email = result[@"email"];
                                                                     userDetails.fb_id = result[@"facebookid"];
                                                                     
                                                                     userDetails.gender = result[@"gender"];
                                                                     userDetails.latitude = result[@"latitude"];
                                                                     userDetails.logitude = result[@"longitude"];
                                                                 userDetails.descriptions = result[@"description"];
                                                                 
                                                                 userDetails.full_name = [OnDeck sharedInstance].strName;
                                                                 NSMutableArray *arrKeywords = [[NSMutableArray alloc] init];
                                                                 NSArray *keywords = result[@"keywords"];
                                                                 for (NSDictionary *dict in keywords) {
                                                                     [arrKeywords addObject:dict[@"keyword"]];
                                                                 }
                                                                 userDetails.keywords = arrKeywords;
                                                                     userDetails.weight = result[@"weight"];
                                                                     
                                                                     userDetails.status = result[@"status"];
                                                                     userDetails.datingid = result[@"datingid"];
                                                                     userDetails.devicetoken = result[@"devicetoken"];
                                                                 userDetails.image1 = result[@"imageurl1"];
                                                                 userDetails.image2 = result[@"imageurl2"];
                                                                 userDetails.image3 = result[@"imageurl3"];
                                                                 //userDetails.full_name = result[@"fullname"];
                                                                 userDetails.profilepicture = result[@"imageurl1"];

                                                                  [self startDownloadImage:userDetails];
                                                                 
                                                                     
                                                                                                                            }
                                                         }
                                                         
                                                     }
        
                                                     [self hudWasHidden:hudProgress];
                                                 }];
}

- (void)actionUpdateProfile
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ProfDist = txtKiloMter.text;
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/edit_profile.php",BASEURL];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *birthDate = [formatter dateFromString:[OnDeck sharedInstance].strBirthday];
    
    NSString *strBirthTime = [self getBirthTime:[OnDeck sharedInstance].strBirthtime];
    if (strBirthTime == nil) {
        strBirthTime = @"00:01:00";
    }
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"firstname=%@&email=%@&gender=%@&description=%@&lat=%f&lng=%f&fb_id=%@&dob=%@&height=%@&weight=%@&profile_img=%@&imageurl2=%@&imageurl3=%@&device_token=%@&keyword1=%@&keyword2=%@&keyword3=%@&lookingfor=%@&profile_distance=%@",[OnDeck sharedInstance].strName, [OnDeck sharedInstance].strEmail, [OnDeck sharedInstance].strGender, strTellUs, [self appDelegate].location.coordinate.latitude, [self appDelegate].location.coordinate.longitude, [defaults stringForKey:@"fb_id"],[newFormatter stringFromDate:birthDate],[OnDeck sharedInstance].strHeight,[OnDeck sharedInstance].strWeight,[dictImageURLs objectForKey:@"1"],[dictImageURLs objectForKey:@"2"],[dictImageURLs objectForKey:@"3"],[self appDelegate].deviceToken,keys[0],keys[1],keys[2], [OnDeck sharedInstance].strLookingfor, ProfDist];
    
    NSLog(@"Updated parameters: %@", string);
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"result : %@", result);
            if (result.count >0) {
                
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    
                    [defaults setObject:[OnDeck sharedInstance].strEmail forKey:@"email"];
                    
                    
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
                    userDetails.lookingfor = [OnDeck sharedInstance].strLookingfor;
                    userDetails.status = result[@"status"];
                    userDetails.datingid = result[@"datingid"];
                    userDetails.devicetoken = result[@"devicetoken"];
                    userDetails.image1 = result[@"imageurl1"];
                    userDetails.image2 = result[@"imageurl2"];
                    userDetails.image3 = result[@"imageurl3"];
                    userDetails.full_name = result[@"fullname"];
                    userDetails.profilepicture = result[@"imageurl1"];
                    if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] == nil) {
                        [self startDownloadImage:userDetails];
                    }
                    
                    else
                    {
                        if ([_actionType isEqualToString:@"edit"]) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                        else
                        {
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                            UIViewController *profileTwo = [story instantiateViewControllerWithIdentifier:@"revealCont"];
                            [self presentViewController:profileTwo animated:YES completion:nil];
                        }
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                }
            }
            
        }
        
        [self hudWasHidden:hudProgress];
    }];
}

- (void)updateKeywords
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/update_keyword.php",BASEURL];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *birthDate = [formatter dateFromString:[OnDeck sharedInstance].strBirthday];
    
    NSString *strBirthTime = [self getBirthTime:[OnDeck sharedInstance].strBirthtime];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"fb_id=%@&keyword1=%@&keyword2=%@&keyword3=%@",[defaults stringForKey:@"fb_id"],keys[0],keys[1],keys[2]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
        }
    }];

}

- (NSString *)getBirthTime:(NSString *)displayTime
{
    NSArray *arr = [displayTime componentsSeparatedByString:@" - "];
    NSDateFormatter *timeformat = [[NSDateFormatter alloc] init];
    [timeformat setDateFormat:@"hh:mma"];
    
    NSDate *date =[timeformat dateFromString:arr[0]];
    
    NSLog(@"two date = %@",date);
    
    NSDateFormatter *newTimeFormat = [[NSDateFormatter alloc] init];
    [newTimeFormat setDateFormat:@"HH:mm:ss"];
    
    NSString *newString = [newTimeFormat stringFromDate:date];
    
    return newString;
    
}

- (IBAction)actionAddPhoto1:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Photo Library", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    
}

- (IBAction)actionPhoto3:(id)sender {
    
 
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Photo Library", nil];
    actionSheet.tag = 3;
    [actionSheet showInView:self.view];
    
}
- (IBAction)actionAddPhoto2:(id)sender {
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Photo Library", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Action sheet called!!");
    NSLog(@"Button Tag: %ld", (long)actionSheet.tag);

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.view.tag = actionSheet.tag;
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
        
    }else if (buttonIndex == 1){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
    }
    
    /*if (buttonIndex == 0) {
        NSLog(@"Camera Called");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.view.tag = actionSheet.tag;

        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
        
        
    }else if (buttonIndex == 1){
        NSLog(@"Albums Called");
        self.imagePicker = [[GKImagePicker alloc] init];
        self.imagePicker.cropSize = CGSizeMake(375, 237);
        self.imagePicker.imagePickerController.view.tag = actionSheet.tag;
        self.imagePicker.delegate = self;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
        }];
    }*/
    
}

/*
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{

    updatedImages = YES;
    if (imagePicker.imagePickerController.view.tag == 1) {
        UIImage *chosenImage = image;
        _imgView1.image = chosenImage;
        [[OnDeck sharedInstance].dictImages setObject:chosenImage forKey:[NSString stringWithFormat:@"1"]];
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        _addImage1.hidden = YES;
        _btnClose1.hidden = NO;
        _lbl1.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
    }
    else if (imagePicker.imagePickerController.view.tag == 2)
    {
        UIImage *chosenImage = image;
        _imgView2.image = chosenImage;
        [[OnDeck sharedInstance].dictImages setObject:chosenImage forKey:[NSString stringWithFormat:@"2"]];
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        _addImage2.hidden = YES;
        _btnClose2.hidden = NO;
        _lbl2.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
    }
    else if (imagePicker.imagePickerController.view.tag == 3)
    {
        UIImage *chosenImage = image;
        _imgView3.image = chosenImage;
        [[OnDeck sharedInstance].dictImages setObject:chosenImage forKey:[NSString stringWithFormat:@"3"]];
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        _addImagee3.hidden = YES;
        _btnClose3.hidden = NO;
        _lbl3.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
    }
    [_tblView reloadData];

}*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    updatedImages = YES;
    if (picker.view.tag == 1) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        _imgView1.image = chosenImage;
        [[OnDeck sharedInstance].dictImages setObject:chosenImage forKey:[NSString stringWithFormat:@"1"]];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        _addImage1.hidden = YES;
        _btnClose1.hidden = NO;
        _lbl1.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
    }
    else if (picker.view.tag == 2)
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        _imgView2.image = chosenImage;
        [[OnDeck sharedInstance].dictImages setObject:chosenImage forKey:[NSString stringWithFormat:@"2"]];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        _addImage2.hidden = YES;
        _btnClose2.hidden = NO;
        _lbl2.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
    }
    else if (picker.view.tag == 3)
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        _imgView3.image = chosenImage;
        [[OnDeck sharedInstance].dictImages setObject:chosenImage forKey:[NSString stringWithFormat:@"3"]];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        _addImagee3.hidden = YES;
        _btnClose3.hidden = NO;
        _lbl3.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
    }
    
    [_tblView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)actionTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         _tblTopConstraints.constant = resety;
         [self.view needsUpdateConstraints];
         //[self.view setFrame:CGRectMake(0,resety,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         // Assign new frame to your view
         
         [self.view setFrame:CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
     } completion:nil];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         _tblTopConstraints.constant = resety;
         [self.view needsUpdateConstraints];

         //[self.view setFrame:CGRectMake(0,resety,self.view.frame.size.width,self.view.frame.size.height)];
         [self.view endEditing:YES];
     } completion:nil];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{

    
    if (textView.tag == 50 && [txtView.text isEqualToString:@"Please enter keywords about you"]) {
        
        txtView.text = @"";
        txtView.textColor = [UIColor colorWithRed:63/255.0 green:57/255.0 blue:58/255.0 alpha:1.0f]; //optional

        
        [UIView animateWithDuration:0.25
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             // Assign new frame to your view
             CGRect rectOfCellInTableView = [_tblView rectForRowAtIndexPath: [NSIndexPath indexPathForRow:1 inSection:0]];

_tblTopConstraints.constant = -rectOfCellInTableView.origin.y;
             [self.view needsUpdateConstraints];
             //[self.view setFrame:CGRectMake(0,-(rectOfCellInTableView.origin.y) - resety,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
         } completion:nil];
        //[txtView becomeFirstResponder];
    }
    else
    {
        [UIView animateWithDuration:0.25
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             CGRect rectOfCellInTableView = [_tblView rectForRowAtIndexPath: [NSIndexPath indexPathForRow:2 inSection:0]];
//             // Assign new frame to your view
//             [self.view setFrame:CGRectMake(0,-(rectOfCellInTableView.origin.y + 46 ) + resety,self.view.frame.size.width,self.view.frame.size.height)];
//             [_tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
//                                  atScrollPosition:UITableViewScrollPositionMiddle
             //                                          animated:YES];\\CGPoint tableViewCenter = [tableView contentOffset];
             
             _tblTopConstraints.constant = -(rectOfCellInTableView.origin.y);
             [self.view needsUpdateConstraints];
             //[_tblView setContentOffset:CGPointMake(0,(rectOfCellInTableView.origin.y + 46 )) animated:YES];
             //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
         } completion:nil];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([txtView.text isEqualToString:@""]) {
        txtView.text = @"Please enter keywords about you";
        txtView.textColor = [UIColor colorWithRed:238/255.0 green:199/255.0 blue:206/255.0 alpha:1.0f]; //optional
    }
    [txtView resignFirstResponder];
}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag == 10) {
        
        NSArray *constraints = [textView constraints];
        int index = 0;
        BOOL found = NO;
        //strTellUs = textView.text;
        while (!found && index < [constraints count]) {
            NSLayoutConstraint *constraint = constraints[index];
            if ( [constraint.identifier isEqualToString:@"txtview"] ) {
                //save the reference to constraint
                found = YES;
                if (textView.contentSize.height > 70 && textView.contentSize.height < 150) {
                    [_tblView beginUpdates];
                    constraint.constant = textView.contentSize.height;
                    [self.view updateConstraints];
                    [_tblView endUpdates];
                }
            }
            index ++;
        }
        
        return YES;
    }
    else
    {
    if (keys.count != 3) {
        
        //NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        //NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        // Prevent crashing undo bug – see note below.
        if(textView.text.length >= 20 && ![text isEqualToString:@""] && ![text isEqualToString:@"\n"])
        {
            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"The Keyword should have a maximum of 20 charecters"];
            return NO;
        }
        if([text isEqualToString:@"\n"] || [text isEqualToString:@" "] || [text isEqualToString:@","]) {
            if (textView.text.length < 1){
                [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Please insert valid keyword"];
                return NO;

            }else {
                [keys addObject:textView.text];
                textView.text = @"";
                [_tblView reloadData];
                //[_tblView reloadData];
                
                [self performSelector:@selector(reloadConstraints) withObject:nil afterDelay:0.25];
                return NO;
                
            }
        }
        
        return YES;
    }
    else
        return NO;
    }
}


- (IBAction)actionDelete:(id)sender
{
    UIButton *btn = (UIButton *)sender;
//    UICollectionViewCell *cell = (UICollectionViewCell *)btn.superview.superview;
//    UICollectionView *cllctnView = (UICollectionView *)cell.superview;
//    NSIndexPath *indexPath = [cllctnView indexPathForCell:cell];
    [keys removeObjectAtIndex:btn.tag];
    [_tblView reloadData];
    
    [self performSelector:@selector(reloadConstraints) withObject:nil afterDelay:0.25];
}

- (void)reloadConstraints
{
    UITableViewCell *tblcell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UIView *cllctionView = (UIView *)[tblcell viewWithTag:500];
    NSArray *colconstraints = [cllctionView constraints];
    int colindex = 0;
    BOOL colfound = NO;
    
    while (!colfound && colindex < [colconstraints count]) {
        NSLayoutConstraint *constraint = colconstraints[colindex];
        if ( [constraint.identifier isEqualToString:@"cllctionView"] ) {
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

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (void)uploadImages:(NSDictionary *)imageDatas
{
    
    /*NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/dating_new_webservices/blackbox.php",BASEURL];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *birthDate = [formatter dateFromString:[OnDeck sharedInstance].strBirthday];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [NSString stringWithFormat:@"blackboxdate=%@",[newFormatter stringFromDate:birthDate]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];

     [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                                                     if(error) {
                                                         NSLog(@"error : %@", [error description]);
                                                         [self hudWasHidden:hudProgress];
                                                     } else {
                                                         // This is the expected result
                                                         NSLog(@"Blackbox result2 : %@", result);
                                                         
                                                         if (result.count >0) {
                                                             blackboxStatus = result[@"status"]; */
                                                             for (NSString *key in imageDatas) {
                                                                 UIImage *image = [imageDatas objectForKey:key];
                                                                 NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                                                                 NSURLRequest *request = [self uploadImage:imageData];
                                                                 //request.accessibilityValue = key;
                                                                 
                                                                 NSURLResponse *response;
                                                                 NSError *error;
                                                                 NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                                                                 if (responseData.length > 0) {
                                                                     
                                                                 
                                                                                                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                                                                                     options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                                                                                                                                       error:&error];
                                                                                                NSLog(@"the image response = %@",response);
                                                                                                [dictImageURLs setObject:responseDict[@"image"] forKey:key];
                                                                     
                                                                     [[HelpDesk sharedInstance] saveImageToCache:image withName:responseDict[@"image"]];
                                                                     
                                                                                                if (dictImageURLs.count == imageDatas.count) {
                                                                                                    
                                                                                   if ([_actionType isEqualToString:@"edit"]) {
                                                                                       [self actionUpdateProfile];
                                                                                       [self updateKeywords];
                                                                                   }
                                                                                                        else
                                                                                                        {[self actionRegister];}
                                                                                                   
                                                                                                }
                                                                 }
                                                                                                                                                        }
    
                                                             
                                                             
                                                        /* }
                                                         else
                                                         {
                                                             [self hudWasHidden:hudProgress];
                                                         }
                                                     }
                                                 }]; */
    
   }

/*
- (void)requestAddInterest{
    
    
    for (NSString *str in keys) {
        [strInterest appendString:str];
    }
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://infowebtechsolutions.com/demo/twzapp/add_interest.php?user_id=%@&interest_list=%@",[UserDetails sharedInstance].user_id,strInterest];
    NSString *finalURLPath = [urlPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [[NetworkManager sharedManager] getvalueFromServerForGetterURL:finalURLPath
                                                 completionHandler:^(NSError *error, NSDictionary *result) {
                                                     if(error) {
                                                         NSLog(@"error : %@", [error description]);
                                                     } else {
                                                         // This is the expected result
                                                         NSLog(@"result : %@", result);
                                                         if (result.count >0) {
                                                             
                                                            
                                                             
                                                             
                                                 }
                                                     }
                                                 }];

}
*/

- (NSMutableURLRequest *)uploadImage:(NSData *)imageData
{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    // [_params setObject:[UserDetails sharedInstance].user_id forKey:@"profile_id"];
    //[_params setObject:@"filename" forKey:@"profile_picture1"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"fileToUpload";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/tinzapp_webservices/upload_profile_image.php",BASEURL]];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    return request;
}
- (IBAction)actionDeleteFirstImage:(id)sender {
    
    [[OnDeck sharedInstance].dictImages removeObjectForKey:@"1"];
    _imgView1.image = [UIImage imageNamed:@""];
    if ([[OnDeck sharedInstance].dictImages count] == 2) {
        [[OnDeck sharedInstance].dictImages setObject:[[OnDeck sharedInstance].dictImages objectForKey:@"2"] forKey:@"1"];
        [dictImageURLs setObject:[dictImageURLs objectForKey:@"2"] forKey:@"1"];
        _imgView1.image = [[OnDeck sharedInstance].dictImages objectForKey:@"1"];
        [[OnDeck sharedInstance].dictImages setObject:[[OnDeck sharedInstance].dictImages objectForKey:@"3"] forKey:@"2"];
        [dictImageURLs setObject:[dictImageURLs objectForKey:@"3"] forKey:@"2"];
        [[OnDeck sharedInstance].dictImages removeObjectForKey:@"3"];
        [dictImageURLs removeObjectForKey:@"3"];
        
        _imgView2.image = [[OnDeck sharedInstance].dictImages objectForKey:@"2"];
        _imgView3.image = [UIImage imageNamed:@""];

    }
    else if ([[OnDeck sharedInstance].dictImages count] == 1)
    {
        if ([[OnDeck sharedInstance].dictImages objectForKey:@"2"]) {
            [[OnDeck sharedInstance].dictImages setObject:[[OnDeck sharedInstance].dictImages objectForKey:@"2"] forKey:@"1"];
            [dictImageURLs setObject:[dictImageURLs objectForKey:@"2"] forKey:@"1"];
            [[OnDeck sharedInstance].dictImages removeObjectForKey:@"2"];
            [dictImageURLs removeObjectForKey:@"2"];
            
        }
        else if ([[OnDeck sharedInstance].dictImages objectForKey:@"3"])
        {
            [[OnDeck sharedInstance].dictImages setObject:[[OnDeck sharedInstance].dictImages objectForKey:@"3"] forKey:@"1"];
            [dictImageURLs setObject:[dictImageURLs objectForKey:@"3"] forKey:@"1"];
            [[OnDeck sharedInstance].dictImages removeObjectForKey:@"3"];
            [dictImageURLs removeObjectForKey:@"3"];
        }
        _imgView1.image = [[OnDeck sharedInstance].dictImages objectForKey:@"1"];
        _imgView2.image = [UIImage imageNamed:@""];
        _imgView3.image = [UIImage imageNamed:@""];
    }
    
    _addImage1.hidden =  NO;
    _btnClose1.hidden =  YES;
    
    _lbl1.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:164.0/255.0 blue:172.0/255.0 alpha:1.0];
    [_tblView reloadData];
    
}

- (IBAction)actionDeleteSecond:(id)sender {
    
    [[OnDeck sharedInstance].dictImages removeObjectForKey:@"2"];
    _imgView2.image = [UIImage imageNamed:@""];
    if ([[OnDeck sharedInstance].dictImages count] == 2)
    {
            [[OnDeck sharedInstance].dictImages setObject:[[OnDeck sharedInstance].dictImages objectForKey:@"3"] forKey:@"2"];
        [dictImageURLs setObject:[dictImageURLs objectForKey:@"3"] forKey:@"2"];
        [[OnDeck sharedInstance].dictImages removeObjectForKey:@"3"];
        [dictImageURLs removeObjectForKey:@"3"];
        _imgView2.image = [[OnDeck sharedInstance].dictImages objectForKey:@"2"];
        _imgView3.image = [UIImage imageNamed:@""];
        
    }
    else
    {
    [dictImageURLs removeObjectForKey:@"2"];
    }
    _addImage2.hidden =  NO;
    _btnClose2.hidden =  YES;
    _lbl2.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:164.0/255.0 blue:172.0/255.0 alpha:1.0];
    [_tblView reloadData];
}

- (IBAction)actionDeleteThird:(id)sender {
    
    [[OnDeck sharedInstance].dictImages removeObjectForKey:@"3"];
    [dictImageURLs removeObjectForKey:@"3"];
    _imgView3.image = [UIImage imageNamed:@""];
    
    _addImagee3.hidden =  NO;
    _btnClose3.hidden =  YES;
    _lbl3.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:164.0/255.0 blue:172.0/255.0 alpha:1.0];
    [_tblView reloadData];
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
    if ([_actionType isEqualToString:@"edit"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *profileTwo = [story instantiateViewControllerWithIdentifier:@"revealCont"];
    [self presentViewController:profileTwo animated:YES completion:nil];
    }
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
    if ([url isEqualToString:@"1"]) {
        _imgView1.image = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1];
        [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image1] forKey:[NSString stringWithFormat:@"1"]];
    }
    if ([url isEqualToString:@"2"]) {
        _imgView2.image = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2];
        [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image2] forKey:[NSString stringWithFormat:@"2"]];
    }
    if ([url isEqualToString:@"3"]) {
        _imgView3.image = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3];
        [[OnDeck sharedInstance].dictImages setObject:[[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].image3] forKey:[NSString stringWithFormat:@"3"]];
    }
    
    if (imageDownloadsInProgress.count == 0) {
        [self hudWasHidden:hudProgress];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
if ([_actionType isEqualToString:@"edit"]) {
    return 7;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"imagepic" forIndexPath:indexPath];
        
        UIView *view1 = (UIView *)[cell viewWithTag:100];
        UIView *view2 = (UIView *)[cell viewWithTag:200];
        UIView *view3 = (UIView *)[cell viewWithTag:300];
        
        UIImageView *imgView1 = (UIImageView *)[view1 viewWithTag:10];
        UIImageView *imgView2 = (UIImageView *)[view2 viewWithTag:10];
        UIImageView *imgView3 = (UIImageView *)[view3 viewWithTag:10];
        
        imgView1.image = [[OnDeck sharedInstance].dictImages objectForKey:@"1"];
        imgView2.image = [[OnDeck sharedInstance].dictImages objectForKey:@"2"];
        imgView3.image = [[OnDeck sharedInstance].dictImages objectForKey:@"3"];
        
        imgView1.layer.cornerRadius = 5.0f;
        [imgView1.layer setMasksToBounds:YES];
        
        imgView2.layer.cornerRadius = 5.0f;
        [imgView2.layer setMasksToBounds:YES];
        
        imgView3.layer.cornerRadius = 5.0f;
        [imgView3.layer setMasksToBounds:YES];
        
        UIButton *btnAdd1 = (UIButton *)[view1 viewWithTag:20];
        UIButton *btnAdd2 = (UIButton *)[view2 viewWithTag:20];
        UIButton *btnAdd3 = (UIButton *)[view3 viewWithTag:20];
        
        [btnAdd1 addTarget:self action:@selector(actionAddPhoto1:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd2 addTarget:self action:@selector(actionAddPhoto2:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd3 addTarget:self action:@selector(actionPhoto3:) forControlEvents:UIControlEventTouchUpInside];
        btnAdd1.enabled = YES;
        btnAdd2.enabled = YES;
        btnAdd3.enabled = YES;
        if (![[OnDeck sharedInstance].dictImages objectForKey:@"1"]) {
            btnAdd2.enabled = NO;
            btnAdd3.enabled = NO;
        }
        else if (![[OnDeck sharedInstance].dictImages objectForKey:@"2"] && [[OnDeck sharedInstance].dictImages objectForKey:@"1"]) {
            btnAdd3.enabled = NO;
            btnAdd2.enabled = YES;
        }
        else if (![[OnDeck sharedInstance].dictImages objectForKey:@"3"] && [[OnDeck sharedInstance].dictImages objectForKey:@"2"]) {
            btnAdd3.enabled = YES;
        }
        
        UIButton *btnDelete1 = (UIButton *)[view1 viewWithTag:30];
        UIButton *btnDelete2 = (UIButton *)[view2 viewWithTag:30];
        UIButton *btnDelete3 = (UIButton *)[view3 viewWithTag:30];
        
        [btnDelete1 addTarget:self action:@selector(actionDeleteFirstImage:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete2 addTarget:self action:@selector(actionDeleteSecond:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete3 addTarget:self action:@selector(actionDeleteThird:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([[OnDeck sharedInstance].dictImages objectForKey:@"1"]) {
            btnDelete1.hidden = NO;
            btnAdd1.hidden = YES;
        }
        else
        {
            btnDelete1.hidden = YES;
            btnAdd1.hidden = NO;
        }
        if ([[OnDeck sharedInstance].dictImages objectForKey:@"2"]) {
            btnDelete2.hidden = NO;
            btnAdd2.hidden = YES;
        }
        else
        {
            btnDelete2.hidden = YES;
            btnAdd2.hidden = NO;
        }
        if ([[OnDeck sharedInstance].dictImages objectForKey:@"3"]) {
            btnDelete3.hidden = NO;
            btnAdd3.hidden = YES;
        }
        else
        {
            btnDelete3.hidden = YES;
            btnAdd3.hidden = NO;
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"txtKeyword" forIndexPath:indexPath];
        
        txtView = (UITextView *)[cell viewWithTag:50];
        txtView.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
        txtView.layer.borderWidth = 1.0f;
        txtView.layer.cornerRadius = 5.0f;
        [txtView.layer setMasksToBounds:YES];
        txtView.textColor = [UIColor colorWithRed:238/255.0 green:199/255.0 blue:206/255.0 alpha:1.0f];
        txtView.text = @"Please enter keywords about you";
        
        return cell;
        
    }
    else if(indexPath.row == 2)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"keyword" forIndexPath:indexPath];
        
        UIView *cllctnView = (UIView *)[cell viewWithTag:500];
        
        if (keys.count == 0) {
            NSArray *constraints = [cllctnView constraints];
            int index = 0;
            BOOL found = NO;
            
            while (!found && index < [constraints count]) {
                NSLayoutConstraint *constraint = constraints[index];
                if ( [constraint.identifier isEqualToString:@"cllctionView"] ) {
                    //save the reference to constraint
                    found = YES;
                    [_tblView beginUpdates];
                    constraint.constant = 0;
                    [self.view updateConstraints];
                    [_tblView endUpdates];
                }
                index ++;
            }
            
        }
        else
        {
            
            for (UIView *vw in cllctnView.subviews) {
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
                totalWidth = x + rect.size.width + 30;
                if (totalWidth > tableView.frame.size.width - 30) {
                    x = 0;
                    totalWidth = x + rect.size.width + 30;
                    y = y + rect.size.height + 20;
                    totalHeight = y + rect.size.height + 20;
                    
                }
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, rect.size.width + 30, rect.size.height + 10)];
                view.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:144.0/255.0 blue:206.0/255.0 alpha:1.0];
                view.layer.cornerRadius = 5.0f;
                view.layer.masksToBounds = YES;
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, rect.size.width + 5, rect.size.height + 5)];
                lbl.font = [UIFont systemFontOfSize:13];
                lbl.textColor = [UIColor whiteColor];
                lbl.text = key;
                [view addSubview:lbl];
                
                
                UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnDelete setImage:[UIImage imageNamed:@"closebutton"] forState:UIControlStateNormal];
                btnDelete.frame = CGRectMake(rect.size.width + 5, 5, 25, 25);
                btnDelete.tag = i;
                [btnDelete.layer setMasksToBounds:YES];
                [btnDelete addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btnDelete];
                [cllctnView addSubview:view];
                
                x = totalWidth + 10;
            }
       }
         return cell;
        
    }
    else if (indexPath.row == 3)
    {
         UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"txtview" forIndexPath:indexPath];
        
        UIView *view = [cell viewWithTag:100];
        UITextView *txtView1 = (UITextView *)[view viewWithTag:10];
        if ([strTellUs isEqualToString:@"(null)"]) {
            txtView1.text = @"";
        }
        else
        {
            txtView1.text = strTellUs;
        }
        
        txtView1.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
        txtView1.layer.borderWidth = 1.0f;
        txtView1.layer.cornerRadius = 5.0f;
        [txtView1.layer setMasksToBounds:YES];
        
        return cell;
    }
 
    else if (indexPath.row == 4)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"note" forIndexPath:indexPath];
        
        UIView *viewk = [cell viewWithTag:22];
        txtKiloMter = (UITextField *)[viewk viewWithTag:23];
        txtKiloMter.delegate = self;
        
        UIColor *color = [UIColor colorWithRed:238/255.0 green:199/255.0 blue:206/255.0 alpha:1.0f];
        txtKiloMter.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Kilometer" attributes:@{NSForegroundColorAttributeName: color}];
        

        
        if ([ProfDist isEqualToString:@"(null)"]) {
            txtKiloMter.text = @"";
        }
        else
        {
            txtKiloMter.text = ProfDist;
        }
        
        NSLog(@"Prof Dist: %@", ProfDist);
        
        txtKiloMter.layer.borderColor = [UIColor colorWithRed:243/255.0 green:119.0/255.0 blue:142/255.0 alpha:1.0f].CGColor;
        txtKiloMter.layer.borderWidth = 1.0f;
        txtKiloMter.layer.cornerRadius = 5.0f;
        txtKiloMter.tintColor = [UIColor blackColor];
        [txtKiloMter.layer setMasksToBounds:YES];
        
        return cell;
        
    }
    else if (indexPath.row == 5)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"savebutton" forIndexPath:indexPath];
        UIButton *saveButton = (UIButton *)[cell viewWithTag:30];
        saveButton.layer.cornerRadius = 10.0f;
        
        return cell;
    }
    else if(indexPath.row == 6)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"deleteprofile" forIndexPath:indexPath];
        
        UIButton *btnDelete = (UIButton *)[cell viewWithTag:10];
        btnDelete.layer.cornerRadius = 10.0f;
        
        
        return cell;
        
    } /*else if (indexPath.row == 7){
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"roughImg" forIndexPath:indexPath];
        
         UIImageView *imgViewr = (UIImageView *)[cell viewWithTag:10];
        imgViewr.layer.cornerRadius = 5.0f;
        
        
        return cell;

    } */
    else
    {
        return nil;
    }
}

- (IBAction)actionDeleteProfile:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else
        {
            
            
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to Delete your Profile" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
//            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Your account has been deleted."];
//            NSLog(@"parent = %@ and parent's parent = %@",[(UINavigationController *)[self parentViewController] viewControllers], self.parentViewController.presentingViewController);
//            if ([[self.parentViewController.presentingViewController class] isEqual:[SplashViewController class]]) {
//                SplashViewController *splash = (SplashViewController *)self.parentViewController.presentingViewController;
//                
//                
//                [self.parentViewController dismissViewControllerAnimated:NO completion:^{
//                    
//                    UIViewController *connect = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectFacebookViewController"];
//                    [splash presentViewController:connect animated:NO completion:nil];
//                }];
//            }
//            else if ([[self.parentViewController.presentingViewController class] isEqual:[ConnectFacebookViewController class]])
//            {
//                // UINavigationController *splash = (UINavigationController *)self.parentViewController;
//               
//                [self.parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            }
//            else
//            {
//                
//                UINavigationController *splash = (UINavigationController *)self.parentViewController.presentingViewController;
//                [self.navigationController dismissViewControllerAnimated:NO completion:^{
//                    
//                    [splash dismissViewControllerAnimated:YES completion:nil];
//                }];
//            }
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteProfile];
    }
}

- (void)deleteProfile
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
        NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/deleteuserdata.php",BASEURL];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *string = [NSString stringWithFormat:@"from_fb_id=%@",[defaults stringForKey:@"fb_id"]];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
            
            if(error) {
                NSLog(@"error : %@", [error description]);
            } else {
                // This is the expected result
                NSLog(@"report result : %@", result);
                if (result.count >0) {
                    if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Your account has been deleted."];
                        NSLog(@"parent = %@ and parent's parent = %@",[(UINavigationController *)[self parentViewController] viewControllers], self.parentViewController.presentingViewController);
                        [[OnDeck sharedInstance] clearOnDeck];
                        if ([[self.parentViewController.presentingViewController class] isEqual:[SplashViewController class]]) {
                            SplashViewController *splash = (SplashViewController *)self.parentViewController.presentingViewController;
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:@"" forKey:@"email"];
                            [defaults setObject:@"" forKey:@"fb_id"];
                            [defaults synchronize];
                            [[UserDetails sharedInstance] clearUserDetails];
                            
                            [self.parentViewController dismissViewControllerAnimated:NO completion:^{
                                
                                UIViewController *connect = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectFacebookViewController"];
                                [splash presentViewController:connect animated:NO completion:nil];
                            }];
                        }
                        else if ([[self.parentViewController.presentingViewController class] isEqual:[ConnectFacebookViewController class]])
                        {
                            // UINavigationController *splash = (UINavigationController *)self.parentViewController;
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:@"" forKey:@"email"];
                            [defaults setObject:@"" forKey:@"fb_id"];
                            [defaults synchronize];
                            [[UserDetails sharedInstance] clearUserDetails];
                            [self.parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                        else
                        {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:@"" forKey:@"email"];
                            [defaults setObject:@"" forKey:@"fb_id"];
                            [defaults synchronize];
                            [[UserDetails sharedInstance] clearUserDetails];
                            UINavigationController *splash = (UINavigationController *)self.parentViewController.presentingViewController;
                            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                                
                                [splash dismissViewControllerAnimated:YES completion:nil];
                            }];
                        }
                    }
                    
                }
                
            }
            [self hudWasHidden:hudProgress];
        }];
    }
}


-(void)textViewCharDidChange:(NSNotification *)notification
{
    UITextView *txtView1 = (UITextView *)[notification object];
    UITextView *distView = (UITextView *)[notification object];
    
    if (txtView1.tag == 10) {
        strTellUs = txtView1.text;
    } else if (distView.tag == 23){
        ProfDist = distView.text;
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtKiloMter resignFirstResponder];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


@end


/*
 fb_id=954838767953128
 firstname=Saravana
 dob=1992-04-05
 email=sarwan5492me@gmail.com
 lat=0.000000
 lng=0.000000
 height=158
 weight=63
 description=New one created
 lookingfor=2
 profile_image=http://www.rgmobiles.com/tinzapp_webservices/uploads/1492176569.jpg
 gender=1
 device_token=test
 profile_distance=8
 keyword1=One
 keyword2=Two
 keyword3=Three 
 
 */

