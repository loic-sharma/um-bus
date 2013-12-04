//
//  Place.m
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Place.h"
#import "SPGooglePlacesAutocomplete.h"

@interface Place ()

@end

@implementation Place

- (void)fetchPlacemark {
    if (_googlePlace) {
        [_googlePlace resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
            [self receivedPlacemark:placemark];
        }];
    }
}

- (void)receivedPlacemark:(CLPlacemark *)placemark {
    self.placemark = placemark;
}

@end
