//
//  LMonthViewController.m
//  LCalendar
//
//  Created by haowenliang on 14-2-25.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LMonthViewController.h"
#import "Datetime.h"

#import "FlatDatePicker.h"
#import "LDayItemView.h"
#import <QuartzCore/QuartzCore.h>

#if 1
#import "LunarDayModel.h"
#endif

@interface LMonthViewController ()<FlatDatePickerDelegate>
{
    UIView* TLabel;
//    UIButton* todayLinkButton;
    UIView* todayLinkButton;
    UIButton* calSelectorButton;
    
//    UIDatePicker *_datePicker;
    
    UIView* _headerView;
    
    NSMutableArray* dayButtonArrays;
}

@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property (nonatomic, retain) UIView* headerView;
//@property (nonatomic, retain) UIDatePicker* datePicker;
@end

@implementation LMonthViewController
{
#if 0
    NSArray * dayArray;
    NSArray * lunarDayArray;
    
    NSArray* curDayArray;
    NSArray* curLunarDayArray;
#else
    NSArray* _dataList;
    NSArray* _curDataList;
#endif
    
    NSInteger strMonth;
    NSInteger strYear;
    
    NSMutableArray* dayCenterPoints;
    
    UIView* dayLayoutHouseView;
    
    UIView* baseViewHoldingTranslate;
}
@synthesize headerView = _headerView;
@synthesize flatDatePicker = _flatDatePicker;

//@synthesize datePicker = _datePicker;

#pragma mark - Header

#define BASE_MARGIN_HEIGHT (SYSTEM_VERSION_LESS_THAN(@"7.0")?0.0f:22.0f)

#define HEADER_VIEW_HEIGHT (58.0f + BASE_MARGIN_HEIGHT)

#define HVFRAME_TD_X (SCREEN_WIDTH - 80.0f)
#define HVFRAME_TD_Y (10.0f+ BASE_MARGIN_HEIGHT)
#define HVFRAME_TD_W (56.0f)
#define HVFRAME_TD_H (32.0f)

#define HVFRAME_LEFT_X (12.0f)
#define HVFRAME_LEFT_Y (10.0f+ BASE_MARGIN_HEIGHT)
#define HVFRAME_LEFT_W (128.0f)
#define HVFRAME_LEFT_H (32.0f)

#define HVFRAME_WEEK_START_X (22.0f)
#define HVFRAME_WEEK_START_Y (36.0f+ BASE_MARGIN_HEIGHT)
#define HVFRAME_WEEK_ITEM_W (42.0f)
#define HVFRAME_WEEK_ITEM_H (36.0f)
#define HVFRAME_WEEK_MARGIN (34.0f)

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_VIEW_HEIGHT)];
        [_headerView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0 alpha:1]];
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_VIEW_HEIGHT, SCREEN_WIDTH, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:0xda/255.0f green:0xda/255.0f blue:0xda/255.0f alpha:1]];
        [_headerView addSubview:lineView];
        [self.view addSubview:_headerView];
    }
    
    return _headerView;
}

