//
//  CSTabBarViewController.m
//  Canvas
//
//  Created by Jamz Tang on 2/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSTabBarViewController.h"
#import "URBMediaFocusViewController.h"

@interface CSTabBarViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *tappedImageView;

@end


@implementation CSTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    // Configure our CoreData context
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(setManagedObjectContext:)]) {
            [obj setManagedObjectContext:self.managedObjectContext];
        }
    }];
}

- (IBAction)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    URBMediaFocusViewController *controller = [[URBMediaFocusViewController alloc] init];
    [controller showImage:self.tappedImageView.image fromView:self.view inViewController:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIImageView class]]) {
        self.tappedImageView = (UIImageView *)touch.view;
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
}

@end
