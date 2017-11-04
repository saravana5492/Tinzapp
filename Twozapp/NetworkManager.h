#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkManager : NSObject

+ (id)sharedManager;

@property (nonatomic) Reachability *internetReachability;

- (void)getvalueFromServerForURL:(NSString *)path
                     withMessage:(NSDictionary *)messageBody
               completionHandler:(void (^)(NSError *, NSDictionary *))handler;
- (void)getvalueFromServerWithGetterForURL:(NSString *)path
                         completionHandler:(void (^)(NSError *, NSDictionary *))handler;
- (void)getvalueFromServerForOTPForURL:(NSString *)path
                           withMessage:(NSDictionary *)messageBody
                     completionHandler:(void (^)(NSError *, NSDictionary *))handler;
- (void)getvalueFromServerForURL:(NSString *)path
                 withDataMessage:(NSData *)messageBody
               completionHandler:(void (^)(NSError *, NSDictionary *))handler;
- (void)getvalueFromServerForGetterURL:(NSString *)path
                     completionHandler:(void (^)(NSError *, NSDictionary *))handler;
@end
