#import "NetworkManager.h"

@implementation NetworkManager

+ (id)sharedManager {
    static NetworkManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)getvalueFromServerForURL:(NSString *)path
                     withMessage:(NSDictionary *)messageBody
               completionHandler:(void (^)(NSError *, NSDictionary *))handler {
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSURL   *url = [NSURL URLWithString:path];
        
        NSError *error;
        NSData  *data = [NSJSONSerialization dataWithJSONObject:messageBody
                                                        options:kNilOptions
                                                          error:&error];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];

        [request setHTTPBody:data];
        
        NSError *networkError;
        NSData  *responseData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:nil
                                                                  error:&networkError];
        NSDictionary *response;
        if(networkError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(networkError, @{});
            });
            
        } else {
            
            // know JSON Response
            response = [NSJSONSerialization JSONObjectWithData:responseData
                                                       options:NSJSONReadingAllowFragments |NSJSONReadingMutableContainers
                                                         error:&error];
            
            if(error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, @{});
                });

                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, response);
                });
            }
        }
    }); 
}

- (void)getvalueFromServerForURL:(NSString *)path
                     withDataMessage:(NSData *)messageBody
               completionHandler:(void (^)(NSError *, NSDictionary *))handler {
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSURL   *url = [NSURL URLWithString:path];
        
        NSError *error;
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:messageBody];
        
        NSError *networkError;
        NSData  *responseData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:nil
                                                                  error:&networkError];
        NSDictionary *response;
        if(networkError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(networkError, @{});
            });
            
        } else {
            
            // know JSON Response
            response = [NSJSONSerialization JSONObjectWithData:responseData
                                                       options:NSJSONReadingAllowFragments |NSJSONReadingMutableContainers
                                                         error:&error];
            
            if(error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, @{});
                });
                
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, response);
                });
            }
        }
    }); 
}

- (void)getvalueFromServerWithGetterForURL:(NSString *)path
               completionHandler:(void (^)(NSError *, NSDictionary *))handler {
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSURL   *url = [NSURL URLWithString:path];
        
        NSError *error;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSError *networkError;
        NSData  *responseData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:nil
                                                                  error:&networkError];
        NSDictionary *response;
        if(networkError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(networkError, @{});
            });
            
        } else {
            
            response = [NSJSONSerialization JSONObjectWithData:responseData
                                                       options:kNilOptions
                                                         error:&error];
            
            if(error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, @{});
                });
                
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, response);
                });
            }
        }
    }); 
}

- (void)getvalueFromServerForGetterURL:(NSString *)path
               completionHandler:(void (^)(NSError *, NSDictionary *))handler {
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSURL   *url = [NSURL URLWithString:path];
        
        NSError *error;
//        NSData  *data = [NSJSONSerialization dataWithJSONObject:messageBody
//                                                        options:kNilOptions
//                                                          error:&error];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        //[request setHTTPBody:data];
        
        NSError *networkError;
        NSData  *responseData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:nil
                                                                  error:&networkError];
        NSDictionary *response;
        if(networkError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(networkError, @{});
            });
            
        } else {
            
            response = [NSJSONSerialization JSONObjectWithData:responseData
                                                       options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                                         error:&error];
            
            if(error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, @{});
                });
                
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(error, response);
                });
            }
        }
    }); 
}





@end
