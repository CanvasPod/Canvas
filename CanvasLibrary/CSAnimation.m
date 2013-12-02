//
//  CSAnimation.m
//  Pods-Canvas
//
//  Created by Jamz Tang on 2/12/13.
//
//

#import "CSAnimation.h"

NSString *const CSAnimationExceptionMethodNotImplemented = @"CSAnimationExceptionMethodNotImplemented";

@interface CSAnimation ()


@end

@implementation CSAnimation

@synthesize duration = _duration;
@synthesize delay    = _delay;

static NSMutableDictionary *_animationClasses;

+ (void)load {
    _animationClasses = [[NSMutableDictionary alloc] init];
}

+ (void)performAnimationOnView:(UIView *)view
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay {
    [NSException raise:CSAnimationExceptionMethodNotImplemented format:@"+[%@ performAnimationOnView:duration:delay:] needed to be implemented", NSStringFromClass(self)];
}

+ (void)registerClass:(Class)class forAnimationType:(CSAnimationType)animationType {
    [_animationClasses setObject:class forKey:animationType];
}

+ (Class)classForAnimationType:(CSAnimationType)animationType {
    return [_animationClasses objectForKey:animationType];
}

@end

#pragma mark -

@interface CSBounceDown : CSAnimation

@end

@implementation CSBounceDown

+ (void)load {
    [self registerClass:self forAnimationType:CSAnimationTypeBounceDown];
}

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.transform = CGAffineTransformMakeTranslation(0, -300);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        view.transform = CGAffineTransformMakeTranslation(0, -10);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            view.transform = CGAffineTransformMakeTranslation(0, 5);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                view.transform = CGAffineTransformMakeTranslation(0, -2);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    view.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

@end


@interface CSBounceLeft : CSAnimation

@end

@implementation CSBounceLeft

+ (void)load {
    [self registerClass:self forAnimationType:CSAnimationTypeBounceLeft];
}

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.transform = CGAffineTransformMakeTranslation(300, 0);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        view.transform = CGAffineTransformMakeTranslation(-10, 0);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            view.transform = CGAffineTransformMakeTranslation(5, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                view.transform = CGAffineTransformMakeTranslation(-2, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    view.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

@end


@interface CSFadeIn : CSAnimation

@end

@implementation CSFadeIn

+ (void)load {
    [self registerClass:self forAnimationType:CSAnimationTypeFadeIn];
}

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.alpha = 0;
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        view.alpha = 1;
    } completion:^(BOOL finished) { }];
}

@end


@interface CSFlash : CSAnimation

@end

@implementation CSFlash

+ (void)load {
    [self registerClass:self forAnimationType:CSAnimationTypeFlash];
}

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.alpha = 0;
    [UIView animateKeyframesWithDuration:duration/3 delay:delay options:0 animations:^{
        // End
        view.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
            // End
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
                // End
                view.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

@end


@interface CSSlideLeft : CSAnimation

@end

@implementation CSSlideLeft

+ (void)load {
    [self registerClass:self forAnimationType:CSAnimationTypeSlideLeft];
}

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.transform = CGAffineTransformMakeTranslation(300, 0);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) { }];
}

@end


@interface CSFadeInLeft : CSAnimation

@end

@implementation CSFadeInLeft

+ (void)load {
    [self registerClass:self forAnimationType:CSAnimationTypeFadeInLeft];
}

+ (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    // Start
    view.alpha = 0;
    view.transform = CGAffineTransformMakeTranslation(300, 0);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        view.alpha = 1;
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) { }];
}

@end
