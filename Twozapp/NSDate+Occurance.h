//
//  NSDate+Occurance.h
//  Twozapp
//
//  Created by Dipin on 21/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Occurance)

-(BOOL) dayOccuredDuringLast7Days;
-(BOOL) dayWasYesterday;
-(BOOL) dayWasToday;
-(BOOL)checksameWeek;
@end
