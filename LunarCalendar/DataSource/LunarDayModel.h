//
//  LunarDayModel.h
//  LunarCalendar
//
//  Created by haowenliang on 14-4-5.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MONTH_TYPE_LAST = 0,
    MONTH_TYPE_CURR = 1,
    MONTH_TYPE_NEXT = 2
}MONTH_TYPE;

@interface LunarDayModel : NSObject


@property (nonatomic, retain) NSString* day;
@property (nonatomic, retain) NSString* lunar;
@property (nonatomic) NSInteger type;

@end
