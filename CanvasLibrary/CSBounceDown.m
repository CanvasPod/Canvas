//
//  CSBounceDown.m
//  Carshare
//
//  Created by Meng To on 29/11/13.
//  Copyright (c) 2013 Wusi. All rights reserved.
//

#import "CSBounceDown.h"

@implementation CSBounceDown

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self class] setDuration:self.duration setDelay:self.delay view:self];
}

+ (void)setDuration:(NSTimeInterval)duration setDelay:(NSTimeInterval)delay view:(UIView *)view {
    // Start
    view.transform = CGAffineTransformMakeTranslation(0, -300);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        view.transform = CGAffineTransformMakeTranslation(0, -10);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            view.transform = CGAffineTransformMakeTranslation(0, 5);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                view.transform = CGAffineTransformMakeTranslation(0, -2);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    view.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

@end