//设置左边年月
-(void)loadTLabelTextWithYear:(NSInteger)year andMonth:(NSInteger)month andOtherMsg:(NSString*)msg
{
    UIColor* bef = [UIColor colorWithRed:0x3b/255.0f green:0x3e/255.0f blue:0x3f/255.0f alpha:1];
    
    if (TLabel == nil) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCalSelector)];
        
        TLabel = [[UIView alloc] init];
        TLabel.backgroundColor = [UIColor clearColor];
        [TLabel setFrame:CGRectMake(HVFRAME_LEFT_X, HVFRAME_LEFT_Y, HVFRAME_LEFT_W, HVFRAME_LEFT_H)];
        [TLabel addGestureRecognizer:singleTap];
        [self.headerView addSubview:TLabel];
    }
    NSArray* subviews = TLabel.subviews;
    for(UIView* sub in subviews)
    {
        [sub removeFromSuperview];
    }
    
    UILabel* yearLb = [[UILabel alloc] initWithFrame:CGRectZero];
    yearLb.text = [NSString stringWithFormat:@"%ld",(long)year];
    yearLb.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:23];
    yearLb.textColor = bef;
    yearLb.textAlignment = NSTextAlignmentLeft;
    yearLb.backgroundColor = [UIColor clearColor];
    [yearLb sizeToFit];
    [TLabel addSubview:yearLb];
    
    UILabel* yearStr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yearLb.frame)+1, CGRectGetMinY(yearLb.frame), 0, 0)];
    yearStr.text = @"年";
    yearStr.font = [UIFont fontWithName:@"chenyuxiao" size:23];
    yearStr.textColor = bef;
    yearStr.textAlignment = NSTextAlignmentLeft;
    yearStr.backgroundColor = [UIColor clearColor];
    [yearStr sizeToFit];
    [TLabel addSubview:yearStr];
    
    NSString* stext = @"";
    if (month < 10) {
        stext = [NSString stringWithFormat:@"0%ld",(long)month];
    }else{
        stext = [NSString stringWithFormat:@"%ld",(long)month];
    }
    
    UILabel* monthLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yearStr.frame)+1, CGRectGetMinY(yearStr.frame), 0, 0)];
    monthLb.text = stext;
    monthLb.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:23];
    monthLb.textColor = bef;
    monthLb.textAlignment = NSTextAlignmentLeft;
    monthLb.backgroundColor = [UIColor clearColor];
    [monthLb sizeToFit];
    [TLabel addSubview:monthLb];
    
    UILabel* monthStr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(monthLb.frame)+1, CGRectGetMinY(monthLb.frame), 0, 0)];
    monthStr.text = @"月";
    monthStr.font = [UIFont fontWithName:@"chenyuxiao" size:23];
    monthStr.textColor = bef;
    monthStr.textAlignment = NSTextAlignmentLeft;
    monthStr.backgroundColor = [UIColor clearColor];
    [monthStr sizeToFit];
    [TLabel addSubview:monthStr];
    
    CGFloat selX = CGRectGetMaxX(monthStr.frame)+9;
    CGFloat selCY = CGRectGetMidY(monthLb.frame);
    //时间选择器触发按钮
    if (calSelectorButton == nil) {
        calSelectorButton = [[UIButton alloc] init];
        [calSelectorButton addTarget:self action:@selector(openCalSelector) forControlEvents:UIControlEventTouchUpInside];
        [calSelectorButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
        [calSelectorButton setBackgroundColor:[UIColor clearColor]];
        [calSelectorButton setContentMode:UIViewContentModeScaleAspectFill];
        calSelectorButton.clipsToBounds = YES;
    }
    [calSelectorButton setFrame:CGRectMake(0, 0, 20, 20)];
    [calSelectorButton setCenter:CGPointMake(selX, selCY)];
    [TLabel addSubview:calSelectorButton];
    [TLabel setFrame:CGRectMake(HVFRAME_LEFT_X, HVFRAME_LEFT_Y, CGRectGetMaxX(calSelectorButton.frame), CGRectGetMaxY(monthStr.frame))];
}

- (void)openCalSelector
{
    if([self.flatDatePicker isOpen]){
        [self.flatDatePicker dismiss];
        [calSelectorButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }else{
        [self.flatDatePicker show];
        [calSelectorButton setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    }
}

//今天跳转🔘
- (void)loadTodayLinkButton
{
    if (TLabel == nil) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpBackCurrentMonthTime)];
        
        todayLinkButton = [[UIView alloc] init];
        todayLinkButton.backgroundColor = [UIColor clearColor];
        [todayLinkButton setFrame:CGRectMake(HVFRAME_TD_X, HVFRAME_TD_Y, HVFRAME_TD_W, HVFRAME_TD_H)];
        [todayLinkButton addGestureRecognizer:singleTap];
        [self.headerView addSubview:todayLinkButton];
    }
