//
//  MainViewController.m
//  Twozapp
//
//  Created by Priya on 10/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "MainViewController.h"
#import "RNFrostedSidebar.h"
#import "DraggableView.h"
#import "NetworkManager.h"
#import "UserFriends.h"
#import "MatchesViewController.h"
#import "OverlayView.h"
#import "UserDetails.h"
#import "HelpDesk.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "SlideAlertiOS7.h"
#import "ReportViewController.h"
#import "EDStarRating.h"
#import "ChatViewController.h"
#import "allChatUsers.h"
#import "SWRevealViewController.h"


static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 386; //%%% height of the draggable card
static const float CARD_WIDTH = 290;

@interface MainViewController ()<RNFrostedSidebarDelegate, MBProgressHUDDelegate, EDStarRatingProtocol>{
    NSInteger cardsLoadedIndex; 
    NSMutableArray *loadedCards;
    NSMutableArray *friendList;
    OverlayView *overlayView;
    NSMutableDictionary *imageDownloadsInProgress;
    MBProgressHUD *hudProgress;
    BOOL sideViewShown;
    RNFrostedSidebar *callout;
    int i;
    
    BOOL chatfound;
    NSMutableArray *keys;
    NSMutableArray *totalImages;
}
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;


@end

@implementation MainViewController
@synthesize exampleCardLabels;
@synthesize allCards;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    chatfound = NO;
    keys = [[NSMutableArray alloc]init];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubutton"]
                                                 style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = _leftMenu;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    friendList = [[NSMutableArray alloc] init];
    _imgViewProfilePic.layer.cornerRadius = 7.0f;
    [_imgViewProfilePic.layer setMasksToBounds:YES];
//    _viewName.layer.cornerRadius = 7.0f;
//    [_viewName.layer setMasksToBounds:YES];
//    _viewBazi.layer.cornerRadius = 7.0f;
//    [_viewBazi.layer setMasksToBounds:YES];
    i=0;
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:238/255.0 green:52/255.0 blue:85/255.0 alpha:1.0f]];
    //self.navigationController.navigationBar.translucent = NO;
    
    /*[_rightBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"Segoe Print" size:20.0], NSFontAttributeName,
                                             [UIColor whiteColor], NSForegroundColorAttributeName,
                                             nil]
                                   forState:UIControlStateNormal];*/

    
  //  exampleCardLabels = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", @"first",@"second",@"third",@"fourth",@"last", @"first",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
    loadedCards = [[NSMutableArray alloc] init];
    allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    
    
    
    }

- (void)viewDidAppear:(BOOL)animated
{
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [NSURLConnection sendAsynchronousRequest:[self uploadImages]
//                                       queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                               if (error) {
//                                   
//                               }
//                               else
//                               {
//                                   NSString *response = [NSJSONSerialization JSONObjectWithData:data
//                                                                                            options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
//                                                                                              error:&error];
//                                   NSLog(@"the image response = %@",response);
//                               }
//                               
//                           }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    NSLog(@"Self Class: %@", self.class);
    _lblnoUsers.hidden = YES;
    hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudProgress.delegate = self;
    
    hudProgress.mode = MBProgressHUDModeIndeterminate;
    hudProgress.labelText = @"Loading";
    hudProgress.dimBackground = YES;
    
    // for getting list of nearby users
    loadedCards = [[NSMutableArray alloc] init];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"No Internet connection Available."];
    } else {
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/search.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Nearest Friends result : %@", result);
            
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [friendList removeAllObjects];
                    NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                    
                    arrResponse = result[@"result"];
                    if (![arrResponse isEqual:[NSNull null]]) {
                    for (int i = 0; i<[arrResponse count]; i++) {
                        UserFriends *listfriends = [[UserFriends alloc] init];
                        listfriends.frdId = [[arrResponse objectAtIndex:i] objectForKey:@"registerid"];
                        listfriends.frdName = [[arrResponse objectAtIndex:i] objectForKey:@"name"];
                        listfriends.frddob = [[arrResponse objectAtIndex:i] objectForKey:@"dob"];
                        listfriends.fndImage = [[arrResponse objectAtIndex:i] objectForKey:@"profilepicture"];
                        listfriends.frd_fb_Id = [[arrResponse objectAtIndex:i] objectForKey:@"facebookid"];
                        listfriends.fndEmail = [[arrResponse objectAtIndex:i] objectForKey:@"email"];
                        listfriends.fndDescription = [[arrResponse objectAtIndex:i] objectForKey:@"description"];
                        listfriends.fndGender = [[arrResponse objectAtIndex:i] objectForKey:@"gender"];
                        listfriends.birthtime = [[arrResponse objectAtIndex:i] objectForKey:@"birthtime"];
                        listfriends.height = [[arrResponse objectAtIndex:i] objectForKey:@"height"];
                        listfriends.weight = [[arrResponse objectAtIndex:i] objectForKey:@"weight"];
                        listfriends.pointstar = [NSString stringWithFormat:@"%@",[[arrResponse objectAtIndex:i] objectForKey:@"pointstar"]];
                        listfriends.onlineStatus = [NSString stringWithFormat:@"%@",[[arrResponse objectAtIndex:i] objectForKey:@"status"]];
                        [friendList addObject:listfriends];
                    }
                    }
                    if (friendList.count == 0) {
                        _lblnoUsers.hidden = NO;
                    }
                    else
                    {
                        [self loadCards];
                        //[self requestProfileDetails];
                    }
                }
                else
                {
                    _lblnoUsers.hidden = NO;
                }
            }
            [self hudWasHidden:hudProgress];
            
        }
    }];
    }

}


