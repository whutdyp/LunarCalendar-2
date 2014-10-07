//
//  LTableListViewController.m
//  LCalendar
//
//  Created by haowenliang on 14-3-19.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LTableListViewController.h"
#import "LTableHeaderView.h"
#import "LAboutViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

//#define SINGLE_SECTION


@interface LTableListViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray* datasource;
@property (nonatomic, retain) UITableView* usrTableView;

@end

@implementation LTableListViewController
@synthesize datasource = _datasource;
@synthesize usrTableView = _usrTableView;


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
    self.title = @"关于";
    [self.view setBackgroundColor:[UIColor colorWithRed:0xf3/255.0f green:0xf3/255.0f blue:0xf3/255.0 alpha:1]];
    
    [self initDatasource];
	// Do any additional setup after loading the view.
    _usrTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEADER_VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEADER_VIEW_HEIGHT) style:UITableViewStyleGrouped];
    _usrTableView.dataSource = self;
    _usrTableView.delegate = self;
    _usrTableView.backgroundColor = [UIColor colorWithRed:0xf3/255.0f green:0xf3/255.0f blue:0xf3/255.0 alpha:1];
    
    [self.view addSubview:_usrTableView];
    
    LTableHeaderView* header = [[LTableHeaderView alloc] init];
    [header setBackgroundColor:[UIColor colorWithRed:0xf3/255.0f green:0xf3/255.0f blue:0xf3/255.0 alpha:1]];
    _usrTableView.tableHeaderView = header;
    header = nil;

    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor colorWithRed:0xf3/255.0f green:0xf3/255.0f blue:0xf3/255.0 alpha:1];
    [_usrTableView setBackgroundView:bview];
    
    [self.view addSubview:[self customNavigateView]];
}

- (void)initDatasource
{
    if (_datasource) {
        [_datasource removeAllObjects];
    }
    _datasource = nil;
    _datasource = [[NSMutableArray alloc] initWithCapacity:1];
    
    TableListItemModel* item1 = [[TableListItemModel alloc] init];
    item1.title = @"赏个好评～";
    item1.msg = @"";
    item1.url = nil;
//    item1.imageName = @"shareReview.png";
    item1.imageName = nil;
    item1.type = TLItemTypeGiveMeFive;
    
    TableListItemModel* item2 = [[TableListItemModel alloc] init];
    item2.title = @"反馈&建议";
    item2.msg = @"";
    item2.url = nil;
//    item2.imageName = @"shareMail.png";
    item2.imageName = nil;
    item2.type = TLItemTypeComments;
    
//    
//    TableListItemModel* item5 = [[TableListItemModel alloc] init];
//    item5.title = @"分享APP";
//    item5.msg = @"";
//    item5.url = nil;
//    item5.imageName = @"inviteFriend.png";
//    item5.type = TLItemTypeInviteFriend;
    
    TableListItemModel* item3 = [[TableListItemModel alloc] init];
    item3.title = @"关于我们";
    item3.msg = @"";
    item3.url = nil;
//    item3.imageName = @"inviteFriend.png";
    item3.imageName = nil;
    item3.type = TLItemTypeAboutUs;
    
#ifndef SINGLE_SECTION
    NSMutableArray* section = [NSMutableArray arrayWithObjects:item1,item2,item3, nil];
    [_datasource addObject:section];
#endif
    

    
//    TableListItemModel* item4 = [[TableListItemModel alloc] init];
//    item4.title = @"版本信息";
//    item4.msg = @"";
//    item4.url = nil;
//    item4.imageName = nil;
//    item4.type = TLItemTypeInformation;
//
//#ifndef SINGLE_SECTION
//    NSMutableArray* section2 = [NSMutableArray arrayWithObjects:item3,item4, nil];
//    [_datasource addObject:section2];
//#endif
    
#ifdef SINGLE_SECTION
    [_datasource addObject:item1];
    [_datasource addObject:item2];
    [_datasource addObject:item3];
//    [_datasource addObject:item4];
//    [_datasource addObject:item5];
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark -
//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#ifdef SINGLE_SECTION
    return 1;
#else
    return _datasource.count;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef SINGLE_SECTION
    return _datasource.count;
#else
    return [_datasource[section] count];
#endif
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * showUserInfoCellIdentifier = @"ShowInfoCell";
#ifdef SINGLE_SECTION
    TableListItemModel* model = _datasource[indexPath.row];
#else
    TableListItemModel* model = [_datasource[indexPath.section] objectAtIndex:indexPath.row];
#endif
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
	if (cell == nil)
	{
		// Create a cell to display an ingredient.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:showUserInfoCellIdentifier];
	}
	
	// Configure the cell.
//	cell.textLabel.text= model.title;
//    cell.textLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:16];
//    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
//	cell.detailTextLabel.text = model.msg;
    
    CGFloat sy = 15.0f;
    if (model.imageName) {
        UIImageView* imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 36, 36)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.backgroundColor = [UIColor clearColor];
        imageV.image = [UIImage imageNamed:model.imageName];
        
        [cell.contentView addSubview:imageV];
        sy += 36 + 10;
    }
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sy, 9, 120, 18)];
    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:16];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.highlightedTextColor = [UIColor whiteColor];
    titleLabel.text = model.title;
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(CGRectGetMidX(titleLabel.frame), CGRectGetMidY(cell.frame));
    [cell.contentView addSubview:titleLabel];
    
