//
//  MainViewController.h
//  Twozapp
//
//  Created by Priya on 10/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"
#import "allChatUsers.h"
#import "IconDownloaderImage.h"

@interface MainViewController : UIViewController<DraggableViewDelegate, IconDownloaderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfilePic;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *viewBazi;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOnline;
@property (weak, nonatomic) IBOutlet UIButton *btnNotIntrested;
@property (weak, nonatomic) IBOutlet UIButton *btnIntrested;
@property (weak, nonatomic) IBOutlet UIView *viewProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblnoUsers;

- (IBAction)actionSideMenu:(id)sender;
- (IBAction)actionNotIntrested:(id)sender;
- (IBAction)actionIntrested:(id)sender;



@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftMenu;

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards;



@end
