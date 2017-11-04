//
//  DetailViewController.h
//  Twozapp
//
//  Created by Priya on 16/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFriends.h"
#import "StarRatingView.h"

@interface DetailViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewProfile;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIView *viewBazi;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *starRating;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *viewChat;
@property (weak, nonatomic) IBOutlet UIView *viewMatch;
@property (strong, nonatomic) UserFriends *selecteduserFriend;
@property (strong, nonatomic) NSString *typeUser;
@property (weak, nonatomic) IBOutlet UIView *viewProfileContent;
- (IBAction)actionChat:(id)sender;
- (IBAction)actionMatch:(id)sender;
- (IBAction)actionShowPhotos:(id)sender;
@end
