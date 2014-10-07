//
//  LDayViewController.m
//  LCalendar
//
//  Created by haowenliang on 14-2-25.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LDayViewController.h"
#import "Datetime.h"

#define MARGIN_BOTTOM_HEIGHT (25.0f)
#define BASE_TEXT_COLOR [UIColor whiteColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:182/255.0f green:201/255.0f blue:173/255.0f alpha:1]

@class HoriLabel;
@interface LDayViewController ()
{
    NSDictionary* dataSource;
    NSInteger strDay;
    NSInteger strMonth;
    NSInteger strYear;
    
    HoriLabel* festival;
    HoriLabel* lunarInfo;
    UILabel* weekDay;
    UILabel* solarInfo;
    
    UIView* baseViewsHolder;
}

@end

@implementation LDayViewController

- (UIView* )topView
{
    if (baseViewsHolder == nil) {
        return self.view;
    }
    return baseViewsHolder;
}

- (void)activate
{
    [self refleshUI:YES withAnimation:UIViewAnimationTransitionNone];
}

- (void)resetYMDByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day
{
    strYear = year;
    strMonth = month;
    strDay = day;
    dataSource = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        strDay = [Datetime GetIntDay];
        strYear = [Datetime GetIntYear];
        strMonth = [Datetime GetIntMonth];
        dataSource = nil;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    baseViewsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    baseViewsHolder.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:baseViewsHolder];
    
    [self AddHandleSwipe];
    
    [self AddInformationButton];
//    [self OtherTouchEvent];
    
}


- (void)AddInformationButton
{
    UIButton* info = [[UIButton alloc] init];
    [info addTarget:self action:@selector(goToInformationViewController) forControlEvents:UIControlEventTouchUpInside];
    [info setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [info setBackgroundImage:[UIImage imageNamed:@"info_pressed.png"] forState:UIControlStateHighlighted];
    [info setBackgroundImage:[UIImage imageNamed:@"info_pressed.png"] forState:UIControlStateSelected];
    [info setBackgroundColor:[UIColor clearColor]];
    [info setContentMode:UIViewContentModeScaleAspectFill];
    info.clipsToBounds = YES;
    [info setFrame:CGRectMake(0, 0, 22, 22)];
    [info setCenter:CGPointMake((SCREEN_WIDTH - 15.0f - info.frame.size.width/2.0f), (SCREEN_HEIGHT - 25.0f - info.frame.size.height/2.0f))];
    
//    [self.view addSubview:info];
    [baseViewsHolder addSubview:info];
    info = nil;
}

- (void)goToInformationViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTION_INFO_NAME object:nil];
}

