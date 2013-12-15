/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSDynamicView.h"

@interface CSDynamicView () <UIDynamicAnimatorDelegate>
@property (nonatomic, copy) NSArray *originalChildViews;
@end


@implementation CSDynamicView

- (void)awakeFromNib {

    [super awakeFromNib];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.animator.delegate = self;
    
    self.originalChildViews = [self.childViews valueForKeyPath:@"frame"];

    [self startCanvasAnimation];
}

- (void)startCanvasAnimation {

    NSLog(@"start");
    [self.childViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setFrame:[self.originalChildViews[0] CGRectValue]];
    }];

    [[self class] performAnimationsOnViews:self.childViews
                                  duration:0
                                     delay:0
                                  animator:self.animator];

}

+ (void)performAnimationsOnViews:(NSArray *)childViews
                        duration:(NSTimeInterval)duration
                           delay:(NSTimeInterval)delay
                        animator:(UIDynamicAnimator *)animator {

    CSFallBehaviour *itemBehaviour = [[CSFallBehaviour alloc] initWithItems:childViews];
    [animator addBehavior:itemBehaviour];

}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator {
    [animator removeAllBehaviors];
}

@end

@implementation CSFallBehaviour

- (instancetype)initWithItems:(NSArray *)items {

    self = [super init];
    
    if (self) {

        UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:items];
        gravityBehaviour.gravityDirection = CGVectorMake(0, 10);

        [self addChildBehavior:gravityBehaviour];

        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:items];
        itemBehaviour.elasticity = 0.3;
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = obj;
            [itemBehaviour addAngularVelocity:-M_PI forItem:view];
        }];

        [self addChildBehavior:itemBehaviour];

        UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:items];

        collisionBehaviour.collisionMode = UICollisionBehaviorModeBoundaries;
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;

        [self addChildBehavior:collisionBehaviour];

    }

    return self;
}

@end
