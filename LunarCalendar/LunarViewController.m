//
//  LunarViewController.m
//  LunarCalendar
//
//  Created by haowenliang on 14-3-21.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LunarViewController.h"

#import "LDayViewController.h"
#import "LMonthViewController.h"
#import "LTableListViewController.h"

#import "SnowController.h"

#define THUMB_SCALE (1)
#define THUMB_SIZE CGSizeMake((THUMB_SCALE*([[UIScreen mainScreen] bounds].size.width)),(([[UIScreen mainScreen] bounds].size.height)*THUMB_SCALE))

@interface LunarViewController ()
{
    NSMutableArray* imgArray;
}

@property (nonatomic, retain) NSMutableArray* imgArray;
@end

@implementation LunarViewController
@synthesize vFlowView;

@synthesize imgArray = _imgArray;

- (NSMutableArray *)imgArray
{
    if (_imgArray && [_imgArray count] > 0) {
        return _imgArray;
    }

    ItemModel* model1 = [[ItemModel alloc] init];
    model1.itemType = ItemTypeDayView;
    model1.itemClass = @"LDayViewController";
    model1.itemObject = [[LDayViewController alloc] init];
    
    ItemModel* model2 = [[ItemModel alloc] init];
    model2.itemType = ItemTypeMonthView;
    model2.itemClass = @"LMonthViewController";
    model2.itemObject = [[LMonthViewController alloc] init];
    /*
    ItemModel* model3 = [[ItemModel alloc] init];
    model3.itemType = ItemTypeAboutView;
    model3.itemClass = @"LTableListViewController";
    model3.itemObject = [[LTableListViewController alloc] init];
    */
    
    _imgArray = [NSMutableArray arrayWithObjects:model1,model2,nil];
    
    return _imgArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openInfoViewController) name:ACTION_INFO_NAME object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToSpecifyDay:) name:ACTION_GOTO_DAY_NAME object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    vFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    vFlowView.delegate = self;
    vFlowView.dataSource = self;
    vFlowView.minimumPageAlpha = 1;//0.65;
    vFlowView.minimumPageScale = 1;//0.8;
//    vFlowView.orientation = PagedFlowViewOrientationVertical;
    [vFlowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self.view addSubview:vFlowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)openInfoViewController
{
    NSLog(@"openInfoViewController");
    LTableListViewController* about = [[LTableListViewController alloc] init];

    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.3;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
////    animation.type = @"suckEffect";
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromTop;
//    [self.view.window.layer addAnimation:animation forKey:nil];

//    about.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:about animated:YES completion:nil];
    about = nil;
}

- (void)goToSpecifyDay:(NSNotification*)notify
{
    NSDictionary* userInfo = [notify userInfo];

    ItemModel* model = [self.imgArray objectAtIndex:0];
    if ([model.itemObject respondsToSelector:@selector(resetYMDByYear:Month:Day:)]) {
        [model.itemObject resetYMDByYear:[[userInfo objectForKey:@"year"] integerValue] Month:[[userInfo objectForKey:@"month"] integerValue] Day:[[userInfo objectForKey:@"day"] integerValue]];
    }
    if ([model.itemObject respondsToSelector:@selector(activate)]) {
        [model.itemObject activate];
    }
    [vFlowView scrollToPage:0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;{
    return THUMB_SIZE;
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
//    NSLog(@"Scrolled to page # %ld", (long)index);
    ItemModel* model = [self.imgArray objectAtIndex:0];
    [[SnowController getInstanceWithParentView:[model.itemObject topView]] stopShakeEffect];
}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index{
//    NSLog(@"Tapped on page # %ld", (long)index);
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    return [self.imgArray count];
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    ItemModel* model = [self.imgArray objectAtIndex:index];
    if ([model.itemObject respondsToSelector:@selector(activate)]) {
        [model.itemObject activate];
    }
    return [model.itemObject view];
}

#pragma mark -搖啊搖
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

#pragma mark - 摇一摇动作处理
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([vFlowView currentPageIndex] != 0) {
        return;
    }
    ItemModel* model = [self.imgArray objectAtIndex:0];
    [[SnowController getInstanceWithParentView:[model.itemObject topView]] startShakeEffect];
}

@end


@implementation ItemModel

@synthesize itemClass;
@synthesize itemType;
@synthesize itemObject;

@end

