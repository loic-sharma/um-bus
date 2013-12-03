//
//  DataStore.m
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "DataStore.h"
#import "UMNetworkingSession.h"

@interface DataStore ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;
@property (strong, nonatomic, readwrite) NSArray *buses, *routes, *stops, *announcements;

@end

@implementation DataStore

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static DataStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)fetchBuses {
    [_networkingSession fetchBusLocationsWithSuccessBlock:^(NSArray *buses) {
        self.buses = buses;
    } errorBlock:NULL];
}

- (void)fetchRoutes {
    [_networkingSession fetchRoutesWithSuccessBlock:^(NSArray *routes) {
        self.routes = routes;
    } errorBlock:NULL];
}

- (void)fetchStops {
    [_networkingSession fetchStopsWithSuccessBlock:^(NSArray *stops) {
        self.stops = stops;
    } errorBlock:NULL];
}

- (void)fetchAnnouncements {
    [_networkingSession fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        self.announcements = announcements;
    } errorBlock:NULL];
}

@end
