//
//  UIButton+TCCustomFont.m
//  Heyzap
//
//  Created by Maximilian Tagher on 4/25/13.
//
//

#import "UIButton+TCCustomFont.h"

@implementation UIButton (TCCustomFont)

- (NSString *)fontName {
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end
