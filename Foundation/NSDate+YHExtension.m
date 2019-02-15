//
//  NSDate+YHExtension.m
//  Kit
//
//  Created by 银河 on 2018/12/27.
//  Copyright © 2018 yinhe. All rights reserved.
//

#import "NSDate+YHExtension.h"

#ifdef DEBUG
    #define YHDebugLog(format, ...)  printf("[YHDebugLog] [NSDate (YHExtension)] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHDebugLog(format, ...)
#endif
@implementation NSDate (YHExtension)

// date components.
// year, month, day, hour, minute, second, weekday.
- (NSDateComponents *)yh_cmps{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    return [[NSCalendar currentCalendar] components:unit fromDate:self];
}

// the year with given date.
- (NSInteger)yh_year{
    return self.yh_cmps.year;
}

// the month with given date.
- (NSInteger)yh_month{
    return self.yh_cmps.month;
}

// the day with given date.
- (NSInteger)yh_day{
    return self.yh_cmps.day;
}

// the hour with given date.
- (NSInteger)yh_hour{
    return self.yh_cmps.hour;
}

// the minute with given date.
- (NSInteger)yh_minute{
    return self.yh_cmps.minute;
}

// the second with given date.
- (NSInteger)yh_second{
    return self.yh_cmps.second;
}

// the week with given date.
- (YHDateWeekType)yh_weekType{
    NSInteger weekday = self.yh_cmps.weekday;
    YHDateWeekType type = YHDateWeekTypeSunday;
    if (weekday == 1) {
        type = YHDateWeekTypeSunday;
    } else if (weekday == 2) {
        type = YHDateWeekTypeMonday;
    } else if (weekday == 3) {
        type = YHDateWeekTypeTuesday;
    } else if (weekday == 4) {
        type = YHDateWeekTypeWednesday;
    } else if (weekday == 5) {
        type = YHDateWeekTypeThursday;
    } else if (weekday == 6) {
        type = YHDateWeekTypeFriday;
    } else if (weekday == 7) {
        type = YHDateWeekTypeSaturday;
    }
    return type;
}

// is leap year with given date.
- (BOOL)yh_isLeapYear{
    NSInteger year = self.yh_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

// is today with given date.
- (BOOL)yh_isToday{
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

// is yesterday with given date.
- (BOOL)yh_isYesterday{
    return [[NSCalendar currentCalendar] isDateInYesterday:self];
}

// is tomorrow with given date.
- (BOOL)yh_isTomorrow{
    return [[NSCalendar currentCalendar] isDateInTomorrow:self];
}

// days of the month.
- (NSInteger)yh_daysOfMonth{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

// NSDate -> time string
// yyyy-MM-dd HH:mm:ss
- (NSString *)yh_dateStringWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

// NSDate -> timeStmp
- (NSString *)yh_timeStamp{
    NSInteger stmp = (NSInteger)[self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)stmp];
}

// Returns a date representing the receiver date shifted later by the provided number of seconds.
- (NSDate *)yh_dateByAddSecond:(NSInteger)second{
    NSTimeInterval s = [self timeIntervalSince1970] + second;
    return [NSDate dateWithTimeIntervalSince1970:s];
}

// Returns a date representing the receiver date shifted later by the provided number of minutes.
- (NSDate *)yh_dateByAddMinute:(NSInteger)minute{
    return [self yh_dateByAddSecond:(minute * 60)];
}

// Returns a date representing the receiver date shifted later by the provided number of hours.
- (NSDate *)yh_dateByAddHour:(NSInteger)hour{
    return [self yh_dateByAddMinute:(hour * 60)];
}

// Returns a date representing the receiver date shifted later by the provided number of days.
- (NSDate *)yh_dateByAddDay:(NSInteger)day{
    return [self yh_dateByAddHour:(day * 24)];
}




@end
