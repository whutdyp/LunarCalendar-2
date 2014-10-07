//
//  UIViewController+UIDefine.m
//  LunarCalendar
//
//  Created by haowenliang on 14-3-24.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "UIViewController+UIDefine.h"

@implementation UIViewController (UIDefine)

- (UIView* )customNavigateViewWithTitle:(NSString*)titleString backMsg:(NSString*)backString
{
    UIView* _navigateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEADER_VIEW_HEIGHT)];
    [_navigateView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0 alpha:1]];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEADER_VIEW_HEIGHT, SCREEN_WIDTH, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0xda/255.0f green:0xda/255.0f blue:0xda/255.0f alpha:1]];
    [_navigateView addSubview:lineView];
    
    UIButton* backBtn = [self getBackBarButtonWithImageWithMessage:backString];
    [backBtn setCenter:CGPointMake(15.0f + CGRectGetWidth(backBtn.frame)/2.0f, NAV_HEADER_VIEW_HEIGHT - CGRectGetHeight(backBtn.frame)/2.0f - 8.0f)];
    [_navigateView addSubview:backBtn];
    
    UIView* titleView = [self setDisplayCustomTitleText:titleString];
    titleView.center = CGPointMake(SCREEN_WIDTH/2.0f, backBtn.center.y);
    [_navigateView addSubview:titleView];
    
    return _navigateView;
}

- (UIView *)customNavigateView
{
    UIView* _navigateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEADER_VIEW_HEIGHT)];
    [_navigateView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0 alpha:1]];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEADER_VIEW_HEIGHT, SCREEN_WIDTH, 1)];
//    [lineView setBackgroundColor:RGBACOLOR(0xb2, 0xb2, 0xb2, 1)];
    [lineView setBackgroundColor:RGBACOLOR(0xda, 0xda, 0xda, 1)];
    [_navigateView addSubview:lineView];
    
    UIButton* backBtn = [self setRightButtonText:@"关闭"];
    [backBtn setCenter:CGPointMake(SCREEN_WIDTH - (5.0f + CGRectGetWidth(backBtn.frame)/2.0f), NAV_HEADER_VIEW_HEIGHT - CGRectGetHeight(backBtn.frame)/2.0f - 8.0f)];
    [_navigateView addSubview:backBtn];
    
    UIView* titleView = [self setDisplayCustomTitleText:@"关于"];
    titleView.center = CGPointMake(SCREEN_WIDTH/2.0f, backBtn.center.y);
    [_navigateView addSubview:titleView];
    
    return _navigateView;
    
    return [self customNavigateViewWithTitle:@"关于" backMsg:@"返回"];
}

- (UIButton*)getBackBarButtonWithImageWithMessage:(NSString*)backString
{
    UIImage* tImage = nil;
    UIImage* pImage = nil;
    tImage = LOAD_ICON_USE_POOL_CACHE(@"header_leftbtn_nor.png");
    pImage = LOAD_ICON_USE_POOL_CACHE(@"header_leftbtn_press.png");
    tImage = [tImage stretchableImageWithLeftCapWidth:25 topCapHeight:15];
    pImage = [pImage stretchableImageWithLeftCapWidth:25 topCapHeight:15];
    
    // Custom initialization
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5.0, 0.0, 64.0, 32.0);
    
    [backButton setBackgroundImage:tImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:pImage forState:UIControlStateHighlighted];
    
    UIEdgeInsets  insets = UIEdgeInsetsMake(1, 15, 1, 10);
    [backButton setTitleEdgeInsets:insets];
    
    [backButton setTitle:backString forState:UIControlStateNormal];
    [backButton setTitle:backString forState:UIControlStateHighlighted];
    [backButton setImage:nil forState:UIControlStateNormal];
    [backButton setImage:nil forState:UIControlStateHighlighted];
    
    backButton.titleLabel.textColor		= RGBACOLOR(0xd9,0x24,0x24,1);
    //    backButton.titleLabel.shadowColor	= [UIColor clearColor];
    //    backButton.titleLabel.shadowOffset    = CGSizeMake(0, -1) ;
    [backButton setTitleColor:RGBACOLOR(0xd9,0x24,0x24,1) forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(0xd9,0x24,0x24,0.4) forState:UIControlStateHighlighted];
    
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    backButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //    [backButton setImage:[UIImage imageNamed:@"back-white.png"] forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
    //    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    //    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
}

- (void)backAction
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    animation.type = @"suckEffect";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)backActionDefault
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView* )setDisplayCustomTitleText:(NSString*)text
{
    // Init views with rects with height and y pos
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    // Use autoresizing to restrict the bounds to the area that the titleview allows
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.font = [UIFont systemFontOfSize:17];//[UIFont fontWithName:@"chenyuxiao" size:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel.textColor = RGBACOLOR(0x00, 0x00, 0x00, 1);
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    
    
    CGRect frame;
    CGFloat usedWidth = 75 * 2;
    
    //    CGFloat usedWidth = leftViewbounds.size.width + rightViewbounds.size.width + 30;
    
    frame = titleLabel.frame;
    
    frame.size.width = SCREEN_WIDTH - usedWidth;
    titleLabel.frame = frame;
    
    frame = titleView.frame;
    frame.size.width = SCREEN_WIDTH - usedWidth;
    titleView.frame = frame;
    
    // Set the text
    titleLabel.text = text;
    // Add as the nav bar's titleview
    [titleView addSubview:titleLabel];
    
    return titleView;
}

-  (UIButton* )setRightButtonText:(NSString* )backString
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5.0, 0.0, 64.0, 32.0);

    UIEdgeInsets  insets = UIEdgeInsetsMake(1, 15, 1, 10);
    [backButton setTitleEdgeInsets:insets];
    
    [backButton setTitle:backString forState:UIControlStateNormal];
    [backButton setTitle:backString forState:UIControlStateHighlighted];
    [backButton setImage:nil forState:UIControlStateNormal];
    [backButton setImage:nil forState:UIControlStateHighlighted];
    
    backButton.titleLabel.textColor		= RGBACOLOR(0xd9,0x24,0x24,1);
    //    backButton.titleLabel.shadowColor	= [UIColor clearColor];
    //    backButton.titleLabel.shadowOffset    = CGSizeMake(0, -1) ;
    [backButton setTitleColor:RGBACOLOR(0xd9,0x24,0x24,1) forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(0xd9,0x24,0x24,0.4) forState:UIControlStateHighlighted];
    
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    backButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [backButton addTarget:self action:@selector(backActionDefault) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

@end
