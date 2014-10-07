//
//  BottomControlView.h
//  UINavigationTest
//
//  Created by haowenliang on 14-2-15.
//  Copyright (c) 2014年 D-P-Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ViewType
{
    ViewTypeDay = 1,
    ViewTypeMonth = 2,
    ViewTypeYear = 3,
    ViewTypeAbout = 4
};

@protocol BottomViewDelegate <NSObject>
@optional
- (void)changViewAtIndex:(NSInteger)index;

@end

@interface BottomControlView : UIView

@property (nonatomic, retain) UIView* parentView;
@property (nonatomic, assign) id<BottomViewDelegate> delegate;

+ (BottomControlView* )getInstance;

- (void)showView;
- (void)showViewAutoHide:(BOOL)autoly;

- (void)dismissView;
- (void)dismissViewWithBloc:(void(^)(BOOL reload))block;

- (BOOL)isHidden;
@end
