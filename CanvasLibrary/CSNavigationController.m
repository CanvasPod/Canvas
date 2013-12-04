/*
 * This file is part of the Canvas package.
 * (c) Canvas <usecanvas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSNavigationController.h"
#import <objc/runtime.h>

@interface CSNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIColor *defaultTintColor;
@property (nonatomic, strong) UIColor *beforeTransitionColor;

@end

@implementation CSNavigationController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.defaultTintColor = self.navigationBar.barTintColor;
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handlePopGestureRecognizer:)];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.beforeTransitionColor = navigationController.navigationBar.barTintColor;
    navigationController.navigationBar.barTintColor = viewController.CSBarTintColor ?: self.defaultTintColor;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.navigationBar.barTintColor = viewController.CSBarTintColor ?: self.defaultTintColor;
}

#pragma mark Action

- (IBAction)handlePopGestureRecognizer:(UIGestureRecognizer *)recognizer {
    CGPoint translation = [(UIPanGestureRecognizer *)recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (translation.x < CGRectGetWidth(self.view.bounds) / 2) {
            // reset the chagning tint
            self.navigationBar.barTintColor = self.beforeTransitionColor;
        } else {
        }
    }
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