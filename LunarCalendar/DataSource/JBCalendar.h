//  LunarCalendar
//
//  Created by cocrash on 14-2-17.
//  Copyright (c) 2013年 D-P-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBCalendar : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
- (NSDate *)nsDate;

@end
