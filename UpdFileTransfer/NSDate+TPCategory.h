//
//  NSDate+DateHelper.h
//  DateHelper
//
//  Created by rang on 13-1-7.
//  Copyright (c) 2013年 rang. All rights reserved.
//
/***
 3、iOS-NSDateFormatter 格式说明：
 
 G: 公元時代，例如AD公元
 yy: 年的後2位
 yyyy: 完整年
 MM: 月，顯示为1-12
 MMM: 月，顯示为英文月份縮寫,如 Jan
 MMMM: 月，顯示为英文月份全稱，如 Janualy
 dd: 日，2位數表示，如02
 d: 日，1-2位顯示，如 2
 EEE: 縮寫星期幾，如Sun
 EEEE: 全写星期幾，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小時制，0-23
 K：时，12小時制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 
 常用日期結構：
 yyyy-MM-dd HH:mm:ss.SSS
 yyyy-MM-dd HH:mm:ss
 yyyy-MM-dd
 MM dd yyyy
 ***/

#import <Foundation/Foundation.h>

struct TKDateInformation {
	int day;
	int month;
	int year;
	
	int weekday;
	
	int minute;
	int hour;
	int second;
	
};
typedef struct TKDateInformation TKDateInformation;

@interface NSDate (TPCategory)
//取得今天是星期幾
-(NSInteger)dayOfWeek;
//取得每月有多少天
-(NSInteger)monthOfDay;
//取得当前月第一天
- (NSDate *)monthFirstDay;
//取得当前月最后一天
- (NSDate *)monthLastDay;
//本周開始時間
-(NSDate*)beginningOfWeek;
//本周结束時間
- (NSDate *)endOfWeek;
//日期增加幾月
-(NSDate*)dateByAddingMonths:(NSInteger)month;
//日期增加幾天
-(NSDate*)dateByAddingDays:(NSInteger)day;
//日期增加幾分鐘
-(NSDate*)dateByAddingMinutes:(NSInteger)minute;
//日期格式化
- (NSString *)stringWithFormat:(NSString *)format;
//字串轉換成時間
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
//時間轉換成字串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
//日期轉換成民國時間
-(NSString*)dateToTW:(NSString *)string;
- (TKDateInformation) dateInformation;
- (TKDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(TKDateInformation)info;
/***時間大小的比較
  @return: 左邊的時間大於date返回YES，否則返回NO
 ***/
-(BOOL)compareToDate:(NSDate*)date;
@end
