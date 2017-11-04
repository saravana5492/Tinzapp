//
//  ReportViewController.h
//  Twozapp
//
//  Created by Dipin on 17/03/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFriends.h"
#import "PaceHolderTextView.h"

@interface ReportViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PaceHolderTextView *txtView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (nonatomic, strong) UserFriends *selectedFriend;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionCancel:(id)sender;

@end
