//
//  Stop.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Stop.h"
#import "Route.h"
#import "Bus.h"

@implementation Stop

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uniqueName" : @"unique_name",
             @"humanName" : @"human_name",
             @"additionalName" : @"additional_name"};
}


@end
