//
//  UIViewController+UIDefine.h
//  LunarCalendar
//
//  Created by haowenliang on 14-3-24.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIDefine)

- (UIView *)customNavigateView;
- (UIView* )customNavigateViewWithTitle:(NSString*)titleString backMsg:(NSString*)backString;

@end
