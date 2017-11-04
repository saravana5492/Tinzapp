//
//  NSDate+Occurance.m
//  Twozapp
//
//  Created by Dipin on 21/02/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import "NSDate+Occurance.h"

@implementation NSDate (Occurance)

-(BOOL) _occuredDaysBeforeToday:(NSUInteger) nDaysBefore
{
    NSDate *now = [NSDate date];  // now
    NSDate *today;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit // beginning of this day
                                    startDate:&today // save it here
                                     interval:NULL
                                      forDate:now];
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = -nDaysBefore;      // lets go N days back from today
    NSDate * before = [[NSCalendar currentCalendar] dateByAddingComponents:comp
                                                                    toDate:today
                                                                   options:0];
    if ([self compare: before] == NSOrderedDescending) {
        if ( [self compare:today] == NSOrderedAscending ) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checksameWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekOfYear;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSDateComponents *otherComponents = [calendar components:unitFlags fromDate:self];
    
    return ( [components yearForWeekOfYear] == [otherComponents yearForWeekOfYear] && [components weekOfYear] == [otherComponents weekOfYear] );}


-(BOOL) dayOccuredDuringLast7Days
{
    return [self _occuredDaysBeforeToday:7];
}

-(BOOL) dayWasYesterday
{
    return [self _occuredDaysBeforeToday:1];
}

-(BOOL) dayWasToday
{
    return [self _occuredDaysBeforeToday:0];
}

@end
