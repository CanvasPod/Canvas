//
//  ViewController.m
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-canvas-active"];
    self.tabBarItem.image = [UIImage imageNamed:@"icon-canvas"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
