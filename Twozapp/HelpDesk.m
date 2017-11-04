
//
//  HelpDesk.m
//  WayFinder
//
//  Created by Openwave Computing on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  HelpDesk Class by Ahshif Abdeen 

#import "HelpDesk.h"

@implementation HelpDesk

@synthesize device;
@synthesize requestObject;
@synthesize alertOkButtonPressed;

#pragma mark - Singleton methods

+ (HelpDesk*)sharedInstance
{
    static HelpDesk *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[[self class] alloc] init];
        
        
        //Set the device value here 
        
        if ([sharedInstance isDeviceiPad]){
            sharedInstance.device = @"iPad";
        }else{
            if ([sharedInstance isDeviceiPodTouch]){
                sharedInstance.device = @"iPod";
                
            }else{
                sharedInstance.device = @"iPhone";
            }
            
        } 
    });
    return sharedInstance;
    
}


#pragma mark - Validation of Strings


- (BOOL)isFieldEmpty:(NSString *)string{
    
    if ([[self trimSpaces:string] length] <= 0){
        
        return YES;
        
    }
    return  NO; 
    
}

- (NSString *)trimSpaces:(NSString *)string{
    
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (BOOL)isEmailValid:email{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isPhoneNumberValid:(id)number{
    
    NSString *phoneRegex = @"[0-9+-]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:number];
    return isValid;
    
}





- (BOOL)isPasswordSame:(NSString *)password confirmPassword:(NSString *)confirmPassword{

    if ([password compare:confirmPassword] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
    
}

- (BOOL)isStringGreaterThanSixCharacters:(NSString*)string{
    if ([string length]>=6) {
        return YES;
    }
    return NO;
}

//Username Validation goes here

- (BOOL)isValidFirstName:strSource{
    NSString *usernameRegex = @"[A-Z-a-z- ]+";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL isValid = [usernameTest evaluateWithObject:strSource];
    return isValid;
}
- (BOOL)isValidLastName:strSource{
    NSString *LastnameRegex = @"[A-Z-a-z- ]+";
    NSPredicate *LastnameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",LastnameRegex ];
    BOOL isValid = [LastnameTest evaluateWithObject:strSource];
    return isValid;
}


- (BOOL)isValidGroupName:strSource{
    NSString *usernameRegex = @"[A-Z-a-z-0-9 ]+";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL isValid = [usernameTest evaluateWithObject:strSource];
    return isValid;
}

- (BOOL)isValidMobileNumber:strSource{
    
    NSString *usernameRegex =  @"^([0-9]+)?([\\,\\.]([0-9]{1,2})?)?$";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL isValid = [usernameTest evaluateWithObject:strSource];
    return isValid;
}


#pragma mark - Internet Stuff

- (BOOL)isInternetAvailable{

    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        internet = NO;
    } else {
        internet = YES;
    }
    return internet;
}

- (void)alertUserAboutNetwork{
    //Check Internet Connection and Alert
    if (![[HelpDesk sharedInstance] isInternetAvailable]) {
//        [[SlideAlert sharedSlideAlert] emergencyHideSlideAlertView];
//        [[SlideAlert sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Network Offline"];
    }
}

- (BOOL)validateUrl:(NSString *)url{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}

#pragma mark - Web Service Encryption

- (NSString *)getMD5Hash:(NSString *)string{
    
    return [string MD5];
    
}

- (NSString *)getBase64:(NSString *)string{
    
    [Base64 initialize];
    
    NSData *stringData = [string dataUsingEncoding:NSASCIIStringEncoding];
    return [Base64 encode:stringData];
    
}

- (NSString *)getBase64ForTamilText:(NSString *)string{
    
    [Base64 initialize];
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [stringData base64EncodedStringWithOptions:0];
    
    return base64String;
    
}

#pragma mark - Device Check


- (BOOL)isDeviceiPad{
    
#ifdef UI_USER_INTERFACE_IDIOM
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}

- (BOOL)isDeviceiPodTouch{
    
    //iPhone Simulator
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]){
        return NO;
    }else
        return YES;
}

- (BOOL)isiOS4Installed{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if([version floatValue ] >= 4.0){
        return YES;
    }
    return NO;
    
}

#pragma mark - Alerts

- (void)showConfirmaionAlert:(NSString *)title withMessage:(NSString *)message forRequestedObject:(id)reqObject{
    self.requestObject = reqObject;
    UIAlertView *confirmationMessage = [[UIAlertView alloc] initWithTitle:title  
                                                                  message:message  
                                                                 delegate:self  
                                                        cancelButtonTitle:@"Cancel"  
                                                        otherButtonTitles:@"Ok",nil];  
    [confirmationMessage show];  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            self.alertOkButtonPressed = NO;
            break;
        case 1:
            self.alertOkButtonPressed = YES;
            break;
        default:
            break;
    }
    
    //Return back the control to requested object 
   // [requestObject performSelectorOnMainThread:@selector(alertConfirmationDelegate) withObject:nil waitUntilDone:YES];
}

#pragma mark - Smart Functions

- (void)scrollViewAnimation:(UIScrollView*)scrollView pointX:(float)xOffset pointY:(float)yOffset{
    //Set ScrollView Animation
    [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
    [UIScrollView setAnimationDuration:0.1];
    [scrollView setContentOffset:CGPointMake(xOffset, yOffset)];
    [UIScrollView commitAnimations];
}

- (NSString *)getStringByEliminatingNull:(NSString *)string{
    return (NSString*)string == (NSString*)[NSNull null] ? @"" : string;
}

#pragma mark - Get Maximum date

- (NSDate *)getMaximumDateForDatePicker{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //Set the year for the user to select only older than 18; Reduce 18 from the current date and show to the user
    [comps setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    return maxDate;
}

- (NSString*)convertMMMdyyyy:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"MMM d, yyyy"];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat2 stringFromDate:date1];
}

