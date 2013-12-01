//
//  CSBlur.h
//  Carshare
//
//  Created by Meng To on 26/11/13.
//  Copyright (c) 2013 Wusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSBlurView : UIView

@property (nonatomic) UIBarStyle barStyle;

+ (void) setBlur: (UIBarStyle)barStyle view:(UIView *)view;

@end
