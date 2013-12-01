//
//  CSBlur.m
//  Carshare
//
//  Created by Meng To on 26/11/13.
//  Copyright (c) 2013 Wusi. All rights reserved.
//

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
    [view insertSubview:toolbar atIndex:0];
}

@end