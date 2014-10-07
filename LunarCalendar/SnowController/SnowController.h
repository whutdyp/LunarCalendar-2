//
//  SnowController.h
//  Snow
//
//  Created by haowenliang on 14-3-25.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnowController : NSObject
{
    NSMutableArray* _imageArray;
    NSString* _imageName;
    UIView* _parentView;
    NSInteger current_index;
    NSTimer* repeatTimer;
}
@property (nonatomic, retain) UIView* parentView;
@property (nonatomic, retain) NSString* imageName;
@property (nonatomic, retain) NSMutableArray* imageArray;

+ (SnowController*)getInstance;
+ (SnowController*)getInstanceWithParentView:(UIView*)parentV;
- (void)stopShakeEffect;
- (void)startShakeEffect;

@end
