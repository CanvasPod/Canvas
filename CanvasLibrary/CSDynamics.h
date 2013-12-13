/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

@interface CSDynamics : UIView

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic, strong) UIDynamicAnimator *animator;

+ (void) setAnimator: (UIDynamicBehavior *)animator setDuration: (NSTimeInterval)duration setDelay: (NSTimeInterval)delay view:(UIView *)view;

@end