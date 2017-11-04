//
//  ChatTableViewCell.h
//  Twozapp
//
//  Created by Dipin on 01/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *txtContent;
@property (nonatomic, strong) UILabel *lblSenderName;
@property (nonatomic, strong) UIImageView *imgBackground;
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UIImageView *imgArrow;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
