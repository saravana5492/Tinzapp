//
//  AppDelegate.m
//  Twozapp
//
//  Created by Priya on 09/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
#import "SlideAlertiOS7.h"
#import "Reachability.h"
#import "NetworkManager.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()
{
    NSMutableArray *chats;
}
@end

@implementation AppDelegate

@synthesize locationManager;
@synthesize location;
@synthesize deviceToken;
@synthesize chatCounts;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:238/255.0 green:52/255.0 blue:85/255.0 alpha:1.0f]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadMessageCountforFriendId) name:@"LogedInSuccessfully" object:nil];
    
    chatCounts = [[NSMutableDictionary alloc] init];
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
#if TARGET_IPHONE_SIMULATOR
    deviceToken = @"test";
#endif
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"firstLaunch",nil]];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self registerForRemoteNotification];

    
/*    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                NSLog(@"Push Notif iOS 10 can run");
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                NSLog(@"Push Notif iOS 10 error %@: ", error);
            }
        }];
    } else {
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                                 |UIRemoteNotificationTypeSound
                                                                                                 |UIRemoteNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:settings];
        } else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:myTypes];
        }
    } */

    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    // Override point for customization after application launch.
    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    NSLog(@"User Notification setting called!!");
    
    [application registerForRemoteNotifications];
}

#pragma mark - Remote Notification Delegate // <= iOS 9.x


//– (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)device_Token
{
 //0b04ddc4e73e96a59f9c473cb1d9ce41fcce18cf3087e6551a5d7dbbabfd28d4
     NSLog(@"Did Register for Remote Notifications with Device Token (%@)", device_Token);
    #if TARGET_IPHONE_SIMULATOR
    deviceToken = @"test";
#else
    NSString *token = [[device_Token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"User device content---%@", deviceToken);
    
    //[[[UIAlertView alloc] initWithTitle:@"Alert" message:deviceToken delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
#endif
   }


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}




- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"Did Receive Notification called!!");
    
    NSRange alertRange = [userInfo[@"aps"][@"alert"] rangeOfString:@"Congratulations! You have a new match!"];
    if (alertRange.location != NSNotFound) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMatches" object:nil];
      [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Congratulations! You have a new match!"];
        
        NSLog(@"Checkkk: One did receive remote noti, Match found!!!");
    }
    else
    {
        [self getUnreadMessageCountforFriendId];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievedMessageinChatList" object:nil];
        //[[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:[NSString stringWithFormat:@"You have a new message from %@",userInfo[@"person"][@"name"]]];
        
        NSDictionary *dict = @{@"alert" : userInfo[@"aps"][@"alert"], @"facebookId" : userInfo[@"person"][@"friendid"], @"name" : userInfo[@"person"][@"name"]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageRecievedInChatScreen" object:dict];

        
        /*UINavigationController *nav = (UINavigationController *)[self topMostController];
        UIViewController *lastViewController = [nav.viewControllers lastObject];
        NSLog(@"Checkkk: nav view controllers = %@",nav.viewControllers);
        if ([[lastViewController class] isEqual:[ChatViewController class]]) {
            NSLog(@"Checkkk: Inside ChatView");
            NSDictionary *dict = @{@"alert" : userInfo[@"aps"][@"alert"], @"facebookId" : userInfo[@"person"][@"friendid"], @"name" : userInfo[@"person"][@"name"]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageRecievedInChatScreen" object:dict];
            NSLog(@"Checkkk: Two did receive remote noti");
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievedMessageinChatList" object:nil];
            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:[NSString stringWithFormat:@"You have a new message from %@",userInfo[@"person"][@"name"]]];
            NSLog(@"Checkkk: Three did receive remote noti");
        }*/
    }
}