- (NSString*)convertyyyyMMdd:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMM d, yyyy"];    
    return [dateFormat2 stringFromDate:date1];
}

- (NSString*)convertMediumStyle:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMM d, yyyy"];    
    return [dateFormat2 stringFromDate:date1];
}

//2012-11-28 15:41:12
- (NSString*)convertFromWebServiceDateAndTime:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMM d, yyyy HH:mm "];    
    return [dateFormat2 stringFromDate:date1];
}

-(BOOL)isValidString:(NSString *)string
{
    return YES;
}

- (void)requestPUSHNotification{
    
    
//    NSString *reqMode = @"Get User Notification";
//    
//    
//    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
//    //[arguments setObject:[OnDeck sharedInstance].userID forKey:@"user_id"];
//    
//    [WebServices sharedInstance].webRequestBackGroundMode = (WebRequestMode *)WEB_REQUEST_PUSH_NOTIFICATIONS;
//    [[WebServices sharedInstance] composeWebRequestFromArguments:arguments webRequestBackGroundMode:[WebServices sharedInstance].webRequestBackGroundMode responseWithStatus:^(NSString *status){
//        // Stop Loading
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        if ([status compare:@"Success"] == NSOrderedSame) {
//            NSLog(@"%@ - Success", reqMode);
//            
//        }
//        else{
//            NSLog(@"%@ - Failure", reqMode);
//        }
//    }];
//    
    
    
}

//- (void)requestInviteUsers:(NSMutableDictionary *)arguments{
//    
//    
//    NSString *reqMode = @"Get User Notification";
//    
//    [WebServices sharedInstance].webRequestBackGroundMode = (WebRequestMode *)WEB_REQUEST_INVITE_USERS;
//    [[WebServices sharedInstance] composeWebRequestFromArguments:arguments webRequestBackGroundMode:[WebServices sharedInstance].webRequestBackGroundMode responseWithStatus:^(NSString *status){
//        // Stop Loading
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        if ([status compare:@"Success"] == NSOrderedSame) {
//            NSLog(@"%@ - Success", reqMode);
//            
//        }
//        else{
//            NSLog(@"%@ - Failure", reqMode);
//        }
//    }];
//    
//    
//
//    
//}


#pragma mark - Caching Images Stuff

- (NSString *)composedNameForImageCache:(NSString *)url{
    NSString *composedName = url;
    composedName = [composedName stringByReplacingOccurrencesOfString:@"/"  withString:@""];
    composedName = [composedName stringByReplacingOccurrencesOfString:@"."  withString:@""];
    composedName = [composedName stringByReplacingOccurrencesOfString:@":"  withString:@""];
    composedName = [composedName stringByReplacingOccurrencesOfString:@"-"  withString:@""];
    composedName= [NSString stringWithFormat:@"%@%@",composedName,@".png"];
    return composedName;
}

- (void)saveImageToCache:(UIImage *)image withName:(NSString *)name{
    NSString *composedName = [self composedNameForImageCache:name];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:composedName];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    // NSLog(@"Saved Path - %@", fullPath);
}

- (UIImage *)loadImageFromCache:(NSString *)name{
    NSString *composedName = [self composedNameForImageCache:name];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:composedName];
    UIImage *result = [UIImage imageWithContentsOfFile:fullPath];
    
    // Threshold Logic
    // NSLog(@"Loaded Path - %@", fullPath);
    
    // NSLog(@"files array %@", filePathsArray);
    // NSLog(@"files array %i", filePathsArray.count);
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:documentsDirectory error:nil][NSFileSize] unsignedLongLongValue];
    // NSLog(@"File Size - %llu Bytes, %llu kb, %llu mb", fileSize, fileSize/1024, fileSize/(1024*1024));
    
    unsigned long long fileSizeInMB = fileSize/(1024*1024);
    if (fileSizeInMB>30) {
        NSMutableArray *fileArray = [[NSMutableArray alloc] init];
        
        NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
        
        for (NSString *path in directoryEnumerator) {
            if ([[path pathExtension] isEqualToString:@"png"]){
                NSMutableDictionary *fileDict = [[NSMutableDictionary alloc] init];
                [fileDict setObject:path forKey:@"path"];
                [fileDict setObject:[directoryEnumerator fileAttributes] forKey:@"attributes"];
                [fileArray addObject:fileDict];
            }
        }
        
        [fileArray sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
            NSDate *date1 = [[a objectForKey:@"attributes"] objectForKey: @"NSFileCreationDate"];
            NSDate *date2 = [[b objectForKey:@"attributes"] objectForKey: @"NSFileCreationDate"];
            return [date1 compare:date2];
        }];
        
        if (fileArray.count>0)
            [self removeImageFromCacheWithName:[[fileArray objectAtIndex:0] objectForKey:@"path"]];
    }
    return result;
    
}

- (void)removeImageFromCache:(NSString *)nameWithSymbols{
    NSString *composedName = [self composedNameForImageCache:nameWithSymbols];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:composedName];
    [fileManager removeItemAtPath:fullPath error:nil];
    
    NSLog(@"Removed Path - %@", fullPath);
}

- (void)removeImageFromCacheWithName:(NSString *)fileName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:fullPath error:nil];
    
    NSLog(@"Removed Path - %@", fullPath);
}



@end
