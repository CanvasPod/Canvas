//
//  CanvasIncrementalStore.m
//  Canvas
//
//  Created by Jamz Tang on 6/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import "CanvasIncrementalStore.h"
#import "CanvasInfo.h"

@interface CanvasIncrementalStore ()

@property (nonatomic, strong) NSURL *twitterInfoURL;
@property (nonatomic, strong) NSURL *githubInfoURL;

@end


@implementation CanvasIncrementalStore

+ (void)initialize {
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type {
    return NSStringFromClass(self);
}

- (BOOL)loadMetadata:(NSError *__autoreleasing *)error {

    NSDictionary *metadata = @{
                               NSStoreUUIDKey:[[NSProcessInfo processInfo] globallyUniqueString],
                               NSStoreTypeKey:[[self class] type]};

    self.githubInfoURL  = [NSURL URLWithString:@"https://api.github.com/repos/CanvasPod/Canvas"];
    self.twitterInfoURL = [NSURL URLWithString:@"http://cdn.api.twitter.com/1/urls/count.json?callback=?&url=canvaspod.io"];

    [self setMetadata:metadata];
    return YES;
}


- (id)executeRequest:(NSPersistentStoreRequest*)request
         withContext:(NSManagedObjectContext*)context
               error:(NSError**)error {

    if(request.requestType == NSFetchRequestType)
    {

        [self refreshStarsWithContext:context];
        [self refreshTweetsWithContext:context];

        return @[];

    } else if (request.requestType == NSSaveRequestType) {
        NSSaveChangesRequest *saveRequest = (NSSaveChangesRequest *)request;
        NSLog(@"save %@",saveRequest);
        return @[];
    }

    NSLog(@"unimplemented request: %@", request);
    return nil;
}

#pragma mark Helper

- (CanvasInfo *)infoWithType:(NSString *)type context:(NSManagedObjectContext *)context {

    CanvasInfo *info = nil;

    if ( ! info) {
        info = [NSEntityDescription insertNewObjectForEntityForName:@"CanvasInfo"
                                      inManagedObjectContext:context];
        info.type = type;
    }

    return info;
}

- (void)refreshTweetsWithContext:(NSManagedObjectContext *)context {
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
                                            CanvasInfo *info = [self infoWithType:@"Twitter" context:context];
                                            info.value = [NSString stringWithFormat:@"%@", count];

                                            [context save:NULL];
                                        }];
    [task resume];
}

- (void)refreshStarsWithContext:(NSManagedObjectContext *)context {
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

                                            CanvasInfo *info = [self infoWithType:@"Github" context:context];
                                            info.value = [NSString stringWithFormat:@"%@", count];
                                            [context save:NULL];
                                        }];
    [task resume];
}

@end
