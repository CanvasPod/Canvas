/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UITextField+PlaceholderColor.h"

@implementation UITextField (PlaceholderColor)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = placeholderColor;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
//        self.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    } else {
        // earlier than iOS 6.0
    }
}

@end
