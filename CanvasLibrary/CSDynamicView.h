/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

@interface CSDynamicView : UIView

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *childViews;

+ (void)performAnimationsOnViews:(NSArray *)childViews
                        duration:(NSTimeInterval)duration
                           delay:(NSTimeInterval)delay
                        animator:(UIDynamicAnimator *)animator;

@end



@interface CSFallBehaviour : UIDynamicBehavior

- (instancetype)initWithItems:(NSArray *)items;

@end