//    todayLinkButton = [[UIButton alloc]init];
//    todayLinkButton.userInteractionEnabled = YES;
//    todayLinkButton.frame = CGRectMake(HVFRAME_TD_X, HVFRAME_TD_Y, HVFRAME_TD_W, HVFRAME_TD_H);

//    [todayLinkButton addTarget:self action:@selector(jumpBackCurrentMonthTime) forControlEvents:UIControlEventTouchUpInside];
//    todayLinkButton.showsTouchWhenHighlighted = YES;
    
    
    UILabel* lable = [[UILabel alloc]init];
    lable.text = @"今天";
    lable.userInteractionEnabled = YES;
    lable.font = [UIFont fontWithName:@"chenyuxiao" size:21];
    lable.textColor = [UIColor colorWithRed:0xd9/255.0f green:0x24/255.0f blue:0x24/255.0f alpha:1];
    lable.backgroundColor = [UIColor clearColor];
    lable.frame = CGRectMake(0, 0, 28, 48 );
    lable.adjustsFontSizeToFitWidth = YES;
    lable.textAlignment = NSTextAlignmentCenter;
    [lable sizeToFit];
    
    [todayLinkButton addSubview:lable];
    [todayLinkButton sizeToFit];
    
    CGRect tlFrame = todayLinkButton.frame;
    CGFloat tdX = (SCREEN_WIDTH - CGRectGetWidth(lable.frame) - 15.0f);
    todayLinkButton.frame = CGRectMake(tdX, HVFRAME_TD_Y, CGRectGetWidth(lable.frame), CGRectGetHeight(tlFrame));
    [self.headerView addSubview:todayLinkButton];
}

- (void)jumpBackCurrentMonthTime
{
    if ([self.flatDatePicker isOpen]) {
        return;
    }
    if (strYear == [Datetime GetIntYear] && strMonth == [Datetime GetIntMonth]) {
        return;
    }
    NSInteger jumpYear = [Datetime GetIntYear];
    NSInteger jumpMonth = [Datetime GetIntMonth];
    
    BOOL largerDate = jumpYear > strYear?YES:NO;
    largerDate = ((largerDate == YES) || ((jumpMonth > strMonth) && (jumpYear == strYear)))?YES:NO;
    strYear = jumpYear;
    strMonth = jumpMonth;
    
//    [self reloadDateForCalendarWatch:largerDate];
    {
        [self loadTLabelTextWithYear:strYear andMonth:strMonth andOtherMsg:nil];
#if 0
        dayArray = nil,lunarDayArray = nil;
        dayArray = curDayArray;
        lunarDayArray = curLunarDayArray;
#else
        _dataList = nil;
        _dataList = _curDataList;
#endif
        
        [self reloadDaybuttenToCalendarWatch:largerDate];

    }
}

//向日历中添加星期标号（周日到周六）
-(void)AddWeekLableToCalendarWatch{
    if (dayCenterPoints) {
        [dayCenterPoints removeAllObjects];
        dayCenterPoints = nil;
    }
    dayCenterPoints = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray* array = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
//    CGFloat startY = HVFRAME_WEEK_START_Y;
    CGFloat startY = CGRectGetMaxY(TLabel.frame) + 6.0f; //((SCREEN_HEIGHT > 480 ?10.0f:6.0f));
    CGFloat startX = HVFRAME_WEEK_START_X;
    
    NSInteger curWeekday = [Datetime GetWeekDay] - 1;
    for (int i = 0; i < 7; i++) {
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:array[i]];
        lable.textColor = [UIColor colorWithRed:0x39/255.0f green:0x3d/255.0f blue:0x3e/255.0f alpha:1];
        lable.font = [UIFont systemFontOfSize:10];
        
        if (i == curWeekday) {
            lable.textColor = [UIColor colorWithRed:0xd9/255.0f green:0x24/255.0f blue:0x24/255.0f alpha:1];
        }
        lable.backgroundColor = [UIColor clearColor];
        lable.frame = CGRectMake(startX, startY, HVFRAME_WEEK_ITEM_W, HVFRAME_WEEK_ITEM_H);
        lable.adjustsFontSizeToFitWidth = YES;
        lable.textAlignment = NSTextAlignmentCenter;
        [lable sizeToFit];
        startX = startX + HVFRAME_WEEK_MARGIN + CGRectGetWidth(lable.frame);
        
        [self.headerView addSubview:lable];
        
        [dayCenterPoints addObject:lable];
        lable = nil;
    }
    array = nil;
}

