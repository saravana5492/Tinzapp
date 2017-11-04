//
//  ChatTableViewCell.m
//  Twozapp
//
//  Created by Dipin on 01/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell


@synthesize userImage;
@synthesize lblSenderName;
@synthesize txtContent;
@synthesize imgBackground;
@synthesize imgArrow;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        userImage.layer.cornerRadius = 30.0f;
        userImage.layer.masksToBounds = YES;
        
        imgArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        imgBackground = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgBackground.layer.cornerRadius = 8.0;
        [imgBackground.layer setMasksToBounds:YES];
        imgBackground.contentMode = UIViewContentModeScaleAspectFill;
        
        txtContent = [[UITextView alloc] initWithFrame:CGRectZero];
        txtContent.font = [UIFont systemFontOfSize:13];
        txtContent.textColor = [UIColor blackColor];
        txtContent.textAlignment = NSTextAlignmentLeft;
        
        txtContent.backgroundColor = [UIColor clearColor];
        txtContent.editable = NO;
        txtContent.selectable = NO;
        
        txtContent.scrollEnabled = NO;
        txtContent.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        [txtContent sizeToFit];
        [txtContent layoutIfNeeded];
        txtContent.clipsToBounds = NO;
        txtContent.dataDetectorTypes = UIDataDetectorTypeAll;
        
        lblSenderName = [[UILabel alloc] initWithFrame:CGRectZero];
        lblSenderName.font = [UIFont systemFontOfSize:14];
        lblSenderName.textColor = [UIColor colorWithRed:206.0/255.0 green:27.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        [self.contentView addSubview:imgArrow];
        [self.contentView addSubview:userImage];
        [self.contentView addSubview:imgBackground];
        [self.contentView addSubview:txtContent];
        [self.contentView addSubview:lblSenderName];
        
        
    }
    return self;
}
@end
