//
//  OnDeck.h
//  GDSWayFinder
//
//  Created by Openwave Computing on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpDesk.h"
#import <CoreLocation/CoreLocation.h>

@interface OnDeck : NSObject{
    
    BOOL isDeviceOrSimulator;
}

@property (nonatomic, retain) id refPresntedVC;

@property (nonatomic, retain) NSString *strPanic;

@property (nonatomic, assign) BOOL isDeviceOrSimulator;
@property (nonatomic, assign) BOOL isLanguageChanged;
@property (nonatomic, assign) BOOL isserviceCompleted;

@property (nonatomic, retain) NSString *strDeviceToken;
@property (nonatomic, assign) BOOL isDeviceiPhone5;
@property (nonatomic, retain) NSString *strDeviceVersion;

@property (nonatomic, retain) NSUserDefaults *userPreferences;

@property (nonatomic, retain) NSString *strName;
@property (nonatomic, retain) NSString *strEmail;
@property (nonatomic, retain) NSString *strGender;
@property (nonatomic, retain) NSString *strLookingfor;
@property (nonatomic, retain) NSString *strBirthday;
@property (nonatomic, retain) NSString *strBirthtime;
@property (nonatomic, retain) NSString *strHeight;
@property (nonatomic, retain) NSString *strWeight;
@property (nonatomic, retain) NSString *strDistance;



@property (nonatomic, retain) NSMutableDictionary *dictImages;

- (void)loadUserInfo;
- (BOOL)isUserAlreadyExists;
- (void)setAutoSignIn;
- (void)signOutUser;



+ (OnDeck *)sharedInstance;
- (void)clearOnDeck;




@end
