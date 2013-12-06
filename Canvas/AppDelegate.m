//
//  AppDelegate.m
//  Canvas
//
//  Created by Meng To on 1/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "AppDelegate.h"
#import "CanvasIncrementalStore.h"
#import "CSTabBarViewController.h"

@import CoreData;

@interface AppDelegate ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    CSTabBarViewController *controller = (id)self.window.rootViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark CoreData

- (NSManagedObjectContext *)managedObjectContext {

    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Canvas" withExtension:@"momd"];
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    [NSPersistentStoreCoordinator registerStoreClass:[CanvasIncrementalStore class] forStoreType:[CanvasIncrementalStore type]];

    NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSError* err = nil;
    [coordinator addPersistentStoreWithType:[CanvasIncrementalStore type]
                              configuration:nil
                                        URL:nil
                                    options:nil
                                      error:&err];

    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

@end
