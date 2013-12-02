//
//  ViewController.m
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSUsageViewController.h"
#import "CSAnimationView.h"

@interface CSUsageViewController ()

@end

@implementation CSUsageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
    
    self.scrollView.contentSize = CGSizeMake(320, 640);
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-canvas-active"];
    self.tabBarItem.image = [UIImage imageNamed:@"icon-canvas"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view startCanvasAnimation];
}


@end
