//
//  OnDeck.m
//  GDSWayFinder
//
//  Created by Openwave Computing on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnDeck.h"

@implementation OnDeck

@synthesize refPresntedVC;

@synthesize strPanic;
@synthesize isDeviceOrSimulator;
@synthesize isserviceCompleted;
@synthesize userPreferences;

@synthesize strName;
@synthesize strEmail;
@synthesize strGender;
@synthesize strLookingfor;
@synthesize strBirthday;
@synthesize strBirthtime;
@synthesize strHeight;
@synthesize strWeight;
@synthesize strDistance;
@synthesize dictImages;

#pragma mark - Singleton methods

+ (OnDeck*)sharedInstance
{
    static OnDeck *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[[self class] alloc] init];
        
       
#if TARGET_IPHONE_SIMULATOR
        sharedInstance.isDeviceOrSimulator = YES;
#else
        sharedInstance.isDeviceOrSimulator = NO;
#endif
        
        sharedInstance.userPreferences = [NSUserDefaults standardUserDefaults];
        sharedInstance.dictImages = [[NSMutableDictionary alloc] init];
        

    });
    return sharedInstance;
}

#pragma mark - Auto Sign In

- (void)loadUserInfo{
    
    self.strEmail = [userPreferences stringForKey:@"email"] == nil ? @"" : [userPreferences stringForKey:@"email"];
   // self.strPassword = [userPreferences stringForKey:@"password"] == nil ? @"" : [userPreferences stringForKey:@"password"];
    self.strName = [userPreferences stringForKey:@"name"] == nil ? @"" : [userPreferences stringForKey:@"name"];
}

- (BOOL)isUserAlreadyExists{
    
    self.strEmail = [userPreferences stringForKey:@"email"] == nil ? @"" : [userPreferences stringForKey:@"email"];
    //self.strPassword = [userPreferences stringForKey:@"password"] == nil ? @"" : [userPreferences stringForKey:@"password"];
    self.strName = [userPreferences stringForKey:@"name"] == nil ? @"" : [userPreferences stringForKey:@"name"];
   // NSLog(@"self.userEmail = a%@b and self.userPassword = a%@b",self.strEmail,self.strPassword);
//    if (![self.strEmail  isEqual: @""] && ![self.strPassword  isEqual:@""] ){
//        //User Already Exists
//        return YES;
//    }
//    else {
//        return NO;
//    }
    return NO;
    
   // && ![self.accountType  isEqual:@""
    
}//End of isUserAlreadyLogged method

- (void)setAutoSignIn{
    
    //Store User Information into the device
    [userPreferences setObject:self.strEmail forKey:@"email"];
   // [userPreferences setObject:self.strPassword forKey:@"password"];
    [userPreferences setObject:self.strName forKey:@"name"];
    
    
    //Saving
    [userPreferences synchronize];
}

- (void)signOutUser{
    //Clearing the user preferences
    [userPreferences setObject:@"" forKey:@"email"];
    [userPreferences setObject:@"" forKey:@"password"];
    [userPreferences setObject:@"" forKey:@"name"];
    
    
    [userPreferences synchronize];
    //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)clearOnDeck
{
     strName = @"";
     strEmail = @"";
     strGender = @"";
     strLookingfor = @"";
     strBirthday = @"";
     strBirthtime = @"";
     strHeight= @"";
     strWeight = @"";
     strDistance = @"";
     [dictImages removeAllObjects];
    
}

@end
