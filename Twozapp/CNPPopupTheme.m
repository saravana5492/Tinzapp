//
//  CNPPopupTheme.m
//  CNPPopupControllerExample
//
//  Created by Carson Perrotti on 2014-09-28.
//  Copyright (c) 2014 Carson Perrotti. All rights reserved.
//

#import "CNPPopupTheme.h"

@implementation CNPPopupTheme

+ (CNPPopupTheme *)defaultTheme {
    CNPPopupTheme *defaultTheme = [[CNPPopupTheme alloc] init];
    defaultTheme.backgroundColor = [UIColor whiteColor];
    defaultTheme.cornerRadius = 6.0f;
    defaultTheme.buttonBackgroundColor = [UIColor colorWithRed:157.0/255.0 green:0 blue:33.0/255.0 alpha:1.0];
    defaultTheme.destructiveButtonBackgroundColor = [UIColor darkGrayColor];
    defaultTheme.buttonHeight = 44.0f;
    defaultTheme.buttonCornerRadius = 6.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
    defaultTheme.popupStyle = CNPPopupStyleCentered;
    defaultTheme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = CNPPopupMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = YES;
    defaultTheme.contentVerticalPadding = 12.0f;
    return defaultTheme;
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
