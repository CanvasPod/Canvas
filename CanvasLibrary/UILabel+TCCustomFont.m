//
//  UILabel+TCCustomFont.m
//  Heyzap
//
//  Created by Maximilian Tagher on 4/25/13.
//
//

#import "UILabel+TCCustomFont.h"

@implementation UILabel (TCCustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