- (NSMutableURLRequest *)uploadImages
{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
   // [_params setObject:[UserDetails sharedInstance].user_id forKey:@"profile_id"];
    [_params setObject:@"filename" forKey:@"profile_picture1"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"file";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://infowebtechsolutions.com/demo/twzapp/image_move.php?"];
    
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
    
    UIImage *img = [UIImage imageNamed:@"imgSample.png"];
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions



- (IBAction)actionNotIntrested:(id)sender {
    _btnNotIntrested.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/2 animations:^{
        _btnNotIntrested.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            _btnNotIntrested.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                _btnNotIntrested.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
 
    
}

- (IBAction)actionIntrested:(id)sender {
    
    _btnIntrested.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:4.0/4 animations:^{
        _btnIntrested.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:4.0/4 animations:^{
            _btnIntrested.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:4.0/4 animations:^{
                _btnIntrested.transform = CGAffineTransformIdentity;
            }];
        }];
    }];

}




-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DraggableView *draggableView = [[[NSBundle mainBundle] loadNibNamed:@"DraggableView" owner:self options:nil] lastObject];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    NSLog(@"height = %f",screenHeight);
    draggableView.frame = CGRectMake(0, 0, self.view.frame.size.width, screenHeight - 64);
    
    [draggableView setupView];
 
    draggableView.delegate = self;
    return draggableView;
}

-(void)loadCards
{
    NSLog(@"Cards Count: %lu", (unsigned long)friendList.count);
    
    if([friendList count] > 0) {
        //NSInteger numLoadedCardsCap =(([friendList count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[friendList count]);
        NSInteger numLoadedCardsCap =[friendList count];
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[friendList count]; i++) {
            UserFriends *userFriend = friendList[i];
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [newCard.btnLike addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
            [newCard.btnProfileDetails addTarget:self action:@selector(actionProfileDetails:) forControlEvents:UIControlEventTouchUpInside];
            newCard.btnLike.tag = i;
            newCard.btnDislike.tag = i;
            newCard.tag = i;
            
            if ([userFriend.onlineStatus isEqualToString:@"1"]) {
                newCard.imgOnline.hidden = NO;
            }
            else
            {
                newCard.imgOnline.hidden = YES;
            }
            
  /*          EDStarRating *starRating = (EDStarRating *)[newCard viewWithTag:1000];
            float rating = userFriend.pointstar.intValue;

                    //float rating = (_selectedUsers.pointstar.intValue)*100/6;
                    //  if ((_selectedUsers.pointstar.intValue) != 0) {
                    starRating.backgroundColor  = [UIColor clearColor];
                    starRating.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    starRating.maxRating = 6.0;
                    starRating.delegate = self;
                    starRating.horizontalMargin = 15.0;
                    starRating.editable=NO;
                    starRating.rating = rating;
                    starRating.displayMode=EDStarRatingDisplayHalf;
                    [starRating  setNeedsDisplay];
                    starRating.tintColor = [UIColor colorWithRed:157.0/255.0 green:0 blue:33.0/255.0 alpha:1.0];
                    //[self starsSelectionChanged:_starRating rating:2.5];
  */                  //}

            if ([[HelpDesk sharedInstance] loadImageFromCache:userFriend.fndImage] != nil){
                newCard.imgProfile.image = [[HelpDesk sharedInstance] loadImageFromCache:userFriend.fndImage];
            }
            else
            {
                if (!userFriend.imageIcon && userFriend.fndImage.length > 0)
                {
                    newCard.imgProfile.image = [UIImage imageNamed:@""];
                    [self startDownloadImage:userFriend withTag:i];
                }
            }
            newCard.btnReport.tag = i;
            [newCard.btnReport addTarget:self action:@selector(actionReport:) forControlEvents:UIControlEventTouchUpInside];
            [newCard.btnDislike addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];

            [allCards addObject:newCard];
            newCard.layer.cornerRadius = 5.0f;
            newCard.layer.masksToBounds = YES;
            newCard.userFriend = friendList[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-mm-dd"];
            NSDate* birthday = [formatter dateFromString:newCard.userFriend.frddob];
            
            NSDate* now = [NSDate date];
            NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                               components:NSCalendarUnitYear
                                               fromDate:birthday
                                               toDate:now
                                               options:0];
            NSInteger age = [ageComponents year];
            newCard.lblName.text = [NSString stringWithFormat:@"%@, %ld",[newCard.userFriend.frdName capitalizedString],(long)age];
            //newCard.lblName.text = [NSString stringWithFormat:@"%@, 24",newCard.userFriend.frdName];

            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [_viewProfile insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [_viewProfile addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
    
}

- (IBAction)actionReport:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    DraggableView *dragableView = (DraggableView *)loadedCards[btn.tag];
    UserFriends *selectedFriend = (UserFriends *)dragableView.userFriend;
    [self performSegueWithIdentifier:@"toReport" sender:selectedFriend];
}



- (void)startDownloadImage:(UserFriends*)friendDetails withTag:(NSInteger)selectedtag
{
    IconDownloaderImage *iconDownloader = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%li",(long)selectedtag]];
    
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloaderImage alloc] init];
        iconDownloader.userFriends = friendDetails;
        iconDownloader.selectedtag = selectedtag;
        iconDownloader.delegateProduct = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:[NSString stringWithFormat:@"%li",(long)selectedtag]];
        [iconDownloader startDownload];
    }
}


