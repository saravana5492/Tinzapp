//
//  MyProfileViewController.h
//  Twozapp
//
//  Created by Priya on 16/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloaderImage.h"


@interface MyProfileViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagViewMyProfilePic;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
- (IBAction)actionEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionViewIntrest;
- (IBAction)actionShowProfilePic:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftMenu;

@end
