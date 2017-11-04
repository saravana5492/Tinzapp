//
//  ChatViewController.m
//  Twozapp
//
//  Created by Dipin on 01/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "UserDetails.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailViewController.h"
#import "HelpDesk.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "MyIconDownloader.h"
#import "IconDownloaderImage.h"
#import "NSDate+Occurance.h"
#import "SlideAlertiOS7.h"
#import "AppDelegate.h"
#import "CustomIOSAlertView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhoto.h>
#import "NYTExamplePhoto.h"



@interface ChatViewController ()<MBProgressHUDDelegate, MyIconDownloaderDelegate, IconDownloaderDelegate, UITextViewDelegate>
{
    MBProgressHUD *hudProgress;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableDictionary *ohterimageDownloadsInProgress;
    UIRefreshControl *refreshControl;
    NSIndexPath *finalIndexPath;
    BOOL fetchComplete;
    UIImage *chosenImage;
    UIImageView *chatImg;
    NSString *messageType;
    NSString *getImg;
    NSDictionary *dict;
    BOOL sendMsg;

}
@end

@implementation ChatViewController

@synthesize selectedFriend;
@synthesize messages;
@synthesize sortedMessages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _txtView.layer.cornerRadius = 5.0f;
    _txtView.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtView.layer.borderWidth = 2.0f;
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    _txtView.delegate = self;
    _txtView.text = @"Write here...";
    _txtView.textColor = [UIColor whiteColor]; //optional
    
    self.navigationController.navigationBar.topItem.title = selectedFriend.frdName;
    
    sendMsg = NO;
    _btnSmiley.hidden = YES;
    _sendBtnView.layer.cornerRadius = 4.0f;
    
    messages = [[NSMutableArray alloc] init];
    sortedMessages = [[NSMutableDictionary alloc] init];
    
    [_tblChat registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tblChat addSubview:refreshControl];
    
    _tblChat.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
    [self getMessages];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedMessage:) name:@"MessageRecievedInChatScreen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardAppears:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHides:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    
    
    _btnAttachment.layer.cornerRadius = 5.0f;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageRecievedInChatScreen" object:nil];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
        [self clearUnreadMessages];
        
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_txtView.text isEqualToString:@"Write here..."]) {
        _txtView.text = @"";
        _txtView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_txtView.text isEqualToString:@""]) {
        _txtView.text = @"Write here...";
        _txtView.textColor = [UIColor whiteColor]; //optional
    }
    [_txtView resignFirstResponder];
}


- (IBAction)selectPhoto:(UIButton *)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerOriginalImage];
    
    NSLog(@"Chosen Image: %@", chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self sendChatImage];
    
 }



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)sendChatImage{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
        
        NSString *imageValue = [UIImageJPEGRepresentation(chosenImage, 0.8) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        //NSLog(@"Image Name sss: %@", imageValue);
        
        hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudProgress.delegate = self;
        
        hudProgress.mode = MBProgressHUDModeIndeterminate;
        hudProgress.labelText = @"Loading";
        hudProgress.dimBackground = YES;
        //infowebtechsolutions.com/demo/twzapp/match.php?user_id=11
        NSString  *urlPath    = [NSString stringWithFormat:@"http://www.rgmobiles.com/tinzapp_webservices/upload_chat_images.php"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *string = [NSString stringWithFormat:@"sender_fb_id=%@&receiver_fb_id=%@&chat_image=%@", [defaults stringForKey:@"fb_id"],selectedFriend.frd_fb_Id, imageValue];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
            
            if(error) {
                NSLog(@"error : %@", [error description]);
            } else {
                // This is the expected result
                NSLog(@"Image Chat Matches result : %@", result);
                if (result.count >0) {
                    if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                        
                        //NSLog(@"Its Working!!!");
                        
                        [self getMessages];
                    }
                }
            }
            [self hudWasHidden:hudProgress];
        }];
        
    }
}


