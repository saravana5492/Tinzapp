//
//  ProfileTwoViewController.h
//  Twozapp
//
//  Created by Priya on 11/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnDeck.h"

@interface ProfileTwoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewPRofileTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIButton *addImage1;
@property (weak, nonatomic) IBOutlet UIButton *addImage2;
@property (weak, nonatomic) IBOutlet UIButton *addImagee3;

@property (strong, nonatomic) NSString *actionType;

- (IBAction)actionDeleteFirstImage:(id)sender;
- (IBAction)actionDeleteSecond:(id)sender;
- (IBAction)actionDeleteThird:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UITextView *txtViewTellus;
@property (weak, nonatomic) IBOutlet UITextField *txtFldKeyword;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionViewKeyword;
@property (nonatomic , strong) NSMutableArray *keys;
- (IBAction)actionSave:(id)sender;
- (IBAction)actionAddPhoto1:(id)sender;
- (IBAction)actionPhoto3:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnClose1;
@property (weak, nonatomic) IBOutlet UIButton *btnClose2;
@property (weak, nonatomic) IBOutlet UIButton *btnClose3;
@property (strong, nonatomic) IBOutlet UITextField *profileDist;

- (IBAction)actionAddPhoto2:(id)sender;


@end
