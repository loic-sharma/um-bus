//
//  DirectionsManager.h
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Stop, Route;

@interface Directions : NSObject

@property (strong, nonatomic) Stop *origin, *destination;
@property (strong, nonatomic) Route *route;

@end

@interface DirectionsManager : NSObject

@property (strong, nonatomic, readonly) NSArray *queriedLocations;
@property (strong, nonatomic, readonly) Directions *directions;

- (void)fetchLocationsForQuery:(NSString *)query;
- (void)fetchRouteServicingOrigin:(CLLocation *)origin destination:(CLLocation *)destination;
- (NSArray *)stopsClosestToLocation:(CLLocation *)location;

@end
