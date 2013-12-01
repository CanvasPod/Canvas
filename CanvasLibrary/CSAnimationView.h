//
//  CSAnimationView.h
//  Pods-Canvas
//
//  Created by Jamz Tang on 1/12/13.
//
//

#import <UIKit/UIKit.h>

typedef NSString *CSAnimation;

static CSAnimation CSAnimationsBounceLeft   = @"bounceLeft";
static CSAnimation CSAnimationsBounceDown   = @"bounceDown";
static CSAnimation CSAnimationsFadeIn       = @"fadeIn";
static CSAnimation CSAnimationsFadeInLeft   = @"fadeInLeft";
static CSAnimation CSAnimationsSlideLeft    = @"slideLeft";
static CSAnimation CSAnimationsFlash        = @"flash";


@interface CSAnimationView : UIView

@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, copy) CSAnimation animationType;
@property (nonatomic) BOOL pauseAnimationOnAwake;  // If set, animation wont starts on awakeFromNib

@end


@interface UIView (CSAnimationView)

- (void)startCanvasAnimation;

@end