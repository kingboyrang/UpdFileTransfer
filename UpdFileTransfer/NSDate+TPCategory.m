//
//  NSDate+DateHelper.m
//  DateHelper
//
//  Created by rang on 13-1-7.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "NSDate+TPCategory.h"

@implementation NSDate (TPCategory)
//取得今天是星期幾
-(NSInteger)dayOfWeek{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
													 fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    NSInteger d=[offsetComponents day];
    static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    y -= m < 3;
    
    NSInteger result=(y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
    if (result==0) {
        result=7;
    }
    return result;
}
//取得每月有多少天
-(NSInteger)monthOfDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
													 fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    if (m==2) {
        if (y%4==0&&(y%100!=0||y%400==0)) {
            return 29;
        }
        return 28;
    }
    if (m==4||m==6||m==9||m==11) {
        return 30;  
    }
    return 31;
}
//取得当前月第一天
- (NSDate *)monthFirstDay{
    TKDateInformation info=[self dateInformation];
    if (info.day==1) {
        return self;
    }
    return [self dateByAddingDays:-(info.day-1)];
}
//取得当前月最后一天
- (NSDate *)monthLastDay{
    TKDateInformation info=[self dateInformation];
    NSInteger total=[self monthOfDay]-info.day;
    return [self dateByAddingDays:total];
}
//本周開始時間
-(NSDate*)beginningOfWeek{
    NSInteger weekday=[self dayOfWeek];
    return  [self dateByAddingDays:(weekday-1)*-1];
}
//本周结束時間
- (NSDate *)endOfWeek{
    NSInteger weekday=[self dayOfWeek];
    if (weekday==7) {
        return self;
    }
    return [self dateByAddingDays:7-weekday];
}
//日期增加幾月
-(NSDate*)dateByAddingMonths:(NSInteger)month{
    NSDateComponents *c = [[NSDateComponents alloc] init];
	c.month = month;
    
    NSDate *resultDate=[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
    [c release];
    
    return resultDate;
}
//日期增加幾天
-(NSDate*)dateByAddingDays:(NSInteger)days{
    NSDateComponents *c = [[NSDateComponents alloc] init];
	c.day = days;
    
    NSDate *resultDate=[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
    [c release];
    
    return resultDate;
	//return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
    /***
    NSTimeInterval interval = 24 * 60 * 60;//表示一天
    return  [self dateByAddingTimeInterval:day*interval];
     ***/
}
//日期增加幾分鐘
-(NSDate*)dateByAddingMinutes:(NSInteger)minute{
    NSTimeInterval interval =60;//表示1分鐘
    return  [self dateByAddingTimeInterval:minute*interval];
}
//日期格式化
- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return timestamp_str;
}
//字串轉換成時間
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}
//時間轉換成字串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}
//日期轉換成民國時間
-(NSString*)dateToTW:(NSString *)string{
    NSString *str=[self stringWithFormat:string];
    int y=[[str substringWithRange:NSMakeRange(0, 4)] intValue];
    return [NSString stringWithFormat:@"%d%@",y-1911,[str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}
- (TKDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz{
	
	
	TKDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit)
										  fromDate:self];
	info.day = [comp day];
	info.month = [comp month];
	info.year = [comp year];
	
	info.hour = [comp hour];
	info.minute = [comp minute];
	info.second = [comp second];
	
	info.weekday = [comp weekday];
	
	
	return info;
	
}
- (TKDateInformation) dateInformation{
	
	TKDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit)
										  fromDate:self];
	info.day = [comp day];
	info.month = [comp month];
	info.year = [comp year];
	
	info.hour = [comp hour];
	info.minute = [comp minute];
	info.second = [comp second];
	
	info.weekday = [comp weekday];
	
    
	return info;
}
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info timeZone:(NSTimeZone*)tz{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	[comp setTimeZone:tz];
	
	return [gregorian dateFromComponents:comp];
}
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	//[comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [gregorian dateFromComponents:comp];
}

+ (NSString*) dateInformationDescriptionWithInformation:(TKDateInformation)info{
	return [NSString stringWithFormat:@"%d %d %d %d:%d:%d",info.month,info.day,info.year,info.hour,info.minute,info.second];
}
-(BOOL)compareToDate:(NSDate*)date{
    if ([self compare:date]==NSOrderedDescending) {
        return YES;
    }
    return NO;
}
@end
