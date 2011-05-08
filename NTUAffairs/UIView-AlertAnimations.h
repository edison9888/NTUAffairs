//
//  UIView-AlertAnimations.h
//  ObjectivePlurkApp_ver3
//
//  Created by fawkes1234 on 2010/9/4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface UIView(AlertAnimations)
- (void)doPopInAnimation;
- (void)doPopInAnimationWithDelegate:(id)animationDelegate;
- (void)doFadeInAnimation;
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate;
@end