//
//  allChatListViewController.h
//  Twozapp
//
//  Created by Apple on 23/12/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface allChatListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewChatList;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) NSString *typeUser;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftMenu;

@end
