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
@property (nonatomic, strong) NSURL *twitterInfoURL;
@property (nonatomic, strong) NSURL *githubInfoURL;

@end

@implementation CSUsageViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.githubURL = [NSURL URLWithString:@"http://github.com/CanvasPod/Canvas"];
        self.homepageURL = [NSURL URLWithString:@"http://canvaspod.io"];
        self.githubInfoURL = [NSURL URLWithString:@"https://api.github.com/repos/CanvasPod/Canvas"];
        self.twitterInfoURL = [NSURL URLWithString:@"http://cdn.api.twitter.com/1/urls/count.json?callback=?&url=canvaspod.io"];
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
    
    [self refreshStars];
    [self refreshTweets];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view startCanvasAnimation];
}

#pragma mark Action

- (IBAction)githubButtonDidPress:(id)sender {
    [[UIApplication sharedApplication] openURL:self.githubURL];
}

- (IBAction)homepageButtonDidPress:(id)sender {
    [[UIApplication sharedApplication] openURL:self.homepageURL];
}

#pragma mark Helper

- (void)refreshTweets {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.twitterInfoURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                                            if (error) {
                                                NSLog(@"Error loading tweets info %@", self.twitterInfoURL);
                                                return;
                                            }

                                            NSError *serializeError;
                                            id json = [NSJSONSerialization JSONObjectWithData:data
                                                                                      options:0
                                                                                        error:&serializeError];

                                            NSNumber *count = json[@"count"];
                                            NSString *countString = [NSString stringWithFormat:@"%@ Tweets", count];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.tweetsButton setTitle:countString
                                                                   forState:UIControlStateNormal];
                                            });
                                        }];
    [task resume];
}

- (void)refreshStars {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.githubInfoURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                                            if (error) {
                                                NSLog(@"Error loading github info %@", self.githubInfoURL);
                                                return;
                                            }

                                            NSError *serializeError;
                                            id json = [NSJSONSerialization JSONObjectWithData:data
                                                                                      options:0
                                                                                        error:&serializeError];

                                            NSNumber *count = json[@"stargazers_count"];
                                            NSString *countString = [NSString stringWithFormat:@"%@ Stars", count];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.starsButton setTitle:countString
                                                                  forState:UIControlStateNormal];
                                            });
                                        }];
    [task resume];
}

@end
