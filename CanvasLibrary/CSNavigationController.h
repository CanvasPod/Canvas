//
//  CSNavigationController.h
//
//  Created by Jamz Tang on 3/12/13.
//

#import <UIKit/UIKit.h>

@interface CSNavigationController : UINavigationController

@end


@interface UIViewController (CSNavigationBarTintColor)

@property (nonatomic, strong) UIColor *CSBarTintColor;

@end