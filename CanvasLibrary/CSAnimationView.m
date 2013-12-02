//
//  CSAnimationView.m
//  Pods-Canvas
//
//  Created by Jamz Tang on 1/12/13.
//
//

#import "CSAnimationView.h"

@implementation CSAnimationView

- (void)awakeFromNib {
    if (self.animationType && self.duration && ! self.pauseAnimationOnAwake) {
        [self startCanvasAnimation];
    }
}

- (void)startCanvasAnimation {
    
    Class <CSAnimation> class = [CSAnimation classForAnimationType:self.animationType];
    
    [class performAnimationOnView:self duration:self.duration delay:self.delay];

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
