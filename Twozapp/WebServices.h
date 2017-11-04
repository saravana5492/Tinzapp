//
//  WebServices.h
//  Session
//
//  Created by Priyanka on 10/1/15.
//  Copyright (c) 2015 Openwave. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WEB_REQUEST_REGISTER,
    WEB_REQUEST_LOGIN
    
}WebRequestMode;

@interface WebServices : NSObject{
    WebRequestMode *webRequestMode;
    BOOL base64TamilText;
}

@property (nonatomic, assign) WebRequestMode *webRequestMode;




+(WebServices *) sessionSharedInstance;


- (void)composewebrequestmode:(NSMutableDictionary *)dictionary withwebRequestMode:(WebRequestMode *)webRequestMode responseWithStatus:(void(^)(NSMutableArray *))handler;
- (void)composedWebRequest:(NSString *)webRequest dataAfterEncryption:(void(^)(NSData *))handler;
- (void)postWebRequest:(NSData *)postData responseFromServer:(void(^)(NSMutableDictionary *))handler;
- (void)getValuesFromResponse:(NSMutableDictionary*)withResponse forWebRequestMode:(WebRequestMode *)webReqMode withTheStatus:(void(^)(NSMutableArray *))handler;

@end
