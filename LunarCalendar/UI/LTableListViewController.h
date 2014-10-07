//
//  LTableListViewController.h
//  LCalendar
//
//  Created by haowenliang on 14-3-19.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+UIDefine.h"

typedef enum{
    TLItemTypeGiveMeFive,
    TLItemTypeComments,
    TLItemTypeAboutUs,
    TLItemTypeInformation,
    TLItemTypeInviteFriend,

} TLItemType;

@interface LTableListViewController : UIViewController

@end


@interface TableListItemModel : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* msg;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic) TLItemType type;
@property (nonatomic, retain) NSString* imageName;

@end