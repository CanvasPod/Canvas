//
//  CSAnimation.h
//  Pods-Canvas
//
//  Created by Jamz Tang on 2/12/13.
//
//

#import <Foundation/Foundation.h>


typedef NSString *CSAnimationType;

static CSAnimationType CSAnimationTypeBounceLeft   = @"bounceLeft";
static CSAnimationType CSAnimationTypeBounceDown   = @"bounceDown";
static CSAnimationType CSAnimationTypeFadeIn       = @"fadeIn";
static CSAnimationType CSAnimationTypeFadeInLeft   = @"fadeInLeft";
static CSAnimationType CSAnimationTypeSlideLeft    = @"slideLeft";
static CSAnimationType CSAnimationTypeFlash        = @"flash";

extern NSString *const CSAnimationExceptionMethodNotImplemented;

@protocol CSAnimation <NSObject>

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval delay;

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end


@interface CSAnimation : NSObject <CSAnimation>

+ (void)registerClass:(Class)class forAnimationType:(CSAnimationType)animationType;
+ (Class)classForAnimationType:(CSAnimationType)animationType;

@end