#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info Will present = %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    
    NSRange alertRange = [notification.request.content.userInfo[@"aps"][@"alert"] rangeOfString:@"Congratulations! You have a new match!"];
    if (alertRange.location != NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMatches" object:nil];
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Congratulations! You have a new match!"];
        
        NSLog(@"Checkkk: One did receive remote noti, Match found!!!");
    }
    else
    {
        [self getUnreadMessageCountforFriendId];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievedMessageinChatList" object:nil];
        //[[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:[NSString stringWithFormat:@"You have a new message from %@", notification.request.content.userInfo[@"person"][@"name"]]];
        
        NSDictionary *dict = @{@"alert" : notification.request.content.userInfo[@"aps"][@"alert"], @"facebookId" : notification.request.content.userInfo[@"person"][@"friendid"], @"name" : notification.request.content.userInfo[@"person"][@"name"]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageRecievedInChatScreen" object:dict];
        
        
        //UINavigationController *nav = (UINavigationController *)[self topMostController];
        //UIViewController *lastViewController = [nav.viewControllers lastObject];
        //NSLog(@"Checkkk: nav view controllers = %@",nav.viewControllers);
        /*if ([[lastViewController class] isEqual:[ChatViewController class]]) {
         NSLog(@"Checkkk: Inside ChatView");
         NSDictionary *dict = @{@"alert" : response.notification.request.content.userInfo[@"aps"][@"alert"], @"facebookId" : response.notification.request.content.userInfo[@"person"][@"friendid"], @"name" : response.notification.request.content.userInfo[@"person"][@"name"]};
         [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageRecievedInChatScreen" object:dict];
         NSLog(@"Checkkk: Two did receive remote noti");
         }
         else
         {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievedMessageinChatList" object:nil];
         [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:[NSString stringWithFormat:@"You have a new message from %@", response.notification.request.content.userInfo[@"person"][@"name"]]];
         NSLog(@"Checkkk: Three did receive remote noti");
         }*/
    }

    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info Did Receive = %@",response.notification.request.content.userInfo);
    
    completionHandler();
    
    NSRange alertRange = [response.notification.request.content.userInfo[@"aps"][@"alert"] rangeOfString:@"Congratulations! You have a new match!"];
    if (alertRange.location != NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMatches" object:nil];
        [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:@"Congratulations! You have a new match!"];
        
        NSLog(@"Checkkk: One did receive remote noti, Match found!!!");
    }
    else
    {
        [self getUnreadMessageCountforFriendId];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievedMessageinChatList" object:nil];
        //[[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:[NSString stringWithFormat:@"You have a new message from %@", response.notification.request.content.userInfo[@"person"][@"name"]]];
        
        NSDictionary *dict = @{@"alert" : response.notification.request.content.userInfo[@"aps"][@"alert"], @"facebookId" : response.notification.request.content.userInfo[@"person"][@"friendid"], @"name" : response.notification.request.content.userInfo[@"person"][@"name"]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageRecievedInChatScreen" object:dict];

        
        //UINavigationController *nav = (UINavigationController *)[self topMostController];
        //UIViewController *lastViewController = [nav.viewControllers lastObject];
        //NSLog(@"Checkkk: nav view controllers = %@",nav.viewControllers);
        /*if ([[lastViewController class] isEqual:[ChatViewController class]]) {
            NSLog(@"Checkkk: Inside ChatView");
            NSDictionary *dict = @{@"alert" : response.notification.request.content.userInfo[@"aps"][@"alert"], @"facebookId" : response.notification.request.content.userInfo[@"person"][@"friendid"], @"name" : response.notification.request.content.userInfo[@"person"][@"name"]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageRecievedInChatScreen" object:dict];
            NSLog(@"Checkkk: Two did receive remote noti");
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RecievedMessageinChatList" object:nil];
            [[SlideAlertiOS7 sharedSlideAlert] showSlideAlertViewWithHighDurationWithStatus:@"Failre" withText:[NSString stringWithFormat:@"You have a new message from %@", response.notification.request.content.userInfo[@"person"][@"name"]]];
            NSLog(@"Checkkk: Three did receive remote noti");
        }*/
    }

}


- (UIViewController*) topMostController
{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *top2viewCont = topController.presentedViewController;
    
    
    while (top2viewCont.presentedViewController) {
        top2viewCont = top2viewCont.presentedViewController;
    }
    
    return top2viewCont;
}

#pragma mark - Class Methods

/**
 Notification Registration
 */
- (void)registerForRemoteNotification {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                NSLog(@"Push Notif iOS 10 can run");
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else {
                NSLog(@"Push Notif iOS 10 error %@: ", error);
            }
        }];
    }
    else {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self requestGoOnline:@"0"];
    NSLog(@"Online Status: 0");
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

/*
 
 Got the device token and sent it to php side (success)
 php sending notification when message send (success)
 notifcation delivered to my device id (success)
 
 device settings push notification enabled (ok)
 developer account push notification enabled (ok)
 app id: push notification developer: enabled | distribution: configurable
 development SSL cerficate created ; .cer - p12 - pem
 Sent pem file and password to back end (updated)
 my device not received notification (failure)
 
*/

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self getUnreadMessageCountforFriendId];
    
    [self requestGoOnline:@"1"];
    NSLog(@"Online Status: 1");

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self requestGoOnline:@"0"];
    NSLog(@"Online Status: 0");

    [self saveContext];
}


