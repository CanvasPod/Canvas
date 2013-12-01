//
//  CSAnimationView.m
//  Pods-Canvas
//
//  Created by Jamz Tang on 1/12/13.
//
//

#import "CSAnimationView.h"
#import <objc/runtime.h>
#import "CSBounceDown.h"
#import "CSBounceLeft.h"
#import "CSFadeIn.h"
#import "CSFadeInLeft.h"
#import "CSFlash.h"
#import "CSSlideLeft.h"

@implementation CSAnimationView

- (void)awakeFromNib {
    if (self.animationType && self.duration && ! self.pauseAnimationOnAwake) {
        [self startCanvasAnimation];
    }
}

- (void)startCanvasAnimation {

    if ([self.animationType isEqualToString:CSAnimationsBounceLeft]) {
        [CSBounceLeft setDuration:self.duration
                         setDelay:self.delay
                             view:self];
    } else if ([self.animationType isEqualToString:CSAnimationsBounceDown]) {
        [CSBounceDown setDuration:self.duration
                         setDelay:self.delay
                             view:self];
    } else if ([self.animationType isEqualToString:CSAnimationsFadeIn]) {
        [CSFadeIn setDuration:self.duration
                     setDelay:self.delay
                         view:self];
    } else if ([self.animationType isEqualToString:CSAnimationsFadeInLeft]) {
        [CSFadeInLeft setDuration:self.duration
                     setDelay:self.delay
                         view:self];
    } else if ([self.animationType isEqualToString:CSAnimationsSlideLeft]) {
        [CSSlideLeft setDuration:self.duration
                     setDelay:self.delay
                         view:self];
    } else if ([self.animationType isEqualToString:CSAnimationsFlash]) {
        [CSFlash setDuration:self.duration
                     setDelay:self.delay
                         view:self];
    } else {
        // Or you can do custom animations inline here, so
        // you won't need to create separate files
    }

    [super startCanvasAnimation];
}

@end



@implementation UIView (CSAnimationView)

- (void)startCanvasAnimation {
    [[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj startCanvasAnimation];
    }];
}

@end