- (void)refleshUI:(BOOL)reloadData withAnimation:(UIViewAnimationTransition)transition
{
    if (baseViewsHolder == nil) {
        baseViewsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        baseViewsHolder.backgroundColor = BACKGROUND_COLOR;
        [self.view addSubview:baseViewsHolder];
        [self AddInformationButton];
    }
//    [baseViewsHolder removeFromSuperview];
    if (dataSource == nil || reloadData) {
        dataSource = nil;
        dataSource =[NSDictionary dictionaryWithDictionary:[Datetime GetFestivalDayByYear:strYear andMonth:strMonth andDay:strDay]];
    }
    if (lunarInfo ==  nil) {
        lunarInfo= [[HoriLabel alloc]initWithFrame:CGRectZero];
        [lunarInfo setFont:[UIFont fontWithName:@"chenyuxiao" size:43]];
        lunarInfo.lineMargin = 15.0f;
        lunarInfo.textColor = BASE_TEXT_COLOR;
//        [self.view addSubview:lunarInfo];
        [baseViewsHolder addSubview:lunarInfo];
    }
    [lunarInfo setFrame:CGRectMake(0, 0, 64, 200)];
    [lunarInfo setContent:[dataSource objectForKey:@"lunar"]];
    [lunarInfo setCenter:CGPointMake(SCREEN_WIDTH/2.0, (SYSTEM_VERSION_LESS_THAN(@"7.0")?25.0f:45.0f)+lunarInfo.frame.size.height/2.0)];

    
    if (festival == nil) {
        festival= [[HoriLabel alloc]initWithFrame:CGRectZero];
        UIFont * fontOne = [UIFont fontWithName:@"chenyuxiao" size:25];
        festival.font = fontOne;//Hiragino Kaku Gothic ProN
        festival.lineMargin = 7.0f;
        festival.hasBrackets = YES;
        festival.textColor = BASE_TEXT_COLOR;
//        [self.view addSubview:festival];
        [baseViewsHolder addSubview:festival];
    }
    [festival setFrame:CGRectMake(0, 0, 26, 84)];
    [festival setContent:[dataSource objectForKey:@"festival"]];
    festival.center = CGPointMake(CGRectGetMaxX(lunarInfo.frame)+ CGRectGetWidth(festival.frame)/2.0f + 15.0f, CGRectGetMinY(lunarInfo.frame) + CGRectGetHeight(festival.frame)/2.0f + 20.0f);
    
    
    if (solarInfo == nil) {
        solarInfo = [[UILabel alloc]initWithFrame:CGRectZero];
        solarInfo.backgroundColor = [UIColor clearColor];
        solarInfo.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:18];//DBLCDTempBlack
        solarInfo.textColor = BASE_TEXT_COLOR;
        solarInfo.textAlignment = NSTextAlignmentCenter;
        solarInfo.numberOfLines = 1;
//        [self.view addSubview:solarInfo];
        [baseViewsHolder addSubview:solarInfo];
    }
    solarInfo.text = [NSString stringWithFormat:@"%ld/%ld/%ld",(long)strYear,(long)strMonth,(long)strDay];

    CGSize ssize = [self labelDisplayHorizontal:solarInfo.text withFont:solarInfo.font];
    solarInfo.frame = CGRectMake(0, 0, ssize.width, ssize.height);

    if (weekDay == nil) {
        weekDay = [[UILabel alloc]initWithFrame:CGRectZero];
        weekDay.backgroundColor = [UIColor clearColor];
        weekDay.font = [UIFont fontWithName:@"chenyuxiao" size:18];
        weekDay.textColor = BASE_TEXT_COLOR;
        weekDay.shadowColor = [UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1];
        weekDay.shadowOffset = CGSizeMake(0, 1);
        weekDay.textAlignment = NSTextAlignmentCenter;
        weekDay.numberOfLines = 1;
        [self.view addSubview:weekDay];
        [baseViewsHolder addSubview:weekDay];
    }
    weekDay.text = [dataSource objectForKey:@"weekday"];
    CGSize wsize = [self labelDisplayHorizontal:weekDay.text withFont:weekDay.font];
    weekDay.frame = CGRectMake(0, 0, wsize.width, wsize.height);

    
    solarInfo.center = CGPointMake(160.0f, SCREEN_HEIGHT - CGRectGetHeight(solarInfo.frame)/2.0f - MARGIN_BOTTOM_HEIGHT);

    weekDay.center = CGPointMake(160.0f, CGRectGetMinY(solarInfo.frame) - CGRectGetHeight(weekDay.frame)/2.0f - 5.0f);
    
    if (transition != UIViewAnimationTransitionCurlDown && transition != UIViewAnimationTransitionCurlUp) {
        [self.view addSubview:baseViewsHolder];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationTransition:transition
                               forView:self.view
                                 cache:YES];
        [self.view addSubview:baseViewsHolder];
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)labelDisplayVertically:(NSString*)content withFont:(UIFont *)font
{
    NSString *text = @"文";
//    UIFont *font = [UIFont systemFontOfSize:12];
    
    CGFloat w = 0.0f;
    CGSize sizeStr = CGSizeZero;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        CGSize sizeWord = [text sizeWithFont:font constrainedToSize:CGSizeMake(320, 2000.0) lineBreakMode:NSLineBreakByCharWrapping];
        
        w = sizeWord.width;//一个汉字的宽度
        sizeStr = [content sizeWithFont:font constrainedToSize:CGSizeMake(w, 2000.0) lineBreakMode:NSLineBreakByCharWrapping];
    }
    else{
        NSDictionary* attributes = @{NSFontAttributeName:font};
        w = [text boundingRectWithSize:CGSizeMake(320.0, 2000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
        CGRect rect = [content boundingRectWithSize:CGSizeMake(w, 2000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        sizeStr = rect.size;
    }
    
    CGFloat h = sizeStr.height;
    return CGSizeMake(w, h);
}

- (CGSize)labelDisplayHorizontal:(NSString*)content withFont:(UIFont *)font
{
    NSString *text = @"文";
    CGFloat h = 0.0;
    CGSize sizeStr = CGSizeZero;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        CGSize sizeWord = [text sizeWithFont:font constrainedToSize:CGSizeMake(320, 2000.0) lineBreakMode:NSLineBreakByCharWrapping];
        
        h = sizeWord.height;//一个汉字的高度
        sizeStr = [content sizeWithFont:font constrainedToSize:CGSizeMake(320, h) lineBreakMode:NSLineBreakByCharWrapping];
    }
    else{
        NSDictionary* attributes = @{NSFontAttributeName:font};
        h = [text boundingRectWithSize:CGSizeMake(320.0, 2000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
        
        CGRect rect = [content boundingRectWithSize:CGSizeMake(320.0f, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        sizeStr = rect.size;
    }
    
    return sizeStr;
}

#pragma mark -滑動手勢

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
    
//    [self goNextDay];
}

- (void)goNextDay
{
    NSDictionary* iDate = [Datetime GetNextDateByYear:strYear andMonth:strMonth andDay:strDay];
    strYear = [[iDate objectForKey:@"year"] integerValue];
    strMonth = [[iDate objectForKey:@"month"] integerValue];
    strDay = [[iDate objectForKey:@"day"] integerValue];
    //NSLog(@"%d,%d",strYear,strMonth);
    [self refleshUI:YES withAnimation:UIViewAnimationTransitionCurlUp];
}

//右滑事件
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);
//    [self goPrevDay];
}

- (void)goPrevDay
{
    NSDictionary* iDate = [Datetime getPreviousDateByYear:strYear andMonth:strMonth andDay:strDay];
    strYear = [[iDate objectForKey:@"year"] integerValue];
    strMonth = [[iDate objectForKey:@"month"] integerValue];
    strDay = [[iDate objectForKey:@"day"] integerValue];
    //NSLog(@"%d,%d",strYear,strMonth);
    [self refleshUI:YES withAnimation:UIViewAnimationTransitionCurlDown];
}

//上滑事件
- (void)upHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self goNextDay];
}

//下滑事件
- (void)downHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self goPrevDay];
}

