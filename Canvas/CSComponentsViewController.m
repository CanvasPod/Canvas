//
//  CSComponentsViewController.m
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSComponentsViewController.h"

@interface CSComponentsViewController ()

@end

@implementation CSComponentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-components-active"];
    self.tabBarItem.image = [UIImage imageNamed:@"icon-components"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