- (IBAction)actionSend:(id)sender {
    
    sendMsg = YES;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
    NSData *msgdata = [_txtView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:msgdata encoding:NSUTF8StringEncoding];
    
    hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudProgress.delegate = self;
    
    hudProgress.mode = MBProgressHUDModeIndeterminate;
    hudProgress.labelText = @"Loading";
    hudProgress.dimBackground = YES;
    //infowebtechsolutions.com/demo/twzapp/match.php?user_id=11
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/send_message.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"sender_fb_id=%@&receiver_fb_id=%@&message=%@",[defaults stringForKey:@"fb_id"],selectedFriend.frd_fb_Id,goodValue];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
        NSLog(@"Chat matches request : %@", string);
        
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Chat Matches result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {

                    [self getMessages];
                    
                }
            }
        
        }
        [self hudWasHidden:hudProgress];
        
    }];
    }
    
}




- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (void)getMessages
{
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/receive_message.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@&limit=%@",[defaults stringForKey:@"fb_id"],selectedFriend.frd_fb_Id,[NSString stringWithFormat:@"%lu",(unsigned long)messages.count]];
    NSLog(@"request -= %@",string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Matches result From receive messages: %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if ([result[@"msg"] isEqualToString:@"Result Found"]) {
                        NSArray *arr = result[@"messages"];
                        [messages removeAllObjects];
                        [messages addObjectsFromArray:arr];
                        [self sortMessageswitDate];
                        //[_tblChat reloadData];
                        if (!fetchComplete) {
                            
                            //dispatch_async(dispatch_get_main_queue(), ^{
                            if (sendMsg){
                                _txtView.text = @"";
                            }
                                [_tblChat reloadData];
                                finalIndexPath = [NSIndexPath indexPathForRow:[_tblChat numberOfRowsInSection:sortedMessages.count - 1] - 1 inSection:sortedMessages.count - 1];
                                [_tblChat scrollToRowAtIndexPath:finalIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                            //});
                            
                            //[_txtView resignFirstResponder];
                            

                        }
                    }
                 
                }
               
            }
      
        }
        [self hudWasHidden:hudProgress];
        [refreshControl endRefreshing];
        
    }];
}

