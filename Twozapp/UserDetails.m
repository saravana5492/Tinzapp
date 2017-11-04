//
//  UserDetails.m
//  Twozapp
//
//  Created by Dipin on 20/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "UserDetails.h"

@implementation UserDetails

@synthesize date, descriptions, email, fb_id, gender, latitude, logitude, status;

#pragma mark - Singleton methods

@synthesize dob;
@synthesize full_name;
@synthesize password;
@synthesize birthtime;
@synthesize profilepicture;
@synthesize height;
@synthesize bazivalue1;
@synthesize bazivalue2;
@synthesize bazivalue3;
@synthesize bazivalue4;
@synthesize bazivalue5;
@synthesize bazivalue6;
@synthesize bazivalue7;
@synthesize bazivalue8;
@synthesize weight;
@synthesize devicetoken;
@synthesize datingid;
@synthesize keyword1;
@synthesize keyword2;
@synthesize keyword3;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize profileDistance;

+ (UserDetails*)sharedInstance
{
    static UserDetails *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[[self class] alloc] init];
        
        
    });
    return sharedInstance;
}

- (void)clearUserDetails
{
    date = @"";
    descriptions = @"";
    email = @"";
    fb_id = @"";
    gender = @"";
    latitude = @"";
    logitude = @"";
    status = @"";
     dob = @"";
     full_name = @"";
     password = @"";
     birthtime = @"";
     profilepicture = @"";
     height = @"";
    _lookingfor = @"";
    _keywords = nil;
     bazivalue1 = @"";
     bazivalue2 = @"";
     bazivalue3 = @"";
     bazivalue4 = @"";
     bazivalue5 = @"";
     bazivalue6 = @"";
     bazivalue7 = @"";
     bazivalue8 = @"";
     weight = @"";
     devicetoken = @"";
     datingid = @"";
     keyword1 = @"";
     keyword2 = @"";
     keyword3 = @"";
     image1 = @"";
     image2 = @"";
     image3 = @"";
     profileDistance = @"";
    
}

@end


/*fb_id=954838767953128
firstname=Saravana
email=sarwan5492me@gmail.com
gender=1
looking_for=2
dob=1992-04-05
height=158
weight=63
lat=0.000000
lang=0.000000
profile_image=http://www.rgmobiles.com/tinzapp_webservices/uploads/1492166102.jpg
description=New one created
keyword1=One
keyword2=Two
keyword3=Three
device_token=test
profile_distance=9*/



