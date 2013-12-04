//
//  Route.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Route.h"
#import "Stop.h"
#import "DataStore.h"

@implementation Route

- (void)fetchStops {
    NSMutableArray *mutableStopObjects;
    if ([[DataStore sharedManager] stops]) {
        for (Stop *stop in [[DataStore sharedManager] stops]) {
            if ([self.stops containsObject:stop.id]) {
                [mutableStopObjects addObject:stop];
            }
        }
        self.stopObjects = mutableStopObjects;
    }
}

- (BOOL)servicesStop:(Stop *)stop {
    if ([self.stops containsObject:stop.id]) {
        return YES;
    }
    
    return NO;
}

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"isActive" : @"is_active",
             @"topOfLoopStopID" : @"top_of_loop_stop_id"};
}

@end