- (void)clearUnreadMessages
{
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/makemsgread.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@",[defaults stringForKey:@"fb_id"],selectedFriend.frd_fb_Id];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Matches result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [[[self appDelegate] chatCounts] setObject:@"0" forKey:selectedFriend.frd_fb_Id];
                }
                
            }
            
        }
        
    }];
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)actionAttachment:(id)sender {
}
- (IBAction)actionSmiley:(id)sender {
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sortedMessages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sortedMessages objectForKey:[[self sortArrayofDates:[sortedMessages allKeys]] objectAtIndex:section]] count] + 1;
    //return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headercell"];
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
        //lblTitle.text = @"Today";
        NSString *strDateAppended = [NSString stringWithFormat:@"%@ 05:30:00",[[self sortArrayofDates:[sortedMessages allKeys]] objectAtIndex:indexPath.section]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSDate *sendDate = [formatter dateFromString:strDateAppended];
        if ([sendDate checksameWeek]) {
            if ([sendDate dayWasToday]) {
                lblTitle.text = @"Today";
            }
            else if ([sendDate dayWasYesterday])
            {
                lblTitle.text = @"Yesterday";
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEEE"];
                lblTitle.text = [dateFormatter stringFromDate:sendDate];
            }
        }
        else
        {
            lblTitle.text = [[self sortArrayofDates:[sortedMessages allKeys]] objectAtIndex:indexPath.section];
        }
        return cell;
    }
    else
    {
        dict = [[sortedMessages objectForKey:[[self sortArrayofDates:[sortedMessages allKeys]] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row - 1];
        
        NSLog(@"Dict Datas: %@", dict);
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [dict[@"message"] dataUsingEncoding:NSUTF8StringEncoding];
    getImg = [dict valueForKey:@"chat_image_url"];
        
        
    messageType = [dict valueForKey:@"message_type"];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        
        
    if ([dict[@"from_fb_id"] isEqualToString:[defaults stringForKey:@"fb_id"]]) {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"right" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:10];

        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell viewWithTag:53];
        UILabel *lblName = (UILabel *)[cell viewWithTag:20];
        UILabel *lblTime = (UILabel *)[cell viewWithTag:78];
        UILabel *lblDescription = (UILabel *)[cell viewWithTag:30];
        UIImageView *imgBackground = (UIImageView *)[cell viewWithTag:40];
        chatImg = (UIImageView *)[cell viewWithTag:50];
        [chatImg setClipsToBounds:YES];

        UIImageView *arrowImg = (UIImageView *)[cell viewWithTag:57];
        arrowImg.image = [arrowImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [arrowImg setTintColor:[UIColor colorWithRed:58/255.0 green:163/255.0 blue:219/255.0 alpha:1.0f]];
        
        UIButton *btnView = (UIButton *)[cell viewWithTag:60];
        [btnView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btnChatImg = (UIButton *)[cell viewWithTag:47];
        
        [btnChatImg addTarget:self action:@selector(showChatImage:) forControlEvents:UIControlEventTouchUpInside];

        
        if([messageType isEqualToString:@"0"]){
            chatImg.hidden = YES;
            btnChatImg.hidden = YES;

            lblDescription.hidden = NO;
            //chatImg.image = [UIImage imageWithData:imgData];
        } else if([messageType isEqualToString:@"1"]){
            chatImg.hidden = NO;
            btnChatImg.hidden = NO;

            lblDescription.hidden = YES;
        }
        
        imgView.layer.cornerRadius = 30.0f;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [imgView setClipsToBounds:YES];
        imgView.backgroundColor = [UIColor blackColor];

        
        imgBackground.layer.cornerRadius = 8.0;
        [imgBackground.layer setMasksToBounds:YES];
        imgBackground.contentMode = UIViewContentModeScaleAspectFill;
        
        
        lblName.text = [UserDetails sharedInstance].full_name;
        if ([[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].profilepicture] == nil){
            [self startDownloadImage:[UserDetails sharedInstance].profilepicture withIndexPath:indexPath];
        }
        else
        {
            imgView.image = [[HelpDesk sharedInstance] loadImageFromCache:[UserDetails sharedInstance].profilepicture];
        }
        
        lblTime.text = @"";
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        //chatImg.image = [UIImage imageWithData:imgData];
        //[chatImg sd_setImageWithURL:[NSURL URLWithString:getImg] placeholderImage:nil options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:getImg] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (image && finished) {
                // Cache image to disk or memory
                [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"image%ld%ld", (long)indexPath.section,(long)indexPath.row] toDisk:YES completion:nil];
            }
        }];

        
        activity.hidden = NO;
        [activity startAnimating];
        [chatImg sd_setImageWithURL:[NSURL URLWithString:getImg] placeholderImage:nil options:indexPath.row == 0 ? SDWebImageRefreshCached : 0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activity stopAnimating];
            activity.hidden = YES;
        }];

        
        
        lblDescription.text = goodValue;
        
        
        
        return cell;

    }
    else
    {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell viewWithTag:53];
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:10];

        UILabel *lblName = (UILabel *)[cell viewWithTag:20];
        UILabel *lblTime = (UILabel *)[cell viewWithTag:77];
        UILabel *lblDescription = (UILabel *)[cell viewWithTag:30];
        UIImageView *imgBackground = (UIImageView *)[cell viewWithTag:40];
        chatImg = (UIImageView *)[cell viewWithTag:50];
        [chatImg setClipsToBounds:YES];

        UIButton *btnView = (UIButton *)[cell viewWithTag:60];
        [btnView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];

        UIImageView *arrowImg = (UIImageView *)[cell viewWithTag:57];
        arrowImg.image = [arrowImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [arrowImg setTintColor:[UIColor colorWithRed:245/255.0 green:67/255.0 blue:107/255.0 alpha:1.0f]];

        
        UIButton *btnProfile = (UIButton *)[cell viewWithTag:100];
        [btnProfile addTarget:self action:@selector(actionShowProfile:) forControlEvents:UIControlEventTouchUpInside];
        imgView.layer.cornerRadius = 30.0f;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [imgView setClipsToBounds:YES];
        imgView.backgroundColor = [UIColor blackColor];

        
        imgBackground.layer.cornerRadius = 8.0;
        [imgBackground.layer setMasksToBounds:YES];
        imgBackground.contentMode = UIViewContentModeScaleAspectFill;
        
        UIButton *btnChatImg = (UIButton *)[cell viewWithTag:47];
        
        [btnChatImg addTarget:self action:@selector(showChatImage:) forControlEvents:UIControlEventTouchUpInside];

        
        if([messageType isEqualToString:@"0"]){
            chatImg.hidden = YES;
            btnChatImg.hidden = YES;

            lblDescription.hidden = NO;
            //chatImg.image = [UIImage imageWithData:imgData];
        } else if([messageType isEqualToString:@"1"]){
            chatImg.hidden = NO;
            btnChatImg.hidden = NO;

            lblDescription.hidden = YES;
        }
        
        lblName.text = selectedFriend.frdName;
        if ([[HelpDesk sharedInstance] loadImageFromCache:selectedFriend.fndImage] == nil){
            [self startDownloadImage:selectedFriend.fndImage withIndexPath:indexPath];
        }
        else
        {
            
            imgView.image = [[HelpDesk sharedInstance] loadImageFromCache:selectedFriend.fndImage];
        }
        
        lblTime.text = @"";
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        //[chatImg sd_setImageWithURL:[NSURL URLWithString:getImg] placeholderImage:nil options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:getImg] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (image && finished) {
                // Cache image to disk or memory
                [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"image%ld%ld", (long)indexPath.section,(long)indexPath.row] toDisk:YES completion:nil];
            }
        }];

        
        activity.hidden = NO;
        [activity startAnimating];
        [chatImg sd_setImageWithURL:[NSURL URLWithString:getImg] placeholderImage:nil options:indexPath.row == 0 ? SDWebImageRefreshCached : 0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activity stopAnimating];
            activity.hidden = YES;
        }];

        
        lblDescription.text = goodValue;

        return cell;
    }
    }

}


