//
//  UITextView+TCCustomFont.m
//  RippleApp
//
//  Created by Meng To on 2/11/13.
//  Copyright (c) 2013 Ripple. All rights reserved.
//

#import "UITextView+TCCustomFont.h"

@implementation UITextView (TCCustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
