//
//  LDayItemView.m
//  LunarCalendar
//
//  Created by haowenliang on 14-3-26.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LDayItemView.h"


#define MONTH_DAY_ITEM_W (40.0f)


@implementation LDayItemView
@synthesize solar = _solar;
@synthesize lunar = _lunar;
@synthesize actionSelector,actionTarget;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor* textColor = RGBACOLOR(0x39, 0x3D, 0x3E, 1);//[UIColor colorWithRed:0x39/255.0f green:0x3d/255.0f blue:0x3e/255.0f alpha:1];
        UIColor* bgColor = [UIColor clearColor];
        
        _solar = [[UILabel alloc]init];
        _solar.text = @"";
        _solar.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:23];
        _solar.textColor = textColor;
        _solar.backgroundColor = bgColor;
        _solar.frame = CGRectMake(0, 0, 34, 34);
        //        lable.adjustsFontSizeToFitWidth = YES;
        _solar.textAlignment = NSTextAlignmentCenter;
        //        [lable sizeToFit];
        [_solar setCenter:CGPointMake(MONTH_DAY_ITEM_W/2.0f, CGRectGetMinY(_solar.frame))];
        
        _lunar = [[UILabel alloc]init];
        _lunar.text = @"";
        _lunar.textColor = RGBACOLOR(0x5c, 0x5f, 0x60, 1);//[UIColor colorWithRed:0x5c/255.0f green:0x5f/255.0f blue:0x60/255.0f alpha:1];
        _lunar.font = [UIFont fontWithName:@"chenyuxiao" size:13];
        _lunar.backgroundColor = [UIColor clearColor];
        _lunar.frame = CGRectMake(0, CGRectGetMaxY(_solar.frame)+4.0f, MONTH_DAY_ITEM_W, 16);
        _lunar.adjustsFontSizeToFitWidth = YES;
        _lunar.textAlignment = NSTextAlignmentCenter;
        [_lunar sizeToFit];
        [_lunar setCenter:CGPointMake(MONTH_DAY_ITEM_W/2.0f, CGRectGetMidY(_lunar.frame))];
        
        [self addSubview:_solar];
        [self addSubview:_lunar];
    }
    return self;
}
//空白佔位
- (void)isValidButton
{
//    self.userInteractionEnabled = NO;
}

//正常展示
- (void)isFireButton
{
    self.userInteractionEnabled = YES;
    if (actionTarget && actionSelector) {
        [self addTarget:actionTarget action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self addTarget:self action:@selector(buttenTouchUpInsideDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
    }
//    self.showsTouchWhenHighlighted = YES;
}

- (void)buttenTouchUpInsideDefaultAction:(UIButton* )sender
{
    NSLog(@"%s --- Sender Tag: %ld",__FUNCTION__,(long)sender.tag);
}

#pragma mark -
- (void)setTodayInformation
{
    _solar.textColor = [UIColor whiteColor];
    _solar.backgroundColor = [UIColor colorWithRed:0xd9/255.0f green:0x24/255.0f blue:0x24/255.0f alpha:1];
    _solar.layer.cornerRadius = CGRectGetWidth(_solar.frame)/2.0f;
    _solar.layer.masksToBounds = YES;
    
    _lunar.textColor = RGBACOLOR(0x5c, 0x5f, 0x60, 1);
}

- (void)setDayViewInformationText:(NSString* )solarText lunarText:(NSString* )lunarText
{
    [self setDayViewInformationText:solarText lunarText:lunarText isToday:NO];
}

- (void)setDayViewInformationText:(NSString* )solarText lunarText:(NSString* )lunarText isToday:(BOOL)today
{
    _solar.text = solarText;
    //    [_solar sizeToFit];
//    [_solar setCenter:CGPointMake(MONTH_DAY_ITEM_W/2.0f, CGRectGetMinY(_solar.frame))];
    
    _lunar.text = lunarText;
    [_lunar sizeToFit];
//    _lunar.frame = CGRectMake(0, CGRectGetMaxY(_solar.frame)+4.0f, MONTH_DAY_ITEM_W, 16);
    [_lunar setCenter:CGPointMake(MONTH_DAY_ITEM_W/2.0f, CGRectGetMidY(_lunar.frame))];
    
    if (today) {
        [self setTodayInformation];
    }else{
        _solar.textColor = [UIColor colorWithRed:0x39/255.0f green:0x3d/255.0f blue:0x3e/255.0f alpha:1];
        _solar.backgroundColor = [UIColor clearColor];
    }
}

- (void)setDayViewInformationTextEx:(NSString* )solarText lunarText:(NSString* )lunarText isToday:(BOOL)today isCurrentMonth:(BOOL)curMonth
{
    _solar.text = solarText;
    //    [_solar sizeToFit];
    //    [_solar setCenter:CGPointMake(MONTH_DAY_ITEM_W/2.0f, CGRectGetMinY(_solar.frame))];
    
    _lunar.text = lunarText;
    [_lunar sizeToFit];
    //    _lunar.frame = CGRectMake(0, CGRectGetMaxY(_solar.frame)+4.0f, MONTH_DAY_ITEM_W, 16);
    [_lunar setCenter:CGPointMake(MONTH_DAY_ITEM_W/2.0f, CGRectGetMidY(_lunar.frame))];
    
    if (today) {
        [self setTodayInformation];
    }else if(curMonth){
        _solar.textColor = [UIColor colorWithRed:0x39/255.0f green:0x3d/255.0f blue:0x3e/255.0f alpha:1];
        _solar.backgroundColor = [UIColor clearColor];
        _lunar.textColor = RGBACOLOR(0x5c, 0x5f, 0x60, 1);
    }else{
        [_lunar setTextColor:RGBACOLOR(0xD4, 0xD4, 0xD4, 1)];
        _solar.backgroundColor = [UIColor clearColor];
        [_solar setTextColor:RGBACOLOR(0xD4, 0xD4, 0xD4, 1)];
    }
}


@end
