/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@interface CSBlurView : UIView

@property (nonatomic) UIBarStyle barStyle;

+ (void) setBlur: (UIBarStyle)barStyle view:(UIView *)view;

@end
