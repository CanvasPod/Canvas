//
//  CSNavigationController.m
//
//  Created by Jamz Tang on 3/12/13.
//

#import "CSNavigationController.h"
#import <objc/runtime.h>

@interface CSNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIColor *defaultTintColor;

@end

@implementation CSNavigationController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.defaultTintColor = self.navigationBar.barTintColor;
    self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.navigationBar.barTintColor = viewController.CSBarTintColor ?: self.defaultTintColor;
}

@end



@implementation UIViewController (CSNavigationBarTintColor)

- (void)setCSBarTintColor:(UIColor *)barTintColor {
    objc_setAssociatedObject(self, @selector(barTintColor), barTintColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)CSBarTintColor {
    return objc_getAssociatedObject(self, @selector(barTintColor));
}

@end