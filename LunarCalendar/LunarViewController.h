//
//  LunarViewController.h
//  LunarCalendar
//
//  Created by haowenliang on 14-3-21.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PagedFlowView.h"

typedef enum{
    ItemTypeDayView,
    ItemTypeMonthView,
    ItemTypeAboutView
}ItemType;

@interface LunarViewController : UIViewController<PagedFlowViewDelegate,PagedFlowViewDataSource>

@property (nonatomic, strong) PagedFlowView *vFlowView;

@end

@interface ItemModel : NSObject

@property (nonatomic) ItemType itemType;

@property (nonatomic, retain) NSString* itemClass;

@property (nonatomic, retain) id itemObject;

@end