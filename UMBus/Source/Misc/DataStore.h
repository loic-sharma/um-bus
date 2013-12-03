//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

@property (strong, nonatomic, readonly) NSArray *buses, *routes, *stops, *announcements;

+ (instancetype)sharedManager;

- (void)fetchBuses;
- (void)fetchRoutes;
- (void)fetchStops;
- (void)fetchAnnouncements;

@end
