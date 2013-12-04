/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

@interface CSNavigationController : UINavigationController

@end


@interface UIViewController (CSNavigationBarTintColor)

@property (nonatomic, strong) UIColor *CSBarTintColor;

@end