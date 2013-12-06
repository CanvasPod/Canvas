//
//  ViewController.h
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface CSUsageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *tweetsButton;
@property (weak, nonatomic) IBOutlet UIButton *starsButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)githubButtonDidPress:(id)sender;
- (IBAction)homepageButtonDidPress:(id)sender;
- (IBAction)tweetsButtonDidPress:(id)sender;
- (IBAction)starsButtonDidPress:(id)sender;

@end
