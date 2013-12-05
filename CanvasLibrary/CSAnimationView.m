/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSAnimationView.h"

@implementation CSAnimationView

- (void)awakeFromNib {
    if (self.type && self.duration && ! self.pauseAnimationOnAwake) {
        [self startCanvasAnimation];
    }
}

- (void)startCanvasAnimation {
    
    Class <CSAnimation> class = [CSAnimation classForAnimationType:self.type];
    
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
