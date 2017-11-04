//
//  MyIconDownloader.h
//  Twozapp
//
//  Created by Dipin on 15/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserDetails.h"
@protocol MyIconDownloaderDelegate <NSObject>

@optional
- (void)appDidDownloadImage;
- (void)appDidDownloadImagewithURl:(NSString *)url;
- (void)appDidDownloadImagewithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyIconDownloader : NSObject
{
    UserDetails *userDetails;
    NSIndexPath *indexPathinCollectionView;
    NSInteger selectedtag;
    NSString *url;
    NSURLConnection *imageConnection;
    NSMutableData *activeDownload;
}

@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSIndexPath *indexPathinCollectionView;
@property (nonatomic, assign) NSInteger selectedtag;
@property (nonatomic, strong)  NSString *url;
@property (nonatomic, weak) id <MyIconDownloaderDelegate> delegateProduct;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end
