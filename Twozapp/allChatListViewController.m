//
//  allChatListViewController.m
//  Twozapp
//
//  Created by Apple on 23/12/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "allChatListViewController.h"
#import "ChatSummary.h"
#import "Chat.h"
#import "allChatViewController.h"
#import "UserFriends.h"
#import "NetworkManager.h"
#import "UserDetails.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "IconDownloaderImage.h"
#import "HelpDesk.h"
#import "SlideAlertiOS7.h"
#import "MatchesViewController.h"
#import "SWRevealViewController.h"




@interface allChatListViewController ()<UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, IconDownloaderDelegate>
{
    NSMutableArray *chatsummarys;
    MBProgressHUD *hudProgress;
    NSMutableDictionary *imageDownloadsInProgress;
    UserFriends *selectedFriend;
    UIRefreshControl *refreshControl;
}

@end

@implementation allChatListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextCount:) name:@"UPDATECHATCOUNT" object:nil];
    self.navigationController.navigationBar.translucent = NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton"]
                                                 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = _leftMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //self.title = @"MESSage";
    
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    chatsummarys = [[NSMutableArray alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewChatList addSubview:refreshControl];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedMessage:) name:@"RecievedMessageinChatList" object:nil];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
        [self performSelector:@selector(getChatList) withObject:nil afterDelay:0.25];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RecievedMessageinChatList" object:nil];
}

