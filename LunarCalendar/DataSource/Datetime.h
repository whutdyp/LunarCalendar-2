//  LunarCalendar
//
//  Created by cocrash on 14-2-17.
//  Copyright (c) 2013年 D-P-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LunarCalendar;

@interface Datetime : NSObject
+(void)resetStaticComponents;
//获取某年某月某日的农历对象
+ (LunarCalendar* )GetLunarCalendarByYear:(NSInteger)year
                                 andMonth:(NSInteger)month
                                   andDay:(NSInteger)day;
//獲取某天的節氣,農曆,星期等信息   
+ (NSDictionary*)GetFestivalDayByYear:(NSInteger)year
                         andMonth:(NSInteger)month
                           andDay:(NSInteger)day;

//所有年列表
+(NSArray *)GetAllYearArray;

//所有月列表
+(NSArray *)GetAllMonthArray;


//获取指定年份指定月份的星期排列表
+(NSArray *)GetDayArrayByYear:(NSInteger) year
                     andMonth:(NSInteger) month;

//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)GetLunarDayArrayByYear:(NSInteger) year
                          andMonth:(NSInteger) month;

//获取某年某月某日的对应农历
+(NSString *)GetLunarDayByYear:(NSInteger) year
                      andMonth:(NSInteger) month
                        andDay:(NSInteger) day;


//以YYYY.MM.dd格式输出年月日
+(NSString*)getDateTime;

//以YYYY年MM月dd日格式输出年月日
+(NSString*)GetDateTime;

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime;


+(NSInteger)GetIntYear;
+(NSInteger)GetIntMonth;
+(NSInteger)GetIntDay;

+(NSString *)GetHour;
+(NSString *)GetMinute;
+(NSString *)GetSecond;

+(NSInteger)GetWeekDay;
/////////////////////////
+ (NSDictionary*)GetNextDateByYear:(NSInteger)year
                          andMonth:(NSInteger)month
                            andDay:(NSInteger)day;
+ (NSDictionary*)getPreviousDateByYear:(NSInteger)year
                              andMonth:(NSInteger)month
                                andDay:(NSInteger)day;

+ (NSDateFormatter* )staticFormatter;

+ (NSArray*)GetLunarMonthViewDatasource:(NSInteger)year andMonth:(NSInteger)month;
@end
