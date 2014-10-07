//
//  LDayItemView.h
//  LunarCalendar
//
//  Created by haowenliang on 14-3-26.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDayItemView : UIButton

@property (nonatomic, retain) id actionTarget;

@property (nonatomic) SEL actionSelector;

@property (nonatomic ,retain) UILabel* solar;
@property (nonatomic, retain) UILabel* lunar;

- (void)isValidButton;
- (void)isFireButton;
- (void)setTodayInformation;
- (void)setDayViewInformationText:(NSString* )solarText lunarText:(NSString* )lunarText;

- (void)setDayViewInformationText:(NSString* )solarText lunarText:(NSString* )lunarText isToday:(BOOL)today;
- (void)setDayViewInformationTextEx:(NSString* )solarText lunarText:(NSString* )lunarText isToday:(BOOL)today isCurrentMonth:(BOOL)curMonth;
@end