//-(UIFont*)customFont
//{// 你的字体路径
//    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"chenyuxiao" ofType:@"ttf"];
//    
//    NSURL *url = [NSURL fileURLWithPath:fontPath];
//    
//    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
//    if (fontDataProvider == NULL)        return nil;
//    
//    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
//    CGDataProviderRelease(fontDataProvider);
//    if (newFont == NULL) return nil;
//    
//    NSString *fontName = (__bridge NSString *)CGFontCopyFullName(newFont);
//    UIFont *font = [UIFont fontWithName:fontName size:48];
//    NSLog(@"fontName = %@",fontName);
//    CGFontRelease(newFont);
////    CGFontRelease(fontName);
//
//    return font;
//}

@end

@implementation HoriLabel
{
    NSMutableArray* labelContent;
}

@synthesize font = _font;
@synthesize content = _content;
@synthesize lineMargin;
@synthesize textColor = _textColor;
@synthesize hasBrackets;

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        lineMargin = 5.0f;
        _textColor = BASE_TEXT_COLOR;
        hasBrackets = NO;
    }
    return self;
}

- (UIFont *)font
{
    if (_font == nil) {
        _font = [UIFont fontWithName:@"chenyuxiao" size:24];
    }
    return _font;
}

- (void)setContent:(NSString *)content
{
    if (_content) {
        _content = nil;
    }
    _content = [NSString stringWithString:content];
    
    [self updateUILabel];
}

- (void)updateUILabel
{
    if (nil == _content || _content.length <= 0) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    if (nil == labelContent) {
        labelContent = [[NSMutableArray alloc] initWithCapacity:1];
    }
    [labelContent removeAllObjects];
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSInteger count = _content.length;
    CGFloat sx = 0.0f;
    CGFloat sy = lineMargin;
    CGFloat width = 48;
    CGFloat height = 48.0f;
    
    if (hasBrackets) {
        UIImageView* brack1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 9)];
        brack1.contentMode = UIViewContentModeScaleAspectFill;
        brack1.backgroundColor = [UIColor clearColor];
        brack1.image = [UIImage imageNamed:@"kuohao1.png"];
        [self addSubview:brack1];
        brack1.center = CGPointMake(self.frame.size.width/2.0, CGRectGetMidY(brack1.frame));
        sy += 9;
    }
    
    for(int i = 0; i < count; i++)
    {
        UILabel* lunar= [[UILabel alloc]initWithFrame:CGRectMake(sx, sy, width, height)];
        lunar.backgroundColor = [UIColor clearColor];
        lunar.font = self.font;
        lunar.textColor = _textColor;
        lunar.numberOfLines = 1;
        lunar.shadowColor = [UIColor colorWithRed:0x9a/255.0f green:0x9a/255.0f blue:0x9a/255.0f alpha:1];
        lunar.shadowOffset = CGSizeMake(0, 1);
        lunar.textAlignment = NSTextAlignmentCenter;
        lunar.text = [_content substringWithRange:NSMakeRange(i, 1)];
        [lunar sizeToFit];
        [lunar setCenter:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(lunar.frame))];
        [self addSubview:lunar];
        
        sy = CGRectGetMaxY(lunar.frame) + lineMargin;
        lunar = nil;
    }
    
    if (hasBrackets) {
        UIImageView* brack2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, sy, 22, 9)];
        brack2.contentMode = UIViewContentModeScaleAspectFill;
        brack2.backgroundColor = [UIColor clearColor];
        brack2.image = [UIImage imageNamed:@"kuohao2.png"];
        [self addSubview:brack2];
        brack2.center = CGPointMake(self.frame.size.width/2.0, CGRectGetMidY(brack2.frame));
        sy += 9;
    }
    
    CGRect fr = self.frame;
    [self setFrame:CGRectMake(CGRectGetMinX(fr), CGRectGetMinY(fr), CGRectGetWidth(fr), sy)];
}

@end