- (IBAction)showImage:(id)sender{
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: getImg]];
    
    NSLog(@"Show Image: %@", getImg);
    
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    NYTExamplePhoto *photo1 = [[NYTExamplePhoto alloc] init];
    photo1.image = [UIImage imageWithData: imageData];
    [imgArray addObject:photo1];
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:imgArray];
    photosViewController.rightBarButtonItem = nil;
    [self presentViewController:photosViewController animated:YES completion:nil];

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    if (indexPath.row == 0) {
        return 24;
    } else if(!chatImg.hidden){
        return 300;
    }
        return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 24;
    } else if(!chatImg.hidden){
        return 300;
    }
        return UITableViewAutomaticDimension;
   
}
- (NSArray *)sortArrayonDaye:(NSArray *)array
{
    NSMutableArray *arraytoSort = [[NSMutableArray alloc] initWithArray:array];
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    
    
    NSComparator compareDates = ^(id string1, id string2)
    {
        NSDate *date1 = [fmtDate dateFromString:string1];
        NSDate *date2 = [fmtDate dateFromString:string2];
        
        return [date1 compare:date2];
    };
    
   
    NSSortDescriptor * sortDesc1 = [[NSSortDescriptor alloc] initWithKey:@"sent_time" ascending:YES comparator:compareDates];
    [arraytoSort sortUsingDescriptors:@[sortDesc1]];
    
    return arraytoSort;
}

