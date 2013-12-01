//
//  CSFadeIn.m
//  Carshare
//
//  Created by Meng To on 29/11/13.
//  Copyright (c) 2013 Wusi. All rights reserved.
//

#import "CSFadeIn.h"

@implementation CSFadeIn

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self class] setDuration:self.duration setDelay:self.delay view:self];
}

+ (void)setDuration:(NSTimeInterval)duration setDelay:(NSTimeInterval)delay view:(UIView *)view {
    // Start
    view.alpha = 0;
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        view.alpha = 1;
    } completion:^(BOOL finished) { }];
}

@end