#pragma mark -

#define MONTH_LAYOUT_START_X (12.0f)
//#define MONTH_LAYOUT_START_Y (HEADER_VIEW_HEIGHT)
//#define MONTH_LAYOUT_START_Y ((SCREEN_HEIGHT > 480)?(HEADER_VIEW_HEIGHT + 28.0f):(HEADER_VIEW_HEIGHT + 20.0f))
#define MONTH_LAYOUT_START_Y ((SCREEN_HEIGHT > 480)?(28.0f):(20.0f)) //增加一個View

#define MONTH_LAYOUT_ITEM_W (40.0f)
#define MONTH_LAYOUT_ITEM_H (40.0f)
#define MONTH_MARGIN_HOR (10.0f)

#define MONTH_MARGIN_VER ((SCREEN_HEIGHT > 480)?(40.0f):(28.0f))
//向日历中添加指定月份的日历buttun
-(void)AddDaybuttenToCalendarWatch{
    [self layoutLunarCalendarWithAnimations:kCATransitionFromTop];
}

- (LDayItemView* )dequeReusableDayItemViewByTag:(NSInteger)iTag
{
    if (dayButtonArrays == nil) {
        dayButtonArrays = [[NSMutableArray alloc] initWithCapacity:42];
    }
    if (iTag >= 42 || iTag < 0 || iTag > [dayButtonArrays count]) {
        return nil;
    }
    LDayItemView * button = nil;
    if (iTag == [dayButtonArrays count] ) {
        button = [[LDayItemView alloc]init];
        
        [button setActionTarget:self];
        [button setActionSelector:@selector(buttenTouchUpInsideAction:)];
        
        [button setTag:(iTag + 301)];
        CGFloat startX = MONTH_LAYOUT_START_X + (iTag%7)*MONTH_LAYOUT_ITEM_W + (iTag%7)*MONTH_MARGIN_HOR;
        CGFloat startY = MONTH_LAYOUT_START_Y + (iTag/7)*MONTH_LAYOUT_ITEM_H + (iTag/7)*MONTH_MARGIN_VER;
        button.frame = CGRectMake(startX,startY, MONTH_LAYOUT_ITEM_W, MONTH_LAYOUT_ITEM_H);
    
        [dayButtonArrays addObject:button];
        
        UILabel* weekday = [dayCenterPoints objectAtIndex:(iTag%7)];
        [button setCenter:CGPointMake(CGRectGetMidX(weekday.frame), CGRectGetMidY(button.frame))];
        [dayLayoutHouseView addSubview:button];
    }else{
        button = [dayButtonArrays objectAtIndex:iTag];
    }
    return button;
}

