//
//  StreetViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StreetViewController : UIViewController

- (instancetype)initWithAnnotation:(NSObject<MKAnnotation> *)annotation;

@end
