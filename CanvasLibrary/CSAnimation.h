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
static CSAnimationType CSAnimationTypeBounceRight  = @"bounceRight";
static CSAnimationType CSAnimationTypeBounceDown   = @"bounceDown";
static CSAnimationType CSAnimationTypeBounceUp     = @"bounceUp";
static CSAnimationType CSAnimationTypeFadeIn       = @"fadeIn";
static CSAnimationType CSAnimationTypeFadeOut       = @"fadeOut";
static CSAnimationType CSAnimationTypeFadeInLeft   = @"fadeInLeft";
static CSAnimationType CSAnimationTypeFadeInRight  = @"fadeInRight";
static CSAnimationType CSAnimationTypeFadeInDown   = @"fadeInDown";
static CSAnimationType CSAnimationTypeFadeInUp     = @"fadeInUp";
static CSAnimationType CSAnimationTypeSlideLeft    = @"slideLeft";
static CSAnimationType CSAnimationTypeSlideRight   = @"slideRight";
static CSAnimationType CSAnimationTypeSlideDown    = @"slideDown";
static CSAnimationType CSAnimationTypeSlideUp      = @"slideUp";
static CSAnimationType CSAnimationTypePop          = @"pop";
static CSAnimationType CSAnimationTypeMorph        = @"morph";
static CSAnimationType CSAnimationTypeFlash        = @"flash";
static CSAnimationType CSAnimationTypeShake        = @"shake";
static CSAnimationType CSAnimationTypeZoomIn       = @"zoomIn";
static CSAnimationType CSAnimationTypeZoomOut      = @"zoomOut";

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