- (void)sortMessageswitDate
{
    fetchComplete = NO;
    int containCount = 0;
    for (NSDictionary *dict1 in messages) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSDate *sendDate = [formatter dateFromString:dict1[@"sent_time"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strSendDate = [dateFormatter stringFromDate:sendDate];
        
        if (![[sortedMessages allKeys] containsObject:strSendDate]) {
            [sortedMessages setObject:[[NSMutableArray alloc] init] forKey:strSendDate];
            
        }
        if (![[sortedMessages objectForKey:strSendDate] containsObject:dict1]) {
            [[sortedMessages objectForKey:strSendDate] addObject:dict1];
        }
        else
        {
            containCount ++;

        }
            }
    if (messages.count == containCount) {
        fetchComplete = YES;
    }
}

- (NSArray *)sortArrayofDates:(NSArray *)arraytobesorted
{
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[arraytobesorted sortedArrayUsingDescriptors:descriptors];
    
    return reverseOrder;
}


- (IBAction)showChatImage:(UIButton *)btn{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tblChat];
    NSIndexPath *indexPathtopic = [self.tblChat indexPathForRowAtPoint:buttonPosition];
    if (indexPathtopic != nil) {
        //NSDictionary *dictPass = [[_sortedMessages objectForKey:[[self sortArrayofDates:[_sortedMessages allKeys]] objectAtIndex:indexPathtopic.section]] objectAtIndex:indexPathtopic.row - 1];
        
        UIImage *img1 = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"image%ld%ld", (long)indexPathtopic.section,(long)indexPathtopic.row]];
        
        NSMutableArray *imgArray = [[NSMutableArray alloc] init];
        if (img1 != nil) {
            NYTExamplePhoto *photo1 = [[NYTExamplePhoto alloc] init];
            photo1.image = img1;
            [imgArray addObject:photo1];
        }
        
        NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:imgArray];
        photosViewController.rightBarButtonItem = nil;
        [self presentViewController:photosViewController animated:YES completion:nil];
        
    }
}



- (void)keyBoardAppears:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = keyboardSize.height;
    
    
    
    
[UIView animateWithDuration:0.75 animations:^{
    [_tblChat setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    _bottomSpacemessageEntry.constant = height;
    [self.view layoutIfNeeded];}];
}

- (void)keyBoardHides:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = keyboardSize.height;
    
    _bottomSpacemessageEntry.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.75 animations:^{[self.view layoutIfNeeded];}];
}

- (void)startDownloadImage:(NSString*)imageUrl withIndexPath:(NSIndexPath *)indexPath
{
    MyIconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[MyIconDownloader alloc] init];
        iconDownloader.imageURL = imageUrl;
        iconDownloader.indexPathinCollectionView = indexPath;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (void)appDidDownloadImagewithIndexPath:(NSIndexPath *)indexPath;
{
    [_tblChat reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)appDidDownloadImage
{
    [_tblChat reloadData];
}

- (void)startDownloadImage:(UserFriends*)friendDetails withTag:(NSIndexPath *)indexpath
{
    IconDownloaderImage *iconDownloader = [ohterimageDownloadsInProgress objectForKey:indexpath];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloaderImage alloc] init];
        iconDownloader.userFriends = friendDetails;
        iconDownloader.indexPathinCollectionView = indexpath;
        iconDownloader.delegateProduct = self;
        [ohterimageDownloadsInProgress setObject:iconDownloader forKey:indexpath];
        [iconDownloader startDownload];
    }
}


- (void)appDidDownloadImage:(NSIndexPath *)indexpath;
{
    IconDownloaderImage *iconDownloader = [ohterimageDownloadsInProgress objectForKey:indexpath];
    
    if (iconDownloader != nil)
    {
        [[HelpDesk sharedInstance] saveImageToCache:iconDownloader.userFriends.imageIcon withName:iconDownloader.userFriends.fndImage];
        
        [_tblChat reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    [ohterimageDownloadsInProgress removeObjectForKey:indexpath];
}

- (void)handleRefresh:(id)sender
{
    [self getMessages];
}

- (void)recievedMessage:(NSNotification *)notification
{
    NSDictionary *person = (NSDictionary *)[notification object];
    if ([person[@"facebookId"] isEqualToString:selectedFriend.frd_fb_Id]) {
        [self getMessages];
    }
    else
    {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failure" withText:[NSString stringWithFormat:@"You have a new message from %@",person[@"name"]]];
    }
}

- (void)actionShowProfile:(id)sender
{
    DetailViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    details.selecteduserFriend = selectedFriend;
    details.typeUser = @"friend";
    [self.navigationController pushViewController:details animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
        [self getMessages];
    }
}
@end
