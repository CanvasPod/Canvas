//
//  CSDynamics.m
//  Pods
//
//  Created by Meng To on 12/12/13.
//
//

#import "CSDynamics.h"

@implementation CSDynamics

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self class] setAnimator:self.animator setDuration:self.duration setDelay:self.delay view:self];
}

+ (void) setAnimator:(UIDynamicBehavior *)animator setDuration:(NSTimeInterval)duration setDelay:(NSTimeInterval)delay view:(UIView *)view {
    UIDynamicAnimator *myAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[view]];
    gravityBehaviour.gravityDirection = CGVectorMake(0, 10);
    [myAnimator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:view];
    [myAnimator addBehavior:itemBehaviour];
    
    animator = myAnimator;
}

@end
