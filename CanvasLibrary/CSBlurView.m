/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSBlurView.h"

@implementation CSBlurView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self class] setBlur:self.barStyle view:self];
}

+ (void) setBlur: (UIBarStyle)barStyle view:(UIView *)view {
    view.clipsToBounds=YES;
    CALayer *l=view.layer;
    [l setBorderWidth:0];
    view.opaque = NO;
    view.backgroundColor = nil;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:view.bounds];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toolbar.barTintColor = view.backgroundColor;
    toolbar.barStyle = barStyle;
    toolbar.clipsToBounds = YES;
    [view insertSubview:toolbar atIndex:0];
}

@end