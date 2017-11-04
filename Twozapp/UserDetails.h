//
//  UserDetails.h
//  Twozapp
//
//  Created by Dipin on 20/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject


@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *descriptions;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fb_id;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *logitude;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *birthtime;
@property (nonatomic, strong) NSString *profilepicture;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *lookingfor;
@property (nonatomic, strong) NSString *bazivalue1;
@property (nonatomic, strong) NSString *bazivalue2;
@property (nonatomic, strong) NSString *bazivalue3;
@property (nonatomic, strong) NSString *bazivalue4;
@property (nonatomic, strong) NSString *bazivalue5;
@property (nonatomic, strong) NSString *bazivalue6;
@property (nonatomic, strong) NSString *bazivalue7;
@property (nonatomic, strong) NSString *bazivalue8;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *devicetoken;
@property (nonatomic, strong) NSString *datingid;
@property (nonatomic, strong) NSString *keyword1;
@property (nonatomic, strong) NSString *keyword2;
@property (nonatomic, strong) NSString *keyword3;
@property (nonatomic, strong) NSString *keyword4;
@property (nonatomic, strong) NSString *keyword5;
@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong) NSString *image1;
@property (nonatomic, strong) NSString *image2;
@property (nonatomic, strong) NSString *image3;
@property (nonatomic, strong) NSString *profileDistance;



+ (UserDetails *)sharedInstance;

- (void)clearUserDetails;

@end
