//
//  LAboutViewController.m
//  LCalendar
//
//  Created by haowenliang on 14-2-25.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LAboutViewController.h"

@interface LAboutViewController ()

@end

@implementation LAboutViewController

@synthesize scrollView;

- (void)activate
{
    
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
    [self.view addSubview:[self customNavigateViewWithTitle:@"关于我们" backMsg:@"返回"]];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:RGBACOLOR(0xf3, 0xf3, 0xf3, 1)];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, NAV_HEADER_VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEADER_VIEW_HEIGHT)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEADER_VIEW_HEIGHT)];
    [imgV setBackgroundColor:[UIColor clearColor]];
//    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    UIImage* imageabc = [UIImage imageNamed:@"about_us_info.png"];
    imageabc = [imageabc stretchableImageWithLeftCapWidth:320 topCapHeight:(imageabc.size.height - 1)];
    [imgV setImage:imageabc];
    imgV.center = CGPointMake(SCREEN_WIDTH/2.0f, CGRectGetMidY(imgV.frame));
    [scrollView addSubview:imgV];
    
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), MAX(SCREEN_HEIGHT - 60,CGRectGetHeight(imgV.frame)))];
    [self.view sendSubviewToBack:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