//    if (model.type == TLItemTypeNone) {
//        cell.userInteractionEnabled = NO;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }else
    {
        cell.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor colorWithRed:0x00/255.0f green:0x79/255.0f blue:0xff/255.0f alpha:1];
    cell.selectedBackgroundView = bgView;
    bgView = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

#ifdef SINGLE_SECTION
    TableListItemModel* model = _datasource[indexPath.row];
#else
    TableListItemModel* model = [_datasource[indexPath.section] objectAtIndex:indexPath.row];
#endif
    switch (model.type) {
        case TLItemTypeAboutUs:
        case TLItemTypeInformation:
        {
            LAboutViewController* about = [[LAboutViewController alloc] init];
            
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            //    animation.type = @"suckEffect";
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:animation forKey:nil];
            
            //    about.modalTransitionStyle = UIModalTransitionStylePartialCurl;
            [self presentViewController:about animated:NO completion:nil];
            about = nil;
        }
            break;
//        case TLItemTypeAboutUs:
//        {
//            
//        }
//            break;
        case TLItemTypeGiveMeFive:
        {
//            https://itunes.apple.com/us/app/pu-su-nong-li/id859250827?ls=1&mt=8
//            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",4567865];
            NSString* str = @"https://itunes.apple.com/us/app/pu-su-nong-li/id859250827?l=zh&ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case TLItemTypeComments:
        {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            
            NSArray *usersTo = [NSArray arrayWithObjects:@"nux.software@gmail.com",nil];
            [controller setToRecipients:usersTo];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//            CFShow((__bridge CFTypeRef)(infoDictionary));
            // app名称
            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
//            NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
            
            NSString* subject = [NSString stringWithFormat:@"关于%@的建议和问题反馈",app_Name];
            [controller setSubject:subject];
            
            NSString* bodyString = [NSString stringWithFormat:@"APP名称：%@\n\tAPP版本：%@\n\t请写下你宝贵的意见和建议，我们会尽快回复\n\n\n\n",app_Name,app_Version];
            [controller setMessageBody:bodyString isHTML:NO];
//            [self presentModalViewController:controller animated:YES];
            if (controller) {
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
            break;
        case TLItemTypeInviteFriend:
        {
            NSURL *URL = [NSURL URLWithString:@"http://www.cnblogs.com/IlvDanping1024"];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:nil];
//            [self presentViewController:activityViewController animated:YES completion:nil];
                [self presentViewController:activityViewController animated:YES completion:nil];
        }break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - mail delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    //    MFMailComposeResultCancelled,//用户取消编辑邮件
    //    MFMailComposeResultSaved,//用户成功保存邮件
    //    MFMailComposeResultSent,//用户点击发送，将邮件放到队列中
    //    MFMailComposeResultFailed//用户试图保存或者发送邮件失败
    switch (result) {
        case MFMailComposeResultCancelled:{
            
        }break;
        case MFMailComposeResultFailed:{
            
        }
            break;
        case MFMailComposeResultSaved:{
            
        }
            break;
        case MFMailComposeResultSent:{
            
        }
            break;
        default:
            break;
    }
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end


@implementation TableListItemModel


@end
