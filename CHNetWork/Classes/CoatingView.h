//
//  CoatingView.h
//  艺术蜥蜴
//
//  Created by admin on 15/3/23.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoatingView : UIView

@property (nonatomic,retain) UIActivityIndicatorView *activityView;
+ (CoatingView *)defaultCoating;

+ (void)showCoatingView;
+ (void)stopActivity;



@end
