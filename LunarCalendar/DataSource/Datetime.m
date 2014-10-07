//  LunarCalendar
//
//  Created by cocrash on 14-2-17.
//  Copyright (c) 2013年 D-P-Soft. All rights reserved.
//

#import "Datetime.h"
#import "LunarCalendar.h"
#import "JBCalendar.h"

#import "LunarDayModel.h"

@implementation Datetime

static NSDateComponents *static_components = nil;
static NSDateFormatter* static_formatter = nil;

+ (NSDateComponents *)getStaticComponents
{
    if (static_components == nil) {
        static_components  = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    }
    return static_components;
}

+ (void)resetStaticComponents
{
    static_components = nil;
}


+ (NSDateFormatter* )staticFormatter
{
    if (static_formatter == nil) {
        static_formatter = [[NSDateFormatter alloc]init];
    }
    return static_formatter;
}

#pragma mark -
//所有年列表
+(NSArray *)GetAllYearArray
{
    NSMutableArray * yearArray = [[NSMutableArray alloc]init];
    for (int i = 1901; i<2100; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [yearArray addObject:days];
    }
    return yearArray;
}

//所有月列表
+(NSArray *)GetAllMonthArray
{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<13; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//以YYYY.MM.dd格式输出年月日
+(NSString*)getDateTime
{
    [[Datetime staticFormatter] setDateFormat:@"yyyy.MM.dd"];
    NSString* date = [[NSString alloc]initWithString:[[Datetime staticFormatter] stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MM月dd日格式输出年月日
+(NSString*)GetDateTime
{
    [[Datetime staticFormatter] setDateFormat:@"yyyy年MM月dd日"];
     NSString* date = [[NSString alloc]initWithString:[[Datetime staticFormatter] stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime
{
    JBCalendar* date = [[JBCalendar alloc]init];
    
    date.year = [Datetime GetIntYear];
    date.month =[Datetime GetIntMonth];
    date.day = [Datetime GetIntDay];
    
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    
    NSString * lunar = [[NSString alloc]initWithFormat:
                           @"%@%@年%@%@",lunarCalendar.YearHeavenlyStem,lunarCalendar.YearEarthlyBranch,lunarCalendar.MonthLunar,lunarCalendar.DayLunar];
    return lunar;
}

#pragma mark -

+ (NSArray*)GetLunarMonthViewDatasource:(NSInteger)year andMonth:(NSInteger)month
{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    
    NSInteger retWeek = [Datetime GetTheWeekOfDayByYera:year andByMonth:month];
    NSInteger retNumberOfMonth = [Datetime GetNumberOfDayByYera:year andByMonth:month];
    NSInteger retNumberOfLastMonth = 0;
    
    NSInteger lastm = month - 1;
    NSInteger lasty = year;
    if (lastm == 0) {
        lastm = 12;
        --lasty;
    }
    if (retWeek == 0) {
        retWeek = 7;
    }
    if (retWeek > 0) {//第一天是周日，没有上个月的日子需要展示
        retNumberOfLastMonth = [Datetime GetNumberOfDayByYera:lasty andByMonth:lastm];
    }

    NSInteger nextm = month+1;
    NSInteger nexty = year;
    if (nextm > 12) {
        nextm = 1;
        ++nexty;
    }
    
    for (NSInteger i = 0; i< 42; i++) {
        LunarDayModel* model = [[LunarDayModel alloc] init];
        if (i <= retWeek-1) {
            //retWeek代表了上个月需要展示多少天
            NSInteger dTmp = retNumberOfLastMonth - retWeek + 1 + i;
            NSString * days = [Datetime GetLunarDayByYear:lasty andMonth:lastm andDay:dTmp];
            model.lunar = days;
            model.type = MONTH_TYPE_LAST;
            NSString* daystr = [NSString stringWithFormat:@"%ld",(long)(retNumberOfLastMonth - retWeek + 1 + i)];
            model.day = daystr;
        }else if ((i>retWeek-1)&&(i<retWeek+retNumberOfMonth)){
            NSString * days = [Datetime GetLunarDayByYear:year andMonth:month andDay:(i-retWeek+1)];
            model.lunar = days;
            model.type = MONTH_TYPE_CURR;
            NSString * daystr;
            if((i - retWeek +1)< 10){
                daystr = [NSString stringWithFormat:@"%ld",(long)(i-retWeek+1)];
            }else {
                daystr = [NSString stringWithFormat:@"%ld",(long)(i-retWeek+1)];
            }
            model.day = daystr;
            
        }else {
            NSInteger dtmp = i - (retWeek + retNumberOfMonth) + 1;
            NSString * days = [Datetime GetLunarDayByYear:nexty andMonth:nextm andDay:dtmp];
            model.lunar = days;
            model.type = MONTH_TYPE_NEXT;
            
            NSString* daystr = [NSString stringWithFormat:@"%ld",(long)( i - (retWeek + retNumberOfMonth) + 1)];
            model.day = daystr;
        }
        [dayArray addObject:model];
    }
    return dayArray;
}

/*
 *
 * 获取指定年份指定月份的星期排列表
 *
 */
+(NSArray *)GetDayArrayByYear:(NSInteger) year andMonth:(NSInteger) month
{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    
    NSInteger retWeek = [Datetime GetTheWeekOfDayByYera:year andByMonth:month];
    NSInteger retNumberOfMonth = [Datetime GetNumberOfDayByYera:year andByMonth:month];
    NSInteger retNumberOfLastMonth = 0;
    
    NSInteger lastm = month - 1;
    NSInteger lasty = year;
    if (lastm == 0) {
        lastm = 12;
        --lasty;
    }
    if (retWeek > 0) {//第一天是周日，没有上个月的日子需要展示
        retNumberOfLastMonth = [Datetime GetNumberOfDayByYera:lasty andByMonth:lastm];
    }
    
    for (NSInteger i = 0; i< 42; i++) {
        if (i <= retWeek-1) {
            NSInteger dTmp = retNumberOfLastMonth - retWeek + 1 + i;
            NSString* daystr = [NSString stringWithFormat:@"%ld",(long)dTmp];
            [dayArray addObject:daystr];
        }else if ( (i > retWeek-1) && (i < (retWeek+retNumberOfMonth)) ){
            NSString * days;
            if((i - retWeek +1)< 10){
                days = [NSString stringWithFormat:@"%ld",(long)(i-retWeek+1)];
            }else {
                days = [NSString stringWithFormat:@"%ld",(long)(i-retWeek+1)];
            }
            [dayArray addObject:days];
        }else {
            NSInteger dtmp = i - (retWeek + retNumberOfMonth) + 1;
            NSString* daystr = [NSString stringWithFormat:@"%ld",(long)dtmp];
            [dayArray addObject:daystr];
        }
    }
    return dayArray;
}


/*
 *获取指定年份指定月份的星期排列表(农历)
 *
 */
+(NSArray *)GetLunarDayArrayByYear:(NSInteger) year andMonth:(NSInteger) month
{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    
    NSInteger retWeek = [Datetime GetTheWeekOfDayByYera:year andByMonth:month];
    NSInteger retNumberOfMonth = [Datetime GetNumberOfDayByYera:year andByMonth:month];
    NSInteger retNumberOfLastMonth = 0;
    
    NSInteger lastm = month - 1;
    NSInteger lasty = year;
    if (lastm == 0) {
        lastm = 12;
        --lasty;
    }
    if (retWeek > 0) {//第一天是周日，没有上个月的日子需要展示
        retNumberOfLastMonth = [Datetime GetNumberOfDayByYera:lasty andByMonth:lastm];
    }
    
    NSInteger nextm = month+1;
    NSInteger nexty = year;
    if (nextm > 12) {
        nextm = 1;
        ++nexty;
    }

    for (NSInteger i = 0; i< 42; i++) {
        if (i <= retWeek-1) {
            //retWeek代表了上个月需要展示多少天
            NSInteger dTmp = retNumberOfLastMonth - retWeek + 1 + i;
            NSString * days = [Datetime GetLunarDayByYear:lasty andMonth:lastm andDay:dTmp];
            [dayArray addObject:days];
        }else if ((i>retWeek-1)&&(i<retWeek+retNumberOfMonth)){
            NSString * days = [Datetime GetLunarDayByYear:year andMonth:month andDay:(i-retWeek+1)];
            [dayArray addObject:days];
        }else {
            NSInteger dtmp = i - (retWeek + retNumberOfMonth) + 1;
            NSString * days = [Datetime GetLunarDayByYear:nexty andMonth:nextm andDay:dtmp];
            [dayArray addObject:days];
        }
    }
    return dayArray;
}

/*获取某年某月某日的对应农历日
 *  24节气 > 中国传统节日 > 农历月第一天 > 农历日
 */
+(NSString *)GetLunarDayByYear:(NSInteger) year
                      andMonth:(NSInteger) month
                        andDay:(NSInteger) day
{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = year;
    date.month = month;
    date.day = day;
    
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];

    NSString* solorTerm = [lunarCalendar SolarTermTitle];
    if (solorTerm && [solorTerm length] > 0) {
        return solorTerm;
    }
    NSString* chinaDay = [lunarCalendar ChineseFestival];
    if (chinaDay && [chinaDay length] > 0) {
        return chinaDay;
    }
    NSString* holiday = [lunarCalendar ChineseStatutoryHolidays];
    if ([holiday length] > 0) {
        return holiday;
    }
    NSString* lunarday = lunarCalendar.DayLunar;
    if ([lunarday isEqualToString:@"初一"]) {
        lunarday = lunarCalendar.MonthLunar;
    }
    if (lunarCalendar.IsLeap) {
        lunarday = [NSString stringWithFormat:@"闰%@",lunarday];
    }
    return lunarday;
}


#pragma mark -

/*
 *计算year年month月第一天是星期几，周日则为0
 * month 1-12
 */
+(NSInteger)GetTheWeekOfDayByYera:(NSInteger)year
                 andByMonth:(NSInteger)month
{
    //year from 1 to n
    NSInteger numWeek = ((year-1)+ (year-1)/4-(year-1)/100+(year-1)/400+1)%7;//numWeek为years年的第一天是星期几

    NSInteger ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    //闰年且大于2月份 +1
    NSInteger numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))? (ar[month-1]+1):(ar[month-1]);//numdays为month月years年的第一天是这一年的第几天

    NSInteger dayweek = (numdays%7 + numWeek)%7;//month月第一天是星期几，周日则为0

    return dayweek;
}

/*
 *判断year年month月有多少天
 * month 1-12
 */
+(NSInteger)GetNumberOfDayByYera:(NSInteger)year
                andByMonth:(NSInteger)month
{
    NSInteger nummonth = 0;
    //判断month月有多少天
    if ((month == 1)|| (month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
        nummonth = 31;
    else if ((month == 4)|| (month == 6)||(month == 9)||(month == 11))
        nummonth = 30;
    else if (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))
        nummonth = 29;
    else nummonth = 28;
    
    return nummonth;
}

/*
 * 某天的農曆對象
 */
+ (LunarCalendar* )GetLunarCalendarByYear:(NSInteger)year
                                 andMonth:(NSInteger)month
                                   andDay:(NSInteger)day
{
    JBCalendar* date = [[JBCalendar alloc] init];
    date.year = year;
    date.month = month;
    date.day = day;
    return [[date nsDate] chineseCalendarDate];
}

/*
 *日視圖，某天的信息
 *
 */
+ (NSDictionary*)GetFestivalDayByYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day
{
    LunarCalendar* lcanlendar = [Datetime GetLunarCalendarByYear:year andMonth:month andDay:day];
    if (lcanlendar == nil) {
        return nil;
    }
    NSString* wText = @"";
    switch ([lcanlendar Weekday]) {
        case 1:
            wText = @"星期日";
            break;
        case 2:
            wText = @"星期一";
            break;
        case 3:
            wText = @"星期二";
            break;
        case 4:
            wText = @"星期三";
            break;
        case 5:
            wText = @"星期四";
            break;
        case 6:
            wText = @"星期五";
            break;
        case 7:
            wText = @"星期六";
            break;
        default:
            break;
    }
    NSString* lText = [NSString stringWithFormat:@"%@%@",[lcanlendar MonthLunar],[lcanlendar DayLunar]];
    if (lcanlendar.IsLeap) {
        lText = [NSString stringWithFormat:@"闰%@",lText];
    }
    NSString* fText = [lcanlendar SolarTermTitle];
    if (fText == nil || [fText length] <= 0) {
       fText = [lcanlendar ChineseFestival];
    }
    if (fText == nil || fText.length <= 0) {
//        fText = [NSString stringWithFormat:@"%@%@日", [lcanlendar DayHeavenlyStem], [lcanlendar DayEarthlyBranch]];
        fText = [lcanlendar ChineseStatutoryHolidays];
    }
    if (fText == nil || fText.length <= 0) {
        fText = @"";
    }
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",fText],@"festival",wText, @"weekday",lText,@"lunar", nil];
    return dict;
}

#pragma mark -Base Date Methods

+ (NSInteger)GetIntYear
{
    return [[Datetime getStaticComponents] year];
}

+ (NSInteger)GetIntMonth
{
    return [[Datetime getStaticComponents] month];
}

+ (NSInteger)GetIntDay
{
    return [[Datetime getStaticComponents] day];
}

+(NSString *)GetHour
{
    [[Datetime staticFormatter] setDateFormat:@"hh"];
    NSString* date = [[NSString alloc]initWithString:[[Datetime staticFormatter] stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMinute
{
    [[Datetime staticFormatter] setDateFormat:@"mm"];
    NSString* date = [[NSString alloc]initWithString:[[Datetime staticFormatter] stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetSecond
{
    [[Datetime staticFormatter] setDateFormat:@"ss"];
    NSString* date = [[NSString alloc]initWithString:[[Datetime staticFormatter] stringFromDate:[NSDate date]]];
    return date;
}

+(NSInteger)GetWeekDay
{
    NSInteger day = [[Datetime getStaticComponents] day];
    NSInteger month = [[Datetime getStaticComponents] month];
    NSInteger year = [[Datetime getStaticComponents] year];
    
    LunarCalendar* lcanlendar = [Datetime GetLunarCalendarByYear:year andMonth:month andDay:day];
    if (lcanlendar == nil) {
        return 0;
    }
    return [lcanlendar Weekday];
}

//////////////////
/*
 *明天是 X年X月X日
 */
+ (NSDictionary*)GetNextDateByYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day
{
    NSInteger count = [Datetime GetNumberOfDayByYera:year andByMonth:month];
    if (day < count) {
        day = day + 1;
        return @{@"year": [NSNumber numberWithInteger:year], @"month":[NSNumber numberWithInteger:month],@"day":[NSNumber numberWithInteger:day]};
    }
    if (year == 2100) {
        day = [Datetime GetIntDay];
        month = [Datetime GetIntMonth];
        year = [Datetime GetIntYear];
        return @{@"year": [NSNumber numberWithInteger:year], @"month":[NSNumber numberWithInteger:month],@"day":[NSNumber numberWithInteger:day]};
    }
    
    day = 1;
    month = month+1;
    if(month == 13){
        year++;
        month = 1;
    }
    return @{@"year": [NSNumber numberWithInteger:year], @"month":[NSNumber numberWithInteger:month],@"day":[NSNumber numberWithInteger:day]};
}

/*
 *昨天是 X年X月X日
 */
+ (NSDictionary*)getPreviousDateByYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day
{
    if (day > 1) {
        day = day - 1;
        return @{@"year": [NSNumber numberWithInteger:year], @"month":[NSNumber numberWithInteger:month],@"day":[NSNumber numberWithInteger:day]};
    }
    if (year == 1900) {
        day = [Datetime GetIntDay];
        month = [Datetime GetIntMonth];
        year = [Datetime GetIntYear];
        return @{@"year": [NSNumber numberWithInteger:year], @"month":[NSNumber numberWithInteger:month],@"day":[NSNumber numberWithInteger:day]};
    }
    
    month = month -1;
    if (month == 0) {
        year --;
        month = 12;
    }
    day = [Datetime GetNumberOfDayByYera:year andByMonth:month];

    return @{@"year": [NSNumber numberWithInteger:year], @"month":[NSNumber numberWithInteger:month],@"day":[NSNumber numberWithInteger:day]};
}

@end
