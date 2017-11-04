//
//  MatchesViewController.h
//  Twozapp
//
//  Created by Priya on 10/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloaderImage.h"
#import "UserFriends.h"

@interface MatchesViewController : UIViewController <IconDownloaderDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftMenu;

@end
