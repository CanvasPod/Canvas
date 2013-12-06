//
//  CanvasInfo.h
//  Canvas
//
//  Created by Jamz Tang on 6/12/13.
//  Copyright (c) 2013 Canvas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CanvasInfo : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * value;

@end
