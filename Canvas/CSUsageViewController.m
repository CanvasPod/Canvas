//
//  ViewController.m
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CSUsageViewController.h"
#import "CanvasInfo.h"
#import "Canvas.h"

@interface CSUsageViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSURL *githubURL;
@property (nonatomic, strong) NSURL *homepageURL;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

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

    [self reloadUI];
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

- (IBAction)tweetsButtonDidPress:(id)sender {
    NSArray *items = @[self.homepageURL, @"Canvas: Animate in Xcode without code"];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    
    [self presentViewController:controller
                       animated:YES
                     completion:^{
                         NSLog(@"compltete");
                     }];
}

- (IBAction)starsButtonDidPress:(id)sender {
    NSArray *items = @[self.githubURL, @"Opensource repository for Canvas"];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    
    [self presentViewController:controller
                       animated:YES
                     completion:^{
                         NSLog(@"compltete");
                     }];
}

- (void)reloadUI {

    NSArray *fetchedObjects = [self.fetchedResultsController fetchedObjects];

    [fetchedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CanvasInfo *info = obj;

        if ([info.type isEqualToString:@"Github"]) {
            NSString *countString = [NSString stringWithFormat:@"%@ Stars", info.value];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.starsButton setTitle:countString
                                  forState:UIControlStateNormal];
            });

        } else if ([info.type isEqualToString:@"Twitter"]) {

            NSString *countString = [NSString stringWithFormat:@"%@ Tweets", info.value];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tweetsButton setTitle:countString
                                   forState:UIControlStateNormal];
            });
        }
    }];

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSFetchedResultsController *aFetchedResultsController;

    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"CanvasInfo" inManagedObjectContext:self.managedObjectContext];

    [fetchRequest setEntity:entity];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortByType = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    NSArray *sortDescriptors = @[sortByType];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:@"Main"];

    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self reloadUI];
}

@end
