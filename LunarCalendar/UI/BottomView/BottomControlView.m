//
//  BottomControlView.m
//  UINavigationTest
//
//  Created by haowenliang on 14-2-15.
//  Copyright (c) 2014年 D-P-Soft. All rights reserved.
//

#import "BottomControlView.h"
//#import "Datetime.h"

#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define VIEWBLACKBGCOLOR [UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:1]


#define VIEWBLACKHEIGHT (48.0)

#define SYSTEM_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SYSTEM_WIDTH [UIScreen mainScreen].bounds.size.width


//////
//Button
#define ButtonWidth (24.0f)
#define ButtonHeigth (32.0f)
#define ButtonMargin (15.0f)

#define ButtonStartX (SYSTEM_WIDTH/2.0 - ButtonWidth- ButtonWidth/2.0 - ButtonMargin)

#define ButtonY (VIEWBLACKHEIGHT - ButtonHeigth)/2.0f
/////


static BottomControlView* pBottomControlView = nil;

@interface BottomControlView()
{
    UIButton* _dayButton;
    UIButton* _monthButton;
    UIButton* _yearButton;
    
    UIButton* _aboutButton;
}

@property (nonatomic, retain) UIButton* dayButton;
@property (nonatomic, retain) UIButton* monthButton;
@property (nonatomic, retain) UIButton* yearButton;
@property (nonatomic, retain) UIButton* aboutButton;

@end

@implementation BottomControlView
@synthesize dayButton = _dayButton,monthButton = _monthButton, yearButton = _yearButton, aboutButton = _aboutButton;
@synthesize parentView = _parentView;
@synthesize delegate = _delegate;

+ (BottomControlView* )getInstance
{
    if (pBottomControlView == nil) {
        pBottomControlView = [[BottomControlView alloc] initWithFrame:CGRectZero];
        [pBottomControlView setBackgroundColor:VIEWBLACKBGCOLOR];
        
        pBottomControlView.frame = CGRectMake(0, SYSTEM_HEIGHT, SYSTEM_WIDTH, VIEWBLACKHEIGHT);
        pBottomControlView.hidden = YES;
    }
    return pBottomControlView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addBaseSubView];
    }
    return self;
}

- (void)addBaseSubView
{
    CGRect dayF = CGRectMake(ButtonStartX, ButtonY, ButtonWidth, ButtonHeigth);
    CGRect monthF = CGRectMake(ButtonStartX+ButtonWidth+ButtonMargin, ButtonY, ButtonWidth, ButtonHeigth);
    CGRect yearF = CGRectMake(ButtonStartX+2*(ButtonWidth+ButtonMargin), ButtonY, ButtonWidth, ButtonHeigth);
    CGRect aboutF = CGRectMake(SYSTEM_WIDTH - 2*ButtonWidth - 2*ButtonMargin, ButtonY, 2*ButtonWidth, ButtonHeigth);
    
    _dayButton = [self createBaseBarButton:@"日" frame:dayF action:@selector(dayButtonSelected)];
    _monthButton = [self createBaseBarButton:@"月" frame:monthF action:@selector(monthButtonSelected)];
    _yearButton = [self createBaseBarButton:@"年" frame:yearF action:@selector(yearButtonSelected)];
    _aboutButton = [self createBaseBarButton:@"..." frame:aboutF action:@selector(aboutButtonSelected)];
    
    
    [self addSubview:_dayButton];
    [self addSubview:_monthButton];
//    [self addSubview:_yearButton];
    [self addSubview:_aboutButton];
}

- (UIButton *)createBaseBarButton:(NSString*)title frame:(CGRect)frame action:(SEL)selector
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.titleLabel.font = [UIFont fontWithName:@"chenyuxiao" size:24];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(0xff, 0xff, 0xff, 1) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(0xff, 0x00, 0xa0, 1) forState:UIControlStateHighlighted];
    [btn setTitleColor:RGBCOLOR(0xff, 0xff, 0xff, 1) forState:UIControlStateDisabled];

    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (UIButton *)createAboutButton:(NSString*)title frame:(CGRect)frame action:(SEL)selector
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.userInteractionEnabled = YES;
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:24];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(0xff, 0xff, 0xff, 1) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(0xff, 0x00, 0xa0, 1) forState:UIControlStateHighlighted];
    [btn setTitleColor:RGBCOLOR(0xff, 0xff, 0xff, 1) forState:UIControlStateDisabled];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
#pragma mark -button selectors

- (void)dayButtonSelected
{
    NSLog(@"day click");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changViewAtIndex:)]) {
        [self.delegate changViewAtIndex:ViewTypeDay];
    }
}

- (void)monthButtonSelected
{
    NSLog(@"month click");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changViewAtIndex:)]) {
        [self.delegate changViewAtIndex:ViewTypeMonth];
    }
}

- (void)yearButtonSelected
{
    NSLog(@"year click");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changViewAtIndex:)]) {
        [self.delegate changViewAtIndex:ViewTypeYear];
    }
}

- (void)aboutButtonSelected
{
    NSLog(@"about click");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changViewAtIndex:)]) {
        [self.delegate changViewAtIndex:ViewTypeAbout];
    }
}

#pragma mark -
- (BOOL)isHidden
{
    return self.hidden;
}

- (void)showView
{
    if (self.hidden == YES) {
        [self showViewAutoHide:NO];
    }
}

- (void)dismissView
{
    [self dismissViewDelay:0.0f];
}

- (void)dismissViewDelay:(CGFloat)seconds
{
    [UIView beginAnimations:@"dismissFeedUpAnimation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissAction)];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelay:seconds];
    
    self.frame = CGRectMake(0, SYSTEM_HEIGHT, SYSTEM_WIDTH, VIEWBLACKHEIGHT);
    self.alpha = 0.6;
    [UIView commitAnimations];
}

- (void)dismissViewWithBloc:(void(^)(BOOL reload))block
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = CGRectMake(0, SYSTEM_HEIGHT, SYSTEM_WIDTH, VIEWBLACKHEIGHT);
                         self.alpha = 0.6;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                         block(NO);
                     }];
}

- (void)dismissAction
{
    self.hidden = YES;
}

- (void)showViewAutoHide:(BOOL)autoly
{
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    [self.parentView bringSubviewToFront:self];
    self.frame = CGRectMake(0, SYSTEM_HEIGHT, SYSTEM_WIDTH, VIEWBLACKHEIGHT);
    self.alpha = 0.6;
    
    
    [UIView beginAnimations:@"showFeedUpAnimation" context:nil];
    [UIView setAnimationDelegate:self];
    if (autoly) {
        [UIView setAnimationDidStopSelector:@selector(dismissView)];
    }
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelay:0.0];
    
    self.frame = CGRectMake(0, SYSTEM_HEIGHT - VIEWBLACKHEIGHT, SYSTEM_WIDTH, VIEWBLACKHEIGHT);
    self.alpha = 1.0;
    [UIView commitAnimations];
}
@end
