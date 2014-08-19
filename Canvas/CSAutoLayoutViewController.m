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

@property (weak, nonatomic) IBOutlet UIView *splashView;

@end

@implementation CSAutoLayoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"AutoLayout";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    CSAnimationView *animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
//    self.view.translatesAutoresizingMaskIntoConstraints = YES;
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
