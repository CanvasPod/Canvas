//
//  CSAnimationView.h
//  Pods-Canvas
//
//  Created by Jamz Tang on 1/12/13.
//
//

#import <UIKit/UIKit.h>
#import "CSAnimation.h"

@interface CSAnimationView : UIView

@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, copy) CSAnimationType animationType;
@property (nonatomic) BOOL pauseAnimationOnAwake;  // If set, animation wont starts on awakeFromNib

@end


@interface UIView (CSAnimationView)

- (void)startCanvasAnimation;

@end