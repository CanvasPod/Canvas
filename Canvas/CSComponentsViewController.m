//
//  CSComponentsViewController.m
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSComponentsViewController.h"
#import "Canvas.h"

@interface CSComponentsViewController ()

@end

@implementation CSComponentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-components-active"];
    self.tabBarItem.image = [UIImage imageNamed:@"icon-components"];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 480);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view startCanvasAnimation];
}

@end
