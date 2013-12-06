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

@property (nonatomic, strong) NSURL *githubURL;
@property (nonatomic, strong) NSURL *homepageURL;

@end

@implementation CSUsageViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.githubURL = [NSURL URLWithString:@"http://github.com/CanvasPod/Canvas"];
        self.homepageURL = [NSURL URLWithString:@"http://canvaspod.io"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNeedsStatusBarAppearanceUpdate];
    
    self.scrollView.contentSize = CGSizeMake(320, 568);
    
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

- (IBAction)githubButtonDidPress:(id)sender {
    [[UIApplication sharedApplication] openURL:self.githubURL];
}

- (IBAction)homepageButtonDidPress:(id)sender {
    [[UIApplication sharedApplication] openURL:self.homepageURL];
}

@end