- (void)layoutLunarCalendarWithAnimations:(NSString *)transition//(UIViewAnimationTransition)transition
{
//    [self.view bringSubviewToFront:_headerView];
#if 0
    if (dayArray == nil || dayArray.count <= 0 || lunarDayArray == nil || lunarDayArray.count <= 0) {
        return;
    }
#else
    if (_dataList == nil || _dataList.count <= 0) {
        return;
    }
#endif
    if (dayLayoutHouseView == nil) {
//        dayLayoutHouseView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
        dayLayoutHouseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
        dayLayoutHouseView.backgroundColor = [UIColor clearColor];
    }
    [dayLayoutHouseView removeFromSuperview];
    
    for (NSInteger iTag = 0; iTag < 42; iTag++) {
        
        LDayItemView * button = [self dequeReusableDayItemViewByTag:iTag];
#if 0
        if ([NSString stringWithString:dayArray[iTag]] == nil || [NSString stringWithString:dayArray[iTag]].length <= 0) {
            [button isValidButton];
        }else{
            [button isFireButton];
        }
        
        if (([Datetime GetIntDay] == [dayArray[iTag] integerValue])&&(strMonth == [Datetime GetIntMonth])&&(strYear == [Datetime GetIntYear])) {
            
            [button setDayViewInformationText:dayArray[iTag] lunarText:lunarDayArray[iTag] isToday:YES];
        }else{
            [button setDayViewInformationText:dayArray[iTag] lunarText:lunarDayArray[iTag]];
        }
#else
        LunarDayModel* model = _dataList[iTag];
        BOOL isToday = NO;
        BOOL isCurMonth = YES;
        if (model.type == MONTH_TYPE_CURR && ([Datetime GetIntDay] == [model.day integerValue])&&(strMonth == [Datetime GetIntMonth])&&(strYear == [Datetime GetIntYear])
            ) {
            isToday = YES;
        }
        isCurMonth = model.type == MONTH_TYPE_CURR;
        
        [button setDayViewInformationTextEx:model.day lunarText:model.lunar isToday:isToday isCurrentMonth:isCurMonth];
        
        [button isFireButton];
#endif
    }
    if (transition == nil) {
        [dayLayoutHouseView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
        [baseViewHoldingTranslate addSubview:dayLayoutHouseView];
    }else{
    
        CATransition *catransition = [CATransition animation];
        catransition.duration = 0.35;
        [catransition setTimingFunction:UIViewAnimationCurveEaseInOut];
        catransition.type = kCATransitionPush; //choose your animation
        catransition.subtype = transition;
        [dayLayoutHouseView.layer addAnimation:catransition forKey:nil];
        
        
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.7];
    //    [UIView setAnimationTransition:transition
    //                           forView:self.view
    //                             cache:YES];
    //    [dayLayoutHouseView setFrame:CGRectMake(0, HEADER_VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
        [dayLayoutHouseView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
        [baseViewHoldingTranslate addSubview:dayLayoutHouseView];
    //    [UIView commitAnimations];
    }
}

-(void)buttenTouchUpInsideAction:(id)sender{
    if ([self isPickDateOperation]) {
        return;
    }
    NSInteger t = [sender tag]-301;
#if 0
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:strYear],@"year", [NSNumber numberWithInteger:strMonth],@"month",[NSNumber numberWithInteger:[dayArray[t] intValue]],@"day",nil];
#else
    LunarDayModel* model = _dataList[t];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:strYear],@"year", [NSNumber numberWithInteger:strMonth],@"month",[NSNumber numberWithInteger:[model.day intValue]],@"day",nil];
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTION_GOTO_DAY_NAME object:nil userInfo:userInfo];
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    if (calSelectorButton) {
        [calSelectorButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    [_flatDatePicker dismiss];
    if (calSelectorButton) {
        [calSelectorButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
//    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    if (strYear == year && strMonth == month) {
        return;
    }
    
    BOOL largerDate = year > strYear?YES:NO;
    largerDate = ((largerDate == YES) || ((month > strMonth) && (year == strYear)))?YES:NO;
    strYear = year;
    strMonth = month;
    [self reloadDateForCalendarWatch:largerDate];
}

#pragma mark - Initialize
- (FlatDatePicker *)flatDatePicker
{
    if (nil == _flatDatePicker) {
        _flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
        _flatDatePicker.delegate = self;
        _flatDatePicker.title = @"CoCrash";
        _flatDatePicker.datePickerMode = FlatDatePickerModeMonthYear;
    }
    return _flatDatePicker;
}

- (BOOL)isPickDateOperation
{
    return (_flatDatePicker && [_flatDatePicker isOpen]);
}

- (void)activate
{
    if ([self isPickDateOperation]) {
        _flatDatePicker.hidden = YES;
        [_flatDatePicker dismiss];
    }
    if (calSelectorButton) {
        [calSelectorButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        strYear = [Datetime GetIntYear];
        strMonth = [Datetime GetIntMonth];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (baseViewHoldingTranslate == nil) {
        baseViewHoldingTranslate = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEADER_VIEW_HEIGHT)];
        baseViewHoldingTranslate.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:baseViewHoldingTranslate];
    
    [self loadTodayLinkButton];
    [self loadTLabelTextWithYear:strYear andMonth:strMonth andOtherMsg:nil];
    [self AddWeekLableToCalendarWatch];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#if 0
        dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
        lunarDayArray = [Datetime GetLunarDayArrayByYear:strYear andMonth:strMonth];
        
        curDayArray = dayArray;
        curLunarDayArray = lunarDayArray;
#else
        _dataList = [Datetime GetLunarMonthViewDatasource:strYear andMonth:strMonth ];
        _curDataList = _dataList;
#endif
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self AddDaybuttenToCalendarWatch];
            [self layoutLunarCalendarWithAnimations:nil];
        });
    });
    [self AddHandleSwipe];
