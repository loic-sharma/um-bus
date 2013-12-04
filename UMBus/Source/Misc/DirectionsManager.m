//
//  DirectionsManager.m
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DirectionsManager.h"
#import "SPGooglePlacesAutocomplete.h"
#import "Place.h"
#import "Stop.h"
#import "Route.h"
#import "DataStore.h"

@implementation Directions

@end

@interface DirectionsManager ()

@property (strong, nonatomic) SPGooglePlacesAutocompleteQuery *googlePlacesQuery;
@property (strong, nonatomic, readwrite) NSArray *queriedLocations;
@property (strong, nonatomic, readwrite) Directions *directions;

@end

@implementation DirectionsManager

- (instancetype)init {
    if (self = [super init]) {
        _googlePlacesQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyCCBKyJMm7zWhVxukAy8k-_ejMlc5t8ugo"];
        _googlePlacesQuery.location = CLLocationCoordinate2DMake([@"42.276591" doubleValue], [@"-83.742640" doubleValue]); // Ann Arbor
        _googlePlacesQuery.radius = 80467.2; // it will look for places within 50 miles of campus
        _googlePlacesQuery.language = @"en";
        
        _directions = [[Directions alloc] init];
    }
    return self;
}

- (void)fetchLocationsForQuery:(NSString *)string {
    _googlePlacesQuery.input = string;
    
    [_googlePlacesQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (!error) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (SPGooglePlacesAutocompletePlace *place in places) {
                Place *placeObject = [[Place alloc] init];
                placeObject.googlePlace = place;
                [mutableArray addObject:placeObject];
            }
            self.queriedLocations = mutableArray;
        }
        NSLog(@"%@", error);
    }];
}

- (void)fetchRouteServicingOrigin:(CLLocation *)origin destination:(CLLocation *)destination {
    NSArray *originStops = [self stopsClosestToLocation:origin];
    NSArray *destinationStops = [self stopsClosestToLocation:destination];
    
    for (Stop *originStop in originStops) {
        NSArray *routesServicingOriginStop = [[DataStore sharedManager] routesServicingStop:originStop];
        if (routesServicingOriginStop.count > 0) {
            for (Route *originRoute in routesServicingOriginStop) {
                for (Stop *destinationStop in destinationStops) {
                    NSArray *routesServicingDestinationStop = [[DataStore sharedManager] routesServicingStop:destinationStop];
                    for (Route *destinationRoute in routesServicingDestinationStop) {
                        if (originRoute.id == destinationRoute.id) {
                            Directions *directions = [[Directions alloc] init];
                            directions.route = originRoute;
                            directions.origin = originStop;
                            directions.destination = destinationStop;
                            self.directions = directions;
                            goto endLoop;
                        }
                    }
                }
            }
        }
    }
    
    endLoop:
    NSLog(@"");
}

- (NSArray *)stopsClosestToLocation:(CLLocation *)location {
    if ([[DataStore sharedManager] stops]) {
        NSArray *sortedStops = [[[DataStore sharedManager] stops] sortedArrayUsingComparator: ^(id a, id b) {
            Stop *stop1 = (Stop *)a;
            Stop *stop2 = (Stop *)b;
            
            CLLocation *stop1Location = [[CLLocation alloc] initWithLatitude:[stop1.latitude doubleValue] longitude:[stop1.longitude doubleValue]];
            CLLocation *stop2Location = [[CLLocation alloc] initWithLatitude:[stop2.latitude doubleValue] longitude:[stop2.longitude doubleValue]];
            
            CLLocationDistance dist_a = [stop1Location distanceFromLocation:location];
            CLLocationDistance dist_b = [stop2Location distanceFromLocation:location];
            
            if ( dist_a < dist_b ) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (dist_a > dist_b) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];

        return sortedStops;
    }
    
    return nil;
}

@end
