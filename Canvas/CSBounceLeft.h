//
//  CSBounceLeft.h
//  Carshare
//
//  Created by Meng To on 29/11/13.
//  Copyright (c) 2013 Wusi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSBounceLeft : UIView

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval delay;

+ (void) setDuration: (NSTimeInterval)duration setDelay: (NSTimeInterval)delay view:(UIView *)view;

@end

