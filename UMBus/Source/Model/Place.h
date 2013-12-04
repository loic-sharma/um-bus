//
//  Place.h
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompletePlace;

@interface Place : NSObject

@property (strong, nonatomic) SPGooglePlacesAutocompletePlace *googlePlace;
@property (strong, nonatomic) CLPlacemark *placemark;

- (void)fetchPlacemark;

@end
