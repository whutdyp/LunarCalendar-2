//
//  SnowController.m
//  Snow
//
//  Created by haowenliang on 14-3-25.
//  Copyright (c) 2014年 haowenliang. All rights reserved.
//

#import "SnowController.h"

#define SNOW_IMAGENAME         @"flower"
#define LOAD_IMAGE_NAME(NAME)        [UIImage imageNamed:NAME]
#define IMAGE_X                arc4random()%(int)SCREEN_HEIGHT
#define IMAGE_ALPHA            ((float)(arc4random()%5))/5
#define IMAGE_WIDTH            arc4random()%20 + 15
#define PLUS_HEIGHT            SCREEN_HEIGHT/25

#define DURATION_SECOND (5)
#define MAX_NUMBER_OF_SNOW (30)
//#define EFFECT_TAG (90213)
//static NSInteger current_index = 0;

static SnowController* s_instance = nil;


@implementation SnowController
@synthesize imageArray = _imageArray;
@synthesize imageName = _imageName;
@synthesize parentView = _parentView;

+ (SnowController*)getInstance
{
    if (s_instance == nil) {
        s_instance = [[SnowController alloc] init];
    }
    return s_instance;
}

+ (NSString* )getDropThingName:(NSUInteger)index
{
    NSArray* imagename = @[@"red-envelope",@"flower",@"xigua",@"bean",@"snow"];
    return [imagename objectAtIndex:index];
}

+ (SnowController*)getInstanceWithParentView:(UIView*)parentV
{
    if (s_instance == nil) {
        s_instance = [[SnowController alloc] initWithParentView:parentV];
    }
    return s_instance;
}


- (UIView *)parentView
{
    if (_parentView == nil) {
        return [[UIApplication sharedApplication] keyWindow];
    }
    return _parentView;
}

- (NSString *)imageName
{
    if (_imageName == nil || _imageName.length <= 0) {
        _imageName = [SnowController getDropThingName:arc4random()%5];
    }
    return _imageName;
//    return [SnowController getDropThingName:arc4random()%5];
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil || _imageArray.count <= 0) {
        _imageArray = nil;
        _imageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < MAX_NUMBER_OF_SNOW; ++ i) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:LOAD_IMAGE_NAME(self.imageName)];
            float x = IMAGE_WIDTH;
            imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
            imageView.alpha = IMAGE_ALPHA;
            imageView.hidden = YES;
            [_imageArray addObject:imageView];
        }
    }
    return _imageArray;
}

- (id)init
{
    self = [super init];
    if (self) {
        current_index = 0;
    }
    return self;
}

- (id)initWithParentView:(UIView*)parent
{
    self = [super init];
    if (self) {
        _parentView = parent;
        current_index = 0;
    }
    return self;
}

- (BOOL)isEffecting
{
    if (current_index > 0 && current_index < MAX_NUMBER_OF_SNOW) {
        return YES;
    }
    return NO;
}

- (void)stopShakeEffect
{
    [repeatTimer invalidate];
    current_index = 0;
    
    @synchronized(_imageArray){
        [_imageArray enumerateObjectsUsingBlock:^(UIImageView* obj, NSUInteger idx, BOOL *stop) {
            obj.hidden = YES;
            [obj removeFromSuperview];
        }];
    }
}

- (void)startShakeEffect
{
    if ([self isEffecting]) {
        return;
    }
    repeatTimer = nil;
    repeatTimer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(dropObjectsEffect) userInfo:nil repeats:YES];
    [repeatTimer fire];
}

- (void)dropObjectsEffect
{
    NSInteger count = self.imageArray.count;
    NSLog(@"dropObjectEffect %ld ---- %ld",(long)count, (long)current_index);
    current_index = current_index + 1;
    if (count > 0 && current_index <= MAX_NUMBER_OF_SNOW) {
        UIImageView *imageView = [_imageArray objectAtIndex:0];
        imageView.tag = current_index;
        imageView.hidden = NO;
        [_imageArray removeObjectAtIndex:0];
        
        [self.parentView addSubview:imageView];
        [self makeEffectSense:imageView];
    }else{
        [self stopShakeEffect];
    }
}


- (void)makeEffectSense:(UIImageView* )aImageView
{
    [UIView beginAnimations:[NSString stringWithFormat:@"%ld",(long)aImageView.tag] context:nil];
    [UIView setAnimationDuration:DURATION_SECOND];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, SCREEN_HEIGHT, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *imageView = (UIImageView *)[_parentView viewWithTag:[animationID intValue]];
    if(imageView == nil)
    {
        NSLog(@"object lost");
        return;
    }
    imageView.hidden = YES;
    float x = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
    [_imageArray addObject:imageView];
    [imageView removeFromSuperview];
}

@end
