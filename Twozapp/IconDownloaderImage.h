//
//  IconDownloaderImage.h
//  Twozapp
//
//  Created by Priya on 30/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserFriends.h"

@protocol IconDownloaderDelegate <NSObject>

@optional
- (void)appDidDownloadImage:(NSIndexPath *)indexpath;
- (void)appDidDownloadImagewithTag:(NSInteger)indexpath;

@end


@interface IconDownloaderImage : NSObject{
UserFriends *userFriends;
NSIndexPath *indexPathinCollectionView;
NSInteger selectedtag;
NSURLConnection *imageConnection;
NSMutableData *activeDownload;
}

@property (nonatomic, retain) UserFriends *userFriends;
@property (nonatomic, retain) NSIndexPath *indexPathinCollectionView;
@property (nonatomic, assign) NSInteger selectedtag;
@property (nonatomic, weak) id <IconDownloaderDelegate> delegateProduct;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end
