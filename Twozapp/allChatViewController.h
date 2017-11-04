//
//  allChatViewController.h
//  Twozapp
//
//  Created by Apple on 28/12/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFriends.h"
#import "PaceHolderTextViewMessage.h"

@interface allChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblChat;
@property (weak, nonatomic) IBOutlet UIView *viewTextView;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
- (IBAction)actionSend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachment;
- (IBAction)actionAttachment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSmiley;
- (IBAction)actionSmiley:(id)sender;

@property (nonatomic, strong) UserFriends *selectedFriend;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableDictionary *sortedMessages;
@property (weak, nonatomic) IBOutlet UIView *viewTextEntry;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpacemessageEntry;

@property (strong, nonatomic) IBOutlet UIView *sendBtnView;



@end
