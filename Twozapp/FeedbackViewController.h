//
//  FeedbackViewController.h
//  Twozapp
//
//  Created by Dipin on 23/03/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaceHolderTextView.h"

@interface FeedbackViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PaceHolderTextView *txtView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSend;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftMenu;

@end