- (void)appDidDownloadImagewithTag:(NSInteger)indexpath;
{
    IconDownloaderImage *iconDownloader = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%li",(long)indexpath]];
    
    if (iconDownloader != nil)
    {
        [[HelpDesk sharedInstance] saveImageToCache:iconDownloader.userFriends.imageIcon withName:iconDownloader.userFriends.fndImage];
        
        NSLog(@"_viewProfile subviews = %@",_viewProfile.subviews);
        for (DraggableView *view in _viewProfile.subviews) {
            if ([view isKindOfClass:[DraggableView class]]) {
                if (view.tag == indexpath) {
               view.imgProfile.image = [[HelpDesk sharedInstance] loadImageFromCache:iconDownloader.userFriends.fndImage];
                }
            }
        }
        
        
        
    }
    [imageDownloadsInProgress removeObjectForKey:[NSString stringWithFormat:@"%li",(long)indexpath]];
}
#pragma mark - Card swipe Action

-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
        DraggableView *c = (DraggableView *)card;
    UserFriends *friend = c.userFriend;
    [self sendRequestwithStatus:@"0" forFriendId:friend.frd_fb_Id];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [_viewProfile insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
        
        
        
    }
    if (loadedCards.count == 0) {
        _lblnoUsers.hidden = NO;
    }
}

-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
        DraggableView *c = (DraggableView *)card;
    UserFriends *friend = c.userFriend;
    [self sendRequestwithStatus:@"1" forFriendId:friend.frd_fb_Id];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [_viewProfile insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
        
    }
    
    if (loadedCards.count == 0) {
        _lblnoUsers.hidden = NO;
    }
    
}


-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:3.0 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
    UserFriends *friend = dragView.userFriend;
    [self sendRequestwithStatus:@"1" forFriendId:friend.frd_fb_Id];
}

-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:3.0 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
     UserFriends *friend = dragView.userFriend;
     [self sendRequestwithStatus:@"0" forFriendId:friend.frd_fb_Id];

}




- (void)sendRequestwithStatus:(NSString *)status forFriendId:(NSString *)friendID
{
   
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/friend_request.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@&status=%@",[defaults stringForKey:@"fb_id"],friendID,status];
        
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    i++;
    NSLog(@"%i",i);
    NSLog(@"Request path: %@", urlPath);
    NSLog(@"Request String: %@", string);
    
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
                                                     if(error) {
                                                         NSLog(@"error : %@", [error description]);
                                                     } else {
                                                         // This is the expected result
                                                         NSLog(@"result : %@", result);
                                                         if (result.count >0) {
                                                             if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                                                                 
                                                                
                                                             }
                                                             else
                                                             {
                                                                 
                                                             }
                                                         }
                                                         
                                                     }
                                                 }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hudProgress removeFromSuperview];
    hudProgress = nil;
}

- (IBAction)actionProfileDetails:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    DraggableView *drag = (DraggableView *)btn.superview.superview;
    UserFriends *friend = drag.userFriend;
    
    DetailViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    details.selecteduserFriend = friend;
    details.typeUser = @"new";
    
    [self.navigationController pushViewController:details animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toReport"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        
        ReportViewController *report = (ReportViewController *)[[nav viewControllers] lastObject];
        report.selectedFriend = (UserFriends *)sender;
    }
}
@end
