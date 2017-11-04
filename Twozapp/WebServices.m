//
//  WebServices.m
//  Session
//
//  Created by Priyanka on 10/1/15.
//  Copyright (c) 2015 Openwave. All rights reserved.
//

#import "WebServices.h"
#import "HelpDesk.h"
#import "OnDeck.h"

// OWc
//static const NSString *baseURL = @"http://owcprojects.com/gymnadz_web/api/";
//
//static const NSString *baseURL = @"http://192.9.200.10/gymnadz_web/api/";

// Public 10 Server URL
//static const NSString *baseURL = @"http://124.124.73.180/gymnadz_web/api/";
// Live Server
//static const NSString *baseURL = @"http://104.155.69.233/gymnadz_web/api/";


//Live Server Path

static const NSString *baseURL = @"http://mobileapp.gymnadz.net/gymnadz_web/api/";


@implementation WebServices
@synthesize webRequestMode;

+ (WebServices *)sessionSharedInstance{
    static WebServices *sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[WebServices alloc] init];
    });
    
    return sharedInstance;
}

- (void) composewebrequestmode:(NSMutableDictionary *)args withwebRequestMode:(WebRequestMode *)webRequestMode responseWithStatus:(void (^)(NSMutableArray *))handler{
    NSString *webRequest;
    
    switch ((int)[WebServices sessionSharedInstance].webRequestMode) {
            
        case WEB_REQUEST_REGISTER:{
            
            webRequest = [NSString stringWithFormat:@"action=register&name=%@&email=%@&password=%@&instagram_account=%@&is_accept=%@&membership=basic&payment_id=%@&payment_status=1&auto_renewal=%@&device_token=%@",[args objectForKey:@"name"],[args objectForKey:@"email"],[args objectForKey:@"password"],[args objectForKey:@"instagramName"],[args objectForKey:@"isAccept"],[args objectForKey:@"payment_id"],[args objectForKey:@"renew"],[args objectForKey:@"device_token"]];

        }
            break;
            
            
        case WEB_REQUEST_LOGIN:
        {
            webRequest = [NSString stringWithFormat:@"action=login&email=%@&password=%@&device_token=%@",[args objectForKey:@"email"],[args objectForKey:@"password"],[args objectForKey:@"device_token"]];
        }
            break;

            
            
        default:
            break;
    }
     NSLog(@"webrequest = %@",webRequest);
    [[WebServices sessionSharedInstance] composedWebRequest:webRequest dataAfterEncryption:^(NSData *encryptedData){
        [[WebServices sessionSharedInstance] postWebRequest:encryptedData responseFromServer:^(NSMutableDictionary *jsonDict){
            
            [[WebServices sessionSharedInstance] getValuesFromResponse:jsonDict forWebRequestMode:[WebServices sessionSharedInstance].webRequestMode withTheStatus:^(NSMutableArray *status){
                handler(status);
                
            }];
            
        }];
    }];
    
  }

- (void)composedWebRequest:(NSString *)webRequest dataAfterEncryption:(void (^)(NSData *))handler{
    {
        
        
        NSData *postData = [webRequest dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
       
        
        //Passes the encrypted data to the handler
        handler(postData);
    }
}

- (void)postWebRequest:(NSData *)postData responseFromServer:(void (^)(NSMutableDictionary *))handler{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseURL]];
    NSLog(@"URL%@",url );
    NSString *postlength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSURLSessionDataTask *urlSession = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error){
        
        if (responseData == nil) {
            NSLog (@"Error = %@",responseData);
        }
        else{
        NSString *jsonstring = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonstring = %@",jsonstring);
            
            NSData *data = [jsonstring dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *myError = nil;
        NSMutableDictionary *parsedResonse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
        handler(parsedResonse);
        }
        
    }];
    [urlSession resume];

}

- (void)getValuesFromResponse:(NSMutableDictionary *)withResponse forWebRequestMode:(WebRequestMode *)webReqMode withTheStatus:(void (^)(NSMutableArray *))handler{
    
    
    switch ((int)[WebServices sessionSharedInstance].webRequestMode) {
            
        case WEB_REQUEST_LOGIN:{
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *dictBanners = [[NSMutableDictionary alloc] init];
            
            if ([[withResponse objectForKey:@"error"] isEqualToString:@"OWCE00"]){
                for(id key in withResponse) {
                    if ([key isEqualToString:@"error"]){
                        //Do nothing continue the next iteration
                        continue;
                    }else{
                        
                        [OnDeck sharedInstance].strName = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"name"]];
                        [OnDeck sharedInstance].strEmail = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"email"]];
                        
                        
                    }
                }
                
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Success"];
                [arraySucess addObject:dictBanners];
                
                handler(arraySucess);
                
                return;
            }
            else if ([[withResponse objectForKey:@"error"] isEqualToString:@"OWCE02"]){
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Invalid Email"];
                
                handler(arraySucess);
                
                
                return;
            }
            else{
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Failure"];
                
                handler(arraySucess);
                
                return;
            }
        }
            break;
            
            
        case WEB_REQUEST_REGISTER:{
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *dictBanners = [[NSMutableDictionary alloc] init];
            
            if ([[withResponse objectForKey:@"error"] isEqualToString:@"OWCE00"]){
                for(id key in withResponse) {
                    if ([key isEqualToString:@"error"]){
                        //Do nothing continue the next iteration
                        continue;
                    }else{
                        
                        [OnDeck sharedInstance].strName = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"name"]];
                        [OnDeck sharedInstance].strEmail = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"email"]];
//                        [OnDeck sharedInstance].strUserId = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"id"]];
//                        [OnDeck sharedInstance].instagramAccount = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"instagram_account"]];
//                        [OnDeck sharedInstance].membershipStatus = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"expiryremainder"]];
//                        [OnDeck sharedInstance].postStatus = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"new_posts"]];
//                        [OnDeck sharedInstance].iAPTransactionDate = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"modified"]];
//                        [OnDeck sharedInstance].iAPTransactionId = [[HelpDesk sharedInstance] getStringByEliminatingNull:[withResponse objectForKey:@"payment_id"]];
                        
                    }
                }
                
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Success"];
                [arraySucess addObject:dictBanners];
                
                handler(arraySucess);
                
                return;
            }
            else if ([[withResponse objectForKey:@"error"] isEqualToString:@"MESSAGE_EMAIL_EXSITS"]){
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Email Exist"];
                
                handler(arraySucess);
                
                
                return;
            }
            else{
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Failure"];
                
                handler(arraySucess);
                
                return;
            }
            
        }
            break;
            
        
            
        default:
            break;
    }
}

@end
