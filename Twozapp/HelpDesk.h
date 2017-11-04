//
//  HelpDesk.h
//  WayFinder
//
//  Created by Openwave Computing on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>

#import "NSString+MD5.h"
#import "Base64.h"
#import <UIKit/UIKit.h>

@interface HelpDesk : NSObject{
    NSString *device;
    id requestObject;
    BOOL alertOkButtonPressed;
}

@property (nonatomic, retain) NSString *device;
@property (nonatomic, retain) id requestObject;
@property (nonatomic, assign) BOOL alertOkButtonPressed;

+ (HelpDesk *)sharedInstance;

- (BOOL)isFieldEmpty:(NSString *)string;
- (NSString *)trimSpaces:(NSString *)string;
- (BOOL)isEmailValid:email;
- (BOOL)isPhoneNumberValid:number;

- (BOOL)isPasswordSame:(NSString *)password confirmPassword:(NSString *)confirmPassword;
- (BOOL)isStringGreaterThanSixCharacters:(NSString*)string;


- (BOOL)isValidFirstName:strSource;
- (BOOL)isValidLastName:strSource;

- (BOOL)isValidGroupName:strSource;
- (BOOL)isValidMobileNumber:strSource;


- (BOOL)isInternetAvailable;
- (void)alertUserAboutNetwork;
- (BOOL)validateUrl:(NSString *)url;

- (NSString *)getMD5Hash:(NSString *)string;
- (NSString *)getBase64:(NSString *)string;
- (NSString *)getBase64ForTamilText:(NSString *)string;

- (BOOL)isDeviceiPad;
- (BOOL)isDeviceiPodTouch;

- (void)showConfirmaionAlert:(NSString *)title withMessage:(NSString *)message forRequestedObject:(id)reqObject;

- (void)scrollViewAnimation:(UIScrollView *)scrollView pointX:(float)xOffset pointY:(float)yOffset;
- (NSString *)getStringByEliminatingNull:(NSString *)string;

- (NSDate *)getMaximumDateForDatePicker;
- (NSString*)convertMMMdyyyy:(NSString*)dateToBeConverted;
- (NSString*)convertyyyyMMdd:(NSString*)dateToBeConverted;
- (NSString*)convertMediumStyle:(NSString*)dateToBeConverted;
- (NSString*)convertFromWebServiceDateAndTime:(NSString*)dateToBeConverted;
- (BOOL)isValidString:(NSString *)string;

- (void)requestPUSHNotification;

// Image Caching
- (NSString *)composedNameForImageCache:(NSString *)url;
- (void)saveImageToCache:(UIImage *)image withName:(NSString *)name;
- (UIImage *)loadImageFromCache:(NSString *)name;
- (void)removeImageFromCache:(NSString *)name;
- (void)removeImageFromCacheWithName:(NSString *)fileName;

//// Pop Up
//- (void)actionPopUp: (id)sender viewpresent:(UIView *)presentView stringKey:(NSNumber *)keyString;
//- (void)dismissAllPopTipViews;

@property (nonatomic, strong)	NSArray			*colorSchemes;
@property (nonatomic, strong)	NSDictionary	*contents;
@property (nonatomic, strong)	id				currentPopTipViewTarget;
@property (nonatomic, strong)	NSDictionary	*titles;
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;

@end
