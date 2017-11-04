//
//  ConnectFacebookViewController.h
//  Twozapp
//
//  Created by Priya on 09/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

@interface ConnectFacebookViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewFacebook;
- (IBAction)actionFacebook:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *acceptTCBtn;
@property (strong, nonatomic) IBOutlet UILabel *acceptTVLbl;

@property (strong, nonatomic) IBOutlet UIButton *showTCBtn;
@property (strong, nonatomic) IBOutlet UIImageView *acceptImgView;


@end
