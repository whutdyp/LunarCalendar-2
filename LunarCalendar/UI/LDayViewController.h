//
//  LDayViewController.h
//  LCalendar
//
//  Created by haowenliang on 14-2-25.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDayViewController :UIViewController

- (void)activate;
- (void)resetYMDByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;
- (UIView* )topView;

@end


@interface HoriLabel : UIView

@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) NSString* content;
@property (nonatomic) CGFloat lineMargin;
@property (nonatomic, retain) UIColor* textColor;

@property (nonatomic) BOOL hasBrackets;

@end