//    [self OtherTouchEvent];
    
}

#pragma mark -
//添加左右滑动手势
-(void)AddHandleSwipe{
    //声明和初始化手势识别器
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upHandleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downHandleSwipe:)];
    //对手势识别器进行属性设定
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [swipeUp setNumberOfTouchesRequired:1];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setNumberOfTouchesRequired:1];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    //把手势识别器加到view中去
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
}

//左滑事件
- (void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);

}

- (void)goNextMonth
{
    strMonth = strMonth+1;
    if(strMonth == 13){
        strYear++;strMonth = 1;
    }
    if (strYear > 2100) {
        return [self jumpBackCurrentMonthTime];
    }
    
    [self reloadDateForCalendarWatch:YES];
}

//右滑事件
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);

}

- (void)goPrevMonth
{
    strMonth = strMonth-1;
    if(strMonth == 0){
        strYear--;strMonth = 12;
    }
    //NSLog(@"%d,%d",strYear,strMonth);
    if (strYear < 1900) {
        return [self jumpBackCurrentMonthTime];
    }
    
    
    [self reloadDateForCalendarWatch:NO];
}

//上滑事件
- (void)upHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if ([self isPickDateOperation]) {
        return;
    }
    [self goNextMonth];
}

//下滑事件
- (void)downHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if ([self isPickDateOperation]) {
        [self activate];
        return;
    }
    [self goPrevMonth];
}

//在CalendarWatch中重新部署数据
-(void)reloadDateForCalendarWatch:(BOOL)largerDate{

    [self loadTLabelTextWithYear:strYear andMonth:strMonth andOtherMsg:nil];
    
#if 0
    dayArray = nil,lunarDayArray = nil;
    dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
    lunarDayArray = [Datetime GetLunarDayArrayByYear:strYear andMonth:strMonth];
#else
    _dataList = [Datetime GetLunarMonthViewDatasource:strYear andMonth:strMonth];
#endif
    [self reloadDaybuttenToCalendarWatch:largerDate];

}

-(void)reloadDaybuttenToCalendarWatch:(BOOL)largerDate{
    if (largerDate) {
        [self AddDaybuttenToCalendarWatch];
    }
    else
    {
        [self layoutLunarCalendarWithAnimations:kCATransitionFromBottom];
    }
}

@end
