//
//  MyIconDownloader.m
//  Twozapp
//
//  Created by Dipin on 15/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "MyIconDownloader.h"
#import "HelpDesk.h"

@implementation MyIconDownloader


- (void)startDownload
{
    // making a data and sending request to url
    self.activeDownload = [NSMutableData data];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_imageURL]] delegate:self];
    
    self.imageConnection = conn;
    
}



- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    //userFriends.appIcon = image;
    [[HelpDesk sharedInstance] saveImageToCache:image withName:_imageURL];
    self.activeDownload = nil;
    
    self.imageConnection = nil;
    if (_url != nil) {
        [self.delegateProduct appDidDownloadImagewithURl:_url];
    }
    else if (indexPathinCollectionView != nil)
    {
        [self.delegateProduct appDidDownloadImagewithIndexPath:indexPathinCollectionView];
    }
    else
    {
        [self.delegateProduct appDidDownloadImage];
    }
    
    
}

@end
