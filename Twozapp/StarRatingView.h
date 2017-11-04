//
//  StarRatingView.h
//  StarRatingDemo
//
//  Created by HengHong on 5/4/13.
//  Copyright (c) 2013 Fixel Labs Pte. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol StarRatingDelegate <NSObject>

- (void)getTheRating:(NSInteger)rating;

@end

@interface StarRatingView : UIView

@property (nonatomic,assign) int rating;
@property (nonatomic, weak) id <StarRatingDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated;
@end