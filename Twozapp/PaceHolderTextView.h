//
//  PaceHolderTextView.h
//  Yoturf
//
//  Created by Dipin on 11/6/13.
//  Copyright (c) 2013 Openwave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

