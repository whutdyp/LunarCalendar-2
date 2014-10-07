//
//  LTableHeaderView.m
//  LCalendar
//
//  Created by haowenliang on 14-3-19.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "LTableHeaderView.h"

@implementation LTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 214);
    self = [self initWithFrame:frame];
    if (self) {
        UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 21, 128, 128)];
        [imgV setBackgroundColor:[UIColor clearColor]];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.clipsToBounds = YES;
        [imgV setImage:[UIImage imageNamed:@"abouticon.png"]];
        imgV.center = CGPointMake(SCREEN_WIDTH/2.0f, CGRectGetMidY(imgV.frame));
        [self addSubview:imgV];
        
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        CFShow((__bridge CFTypeRef)(infoDictionary));
        // app名称
//        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        // app build版本
//        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        CGFloat versionY = CGRectGetMaxY(imgV.frame) + 22.0f;
        UILabel* version = [[UILabel alloc] init];
        version.text = [NSString stringWithFormat:@"版本: V%@", app_Version];
        version.backgroundColor = [UIColor clearColor];
        version.font = [UIFont systemFontOfSize:16];
        version.textColor = RGBACOLOR(0x69, 0x69, 0x6a, 1);
        version.textAlignment = NSTextAlignmentCenter;
        version.frame = CGRectMake(0, versionY, SCREEN_WIDTH - 30.0f, 20.0f);
        [version sizeToFit];
        
        version.center = CGPointMake(SCREEN_WIDTH/2.0f, CGRectGetMidY(version.frame));
        [self addSubview:version];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
