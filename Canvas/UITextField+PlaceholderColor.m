//
//  UITextField+PlaceholderColor.m
//  RippleApp
//
//  Created by Meng To on 2/11/13.
//  Copyright (c) 2013 Ripple. All rights reserved.
//

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
