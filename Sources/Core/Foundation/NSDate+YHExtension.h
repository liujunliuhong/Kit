//
//  NSDate+YHExtension.h
//  Kit
//
//  Created by 银河 on 2018/12/27.
//  Copyright © 2018 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// the week day type.
// In Western countries, Sunday comes first. 1-Sun. 2-Mon. 3-Thes. 4-Wed. 5-Thur. 6-Fri. 7-Sat.
// But in China, Monday comes first.
typedef NS_ENUM(NSUInteger, YHDateWeekType) {
    YHDateWeekTypeMonday,          // Mon.    In China
    YHDateWeekTypeTuesday,         // Thes.   In China
    YHDateWeekTypeWednesday,       // Wed.    In China
    YHDateWeekTypeThursday,        // Thur.   In China
    YHDateWeekTypeFriday,          // Fri.    In China
    YHDateWeekTypeSaturday,        // Sat.    In China
    YHDateWeekTypeSunday,          // Sun.    In China
};

@interface NSDate (YHExtension)

// date components.
// year, month, day, hour, minute, second, weekday.
@property (nonatomic, strong, readonly) NSDateComponents *yh_cmps;

// the year with given date.
@property (nonatomic, assign, readonly) NSInteger yh_year;

// the month with given date.
@property (nonatomic, assign, readonly) NSInteger yh_month;

// the day with given date.
@property (nonatomic, assign, readonly) NSInteger yh_day;

// the hour with given date.
@property (nonatomic, assign, readonly) NSInteger yh_hour;

// the minute with given date.
@property (nonatomic, assign, readonly) NSInteger yh_minute;

// the second with given date.
@property (nonatomic, assign, readonly) NSInteger yh_second;

// the week with given date.
@property (nonatomic, assign, readonly) YHDateWeekType yh_weekType;

// is leap year with given date.
@property (nonatomic, assign, readonly) BOOL yh_isLeapYear;

// is today with given date.
@property (nonatomic, assign, readonly) BOOL yh_isToday;

// is yesterday with given date.
@property (nonatomic, assign, readonly) BOOL yh_isYesterday;

// is tomorrow with given date.
@property (nonatomic, assign, readonly) BOOL yh_isTomorrow;

// days of the month.
@property (nonatomic, assign, readonly) NSInteger yh_daysOfMonth;

// NSDate -> time string
// yyyy-MM-dd HH:mm:ss
- (NSString *)yh_dateStringWithFormat:(NSString *)format;

// NSDate -> timeStmp
- (NSString *)yh_timeStamp;

// Returns a date representing the receiver date shifted later by the provided number of seconds.
- (NSDate *)yh_dateByAddSecond:(NSInteger)second;

// Returns a date representing the receiver date shifted later by the provided number of minutes.
- (NSDate *)yh_dateByAddMinute:(NSInteger)minute;

// Returns a date representing the receiver date shifted later by the provided number of hours.
- (NSDate *)yh_dateByAddHour:(NSInteger)hour;

// Returns a date representing the receiver date shifted later by the provided number of days.
- (NSDate *)yh_dateByAddDay:(NSInteger)day;






@end
NS_ASSUME_NONNULL_END