- (void)getUnreadMessageCountforFriendId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults stringForKey:@"fb_id"]) {
        
        NSLog(@"Checkkk: Getunread message count: %@", [defaults stringForKey:@"fb_id"]);
    
        
    __block NSData *dataFromServer = nil;
    NSBlockOperation *downloadOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakDownloadOperation = downloadOperation;
    
    [weakDownloadOperation addExecutionBlock:^{
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            
        } else {
            
            [self getChatList];
            NSLog(@"Checkkk: Get chat list called!!");
            
           
        }
    }];
    
//        NSBlockOperation *saveToDataBaseOperation = [[NSBlockOperation alloc] init];
//        __weak NSBlockOperation *weakSaveToDataBaseOperation = saveToDataBaseOperation;
//    
//        [weakSaveToDataBaseOperation addExecutionBlock:^{
//            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//            if (networkStatus == NotReachable) {
//                
//            } else {
//             [self requestGetUnreadMessages];
//            }
//        }];
//    
//        [saveToDataBaseOperation addDependency:downloadOperation];
    
     //   [[NSOperationQueue mainQueue] addOperation:saveToDataBaseOperation];
    [[NSOperationQueue mainQueue] addOperation:downloadOperation];
    }
}

- (void)getChatList
{
     NSLog(@"Checkkk: Get chat list Start!!");
    
    NSString  *urlPath    = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/chat_box_contacts.php",BASEURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"fb_id=%@",[defaults stringForKey:@"fb_id"]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:data completionHandler:^(NSError *error, NSDictionary *result) {
        
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            // This is the expected result
            NSLog(@"Checkkk: Get chat list Matches result : %@", result);
            if (result.count >0) {
                if ([result[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    if (result[@"result"] != [NSNull null]) {
                        
                        
                        chats = result[@"result"];
                        if (chats.count > 0) {
                         
                            
                            [self requestGetUnreadMessages];
                            NSLog(@"Checkkk: request Get Unread message called!!");
                            
                        }
                    }
                    
                }else{
                    
                }
            }
            
            
        }
        
    }];
    
}

- (void)requestGetUnreadMessages
{
    NSLog(@"Checkkk: request Get Unread message strtrt!!");

    for (NSDictionary *dict in chats) {
    NSString * urlString = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/get_unread_msg_count.php",BASEURL];
    NSURL * url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
    [request1 setHTTPMethod:@"POST"];
    [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString stringWithFormat:@"from_fb_id=%@&to_fb_id=%@",[defaults stringForKey:@"fb_id"],dict[@"facebookid"]];
    NSLog(@"Checkk: unread message alert = %@",string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    request1.accessibilityValue = dict[@"facebookid"];
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
                     NSLog(@"Checkkkk: unreadMessages: %@", unreadMessages);
                    [[self chatCounts] setObject:[NSString stringWithFormat:@"%@",unreadMessages[@"unreadmessages_count"]] forKey:request1.accessibilityValue];
                 }
                 else
                 {
                     
                 }
                 
             }
         }
         
     }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATECHATCOUNT" object:nil];
    
}

- (void)requestGoOnline:(NSString *)status
{
        NSString * urlString = [NSString stringWithFormat:@"http://%@/tinzapp_webservices/onlinestatus.php",BASEURL];
        NSURL * url = [NSURL URLWithString: urlString];
        
        NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL: url];
        [request1 setHTTPMethod:@"POST"];
        [request1 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *string = [NSString stringWithFormat:@"fb_id=%@&status=%@",[defaults stringForKey:@"fb_id"],status];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        request1.HTTPBody = data;
        [NSURLConnection sendAsynchronousRequest:request1
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
         {
             
             NSDictionary * onlineStatus = nil;
             
             
             if([data1 length] >= 1) {
                 onlineStatus = [NSJSONSerialization JSONObjectWithData:data1 options: 0 error: nil];
                 
                 if(onlineStatus != nil) {
                     
                     if ([onlineStatus[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                       
                     }
                     else
                     {
                         
                     }
                     
                 }
             }
             
         }];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.freelancer.Twozapp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Twozapp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Twozapp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    location = newLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    location = [locations lastObject];
}


@end
