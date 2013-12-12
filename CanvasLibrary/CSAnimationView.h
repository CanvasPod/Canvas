/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
#import "CSAnimation.h"

@interface CSAnimationView : UIView

@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) float distance;
@property (nonatomic) float damping;
@property (nonatomic) float velocity;
@property (nonatomic, strong) UIDynamicBehavior *animator;
@property (nonatomic, copy) CSAnimationType type;
@property (nonatomic) BOOL pauseAnimationOnAwake;  // If set, animation wont starts on awakeFromNib

@end


@interface UIView (CSAnimationView)

- (void)startCanvasAnimation;

@end