//
//  CSTabBarViewController.h
//  Canvas
//
//  Created by Jamz Tang on 2/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTabBarViewController : UITabBarController

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
