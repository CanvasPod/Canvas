//
//  CSAutoLayoutViewController.m
//  Canvas
//
//  Created by James Tang on 19/8/14.
//  Copyright (c) 2014 Canvas. All rights reserved.
//

#import "CSAutoLayoutViewController.h"
#import "Canvas.h"

@interface CSAutoLayoutViewController ()

@property (strong, nonatomic) IBOutlet UIView *splashView;

@end

@implementation CSAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tabBarItem.title = @"AutoLayout";

    UIView *splashView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    [self.view addSubview:splashView];
    splashView.backgroundColor = [UIColor yellowColor];
    self.splashView = splashView;

    CSAnimationView *animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    // animationView.view in my case goes fine
    NSLog(@"animationView.translatesAutoresizingMaskIntoConstraints %d", animationView.translatesAutoresizingMaskIntoConstraints);
    animationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin;

//    animationView.translatesAutoresizingMaskIntoConstraints = YES;

    animationView.duration = 0.5;
    animationView.delay = 0.2;
    animationView.type = CSAnimationTypePop;
    animationView.backgroundColor = [UIColor redColor];
    [self.splashView addSubview:animationView];
    [animationView startCanvasAnimation];

}

- (void)viewDidAppear:(BOOL)animated {
    [self.view startCanvasAnimation];
}

@end
