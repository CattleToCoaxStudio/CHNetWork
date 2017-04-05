//
//  CoatingView.m
//  艺术蜥蜴
//
//  Created by admin on 15/3/23.
//  Copyright (c) 2015年 admin. All rights reserved.
//
#import "CoatingView.h"

#define Window0  ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0])
@interface CoatingView ()
@property (nonatomic,retain) UIView *rootView;

@end

@implementation CoatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

+ (void)showCoatingView{
    [self defaultCoating];
    
    [self defaultCoating].rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self defaultCoating].rootView.center = CGPointMake([self defaultCoating].center.x, [self defaultCoating].center.y);
    [self defaultCoating].rootView.layer.cornerRadius = 6;
    [self defaultCoating].rootView.backgroundColor = [UIColor blackColor];
    [self defaultCoating].rootView.alpha = 0.7;
    [[self defaultCoating] addSubview:[self defaultCoating].rootView];
    
    [self defaultCoating].activityView = [[ UIActivityIndicatorView alloc ]
                         initWithFrame:CGRectMake(20,10,30.0,30.0)];
    [self defaultCoating].activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    //        self.activityView.hidesWhenStopped = NO;
    [self defaultCoating].activityView.center = [self defaultCoating].rootView.center;
    [[self defaultCoating] addSubview:[self defaultCoating].activityView];
    
    [Window0 addSubview:[self defaultCoating]];
    [self defaultCoating].hidden = NO;
    [[self defaultCoating].activityView startAnimating];
}

+ (void)stopActivity{
    [self defaultCoating].hidden = YES;
    [[self defaultCoating].activityView stopAnimating];
    [[self defaultCoating].rootView removeFromSuperview];
    
}

static CoatingView *waiting = Nil;
+ (CoatingView *)defaultCoating
{
    @synchronized(self){
        if (waiting == nil) {
            waiting = [[CoatingView alloc] init];
            waiting.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.5];
            waiting.frame =  [ UIScreen mainScreen ].bounds;
        }
    }
    return waiting;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if (waiting == nil) {
            waiting = [super allocWithZone:zone];
            return waiting;
        }
    }
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