- (void)getChatList
{
    hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudProgress.delegate = self;
    
    hudProgress.mode = MBProgressHUDModeIndeterminate;
    hudProgress.labelText = @"Loading";
    hudProgress.dimBackground = YES;
    //infowebtechsolutions.com/demo/twzapp/match.php?user_id=11
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://www.rgmobiles.com/tinzapp_webservices/without_match_chat_box_contacts.php"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"My Matches result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if (result[@"result"] != [NSNull null]) {
                        
                        
                        NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                        arrResponse = result[@"result"];
                        if (arrResponse.count > 0) {
                            
                            [chatsummarys removeAllObjects];
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
                                listfriends.lastMessage = [dict objectForKey:@"lastmessage"];
                                listfriends.lastMessageTime = [dict objectForKey:@"lastmsgtime"];
                                listfriends.onlineStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
                                listfriends.pointstar = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pointstar"]];
                                
                                [chatsummarys addObject:listfriends];
                                
                                
                            }
                            [_tableViewChatList reloadData];
                        }
                    }
                    
                }else{
                    
                }
            }
            
            
        }
        
        [self hudWasHidden:hudProgress];
        [refreshControl endRefreshing];
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return chatsummarys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"allChatCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *imgViewProfilePic = (UIImageView *)[cell viewWithTag:10];
    imgViewProfilePic.contentMode = UIViewContentModeScaleAspectFill;
    [imgViewProfilePic setClipsToBounds:YES];

    [imgViewProfilePic layoutIfNeeded];
    imgViewProfilePic.layer.cornerRadius = 35.0f;
    [imgViewProfilePic.layer setMasksToBounds:YES];
    
    NSLog(@"Pic height: %f, width: %f", imgViewProfilePic.frame.size.height, imgViewProfilePic.frame.size.width);
    //imgViewProfilePic.image = [UIImage imageNamed:@"imgSample.png"];
    
    UserFriends *userFriends = chatsummarys[indexPath.row];
    UIImageView *imgViewOline = (UIImageView *)[cell viewWithTag:20];
    
    UIImageView *arrowImg = (UIImageView *)[cell viewWithTag:57];
    arrowImg.image = [arrowImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [arrowImg setTintColor:[UIColor colorWithRed:245/255.0 green:67/255.0 blue:107/255.0 alpha:1.0f]];

    
    if ([userFriends.onlineStatus isEqualToString:@"1"]) {
        imgViewOline.hidden = NO;
    }
    else
    {
        imgViewOline.hidden = YES;
    }
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:30];
    UILabel *lblCount = (UILabel *)[cell viewWithTag:1000];
    lblCount.layer.cornerRadius = 10.0f;
    lblCount.layer.masksToBounds = YES;
    lblCount.hidden = YES;
    
    UILabel *lblChats = (UILabel *)[cell viewWithTag:40];
    
    UILabel *lblDate = (UILabel *)[cell viewWithTag:50];
    
    UIImageView *imgBackground = (UIImageView *)[cell viewWithTag:100];
    imgBackground.layer.cornerRadius = 8.0f;
    
    lblName.text = userFriends.frdName;
    lblChats.text = userFriends.lastMessage;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    
    NSDate *lastmsgDate = [formatter dateFromString:userFriends.lastMessageTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM"];
    
    lblDate.text = [dateFormatter stringFromDate:lastmsgDate];
    
    if ([[HelpDesk sharedInstance] loadImageFromCache:userFriends.fndImage] != nil){
        imgViewProfilePic.image = [[HelpDesk sharedInstance] loadImageFromCache:userFriends.fndImage];
    }
    else
    {
        if (!userFriends.imageIcon && userFriends.fndImage.length > 0)
        {
            imgViewProfilePic.image = [UIImage imageNamed:@""];
            [self startDownloadImage:userFriends withTag:indexPath];
        }
    }
    
    [self getUnreadMessageCountforFriendId:userFriends.frd_fb_Id withIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedFriend = chatsummarys[indexPath.row];
    [self performSegueWithIdentifier:@"toAllChats" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

-(BOOL)saveManageObject{
    NSError *error = nil;
    if ([[[self appDelegate] managedObjectContext] save:&error]) {
        
        return YES;
    }else{
        ////NSLog(@"Database Save error :%@",[error description]);
    }
    return NO;
}

- (NSArray *)checkChatSummaryExist:(NSString *)friendId
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ChatSummary"];
    request.predicate = [NSPredicate predicateWithFormat:@"friend_id == %@",friendId];
    
    NSArray *array = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    return array;
}

- (NSArray *)fetchChatSummary
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ChatSummary"];
    NSError *error;
    NSArray *array = [[[self appDelegate] managedObjectContext] executeFetchRequest:request error:&error];
    
    return array;
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
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
        
        [_tableViewChatList reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    [imageDownloadsInProgress removeObjectForKey:indexpath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    allChatViewController *chatView = (allChatViewController *)segue.destinationViewController;
    chatView.navigationItem.title = selectedFriend.frdName;
    chatView.selectedFriend = selectedFriend;
}

- (void)getUnreadMessageCountforFriendId:(NSString *)friendId withIndexPath:(NSIndexPath *)indexpath
{
    __block NSData *dataFromServer = nil;
    NSBlockOperation *downloadOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakDownloadOperation = downloadOperation;
    
    [weakDownloadOperation addExecutionBlock:^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet connection Available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        } else {
            [self requestGetUnreadMessagesfor:friendId withIndexPath:indexpath];
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

- (void)requestGetUnreadMessagesfor:(NSString *)friendId withIndexPath:(NSIndexPath *)indexpath
{
    
    NSString * urlString = [NSString stringWithFormat:@"http://www.rgmobiles.com/tinzapp_webservices/without_match_get_unread_msg_count.php"];
    NSURL * url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
    [request1 setHTTPMethod:@"POST"];
    [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@",[defaults stringForKey:@"fb_id"],friendId];
    NSLog(@"unread message alert = %@",string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    request1.accessibilityValue = [NSString stringWithFormat:@"%li",(long)indexpath.row];
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
                     UITableViewCell *cell = (UITableViewCell *)[_tableViewChatList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:request1.accessibilityValue.integerValue inSection:0]];
                     UILabel *lblCount = (UILabel *)[cell viewWithTag:1000];
                     lblCount.text = [NSString stringWithFormat:@"%@",unreadMessages[@"unreadmessages_count"]];
                     NSLog(@"unread message = %@ for %@",unreadMessages[@"unreadmessages_count"],friendId);
                     lblCount.hidden = NO;
                     [[[self appDelegate] chatCounts] setObject:[NSString stringWithFormat:@"%@",unreadMessages[@"unreadmessages_count"]] forKey:friendId];
                 }
                 else
                 {
                     
                 }
                 
             }
         }
         
     }];
}

- (void)updateTableViewCellwithIndexPath:(NSIndexPath *)indexPath
{
    //[_tableViewChatList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)handleRefresh:(id)sender
{
    [self getChatList];
}

- (void)recievedMessage:(NSNotification *)notification
{
    [self getChatList];
}

- (void)updateTextCount:(NSNotification *)notification
{
    [_tableViewChatList reloadData];
}
@end
