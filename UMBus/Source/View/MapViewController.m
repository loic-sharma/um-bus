//
//  MapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "MapViewControllerModel.h"
#import "Bus.h"
#import "BusAnnotation.h"
#import "Stop.h"
#import "StopAnnotation.h"
#import "StreetViewController.h"
#import "StopTray.h"
#import "StopTrayModel.h"

#import "DataStore.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) StopTray *stopTray;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"University of Michigan";
    
    [self zoomToCampus];
    
    self.model = [[MapViewControllerModel alloc] init];
    self.model.continuouslyUpdate = YES;
    [self.model fetchStops];
    
    _stopTray = [[StopTray alloc] init];
    _stopTray.frame = CGRectMake(0, self.view.frame.size.height + 44, _stopTray.frame.size.width, _stopTray.frame.size.height);
    _stopTray.target = self;
    [self.view insertSubview:_stopTray aboveSubview:self.mapView];
    
    [RACObserve(self, model.busAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (Bus *bus in self.model.buses) {
                BusAnnotation *annotation = [annotations objectForKey:bus.id];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
    
    [RACObserve(self, model.stopAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (Stop *stop in self.model.stops) {
                StopAnnotation *annotation = [annotations objectForKey:stop.id];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
    
    [[DataStore sharedManager] fetchBuses];
    [RACObserve([DataStore sharedManager], buses) subscribeNext:^(NSArray *buses) {
        if (buses) {
            NSLog(@"Buses: %@", buses);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.model fetchBuses];
}

- (void)zoomToCampus {
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(42.282707, -83.740196);
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    
    [_mapView setRegion:region animated:YES];
}

- (void)displayTray {
    [UIView animateWithDuration:0.5
                     animations:^ {
                         _stopTray.frame = CGRectMake(0,
                                                      self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - _stopTray.frame.size.height,
                                                      _stopTray.frame.size.width,
                                                      _stopTray.frame.size.height);
                     }];
}

- (void)dismissTray {
    [UIView animateWithDuration:0.5
                     animations:^ {
                         _stopTray.frame = CGRectMake(0,
                                                      self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height + _stopTray.frame.size.height,
                                                      _stopTray.frame.size.width,
                                                      _stopTray.frame.size.height);
                     } completion:NULL];
}

- (void)displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)annotation {
    StreetViewController *streetViewController = [[StreetViewController alloc] initWithAnnotation:annotation];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:streetViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)displayDirections {
    // open Maps.app
}

- (void)detailInformationForStopAnnotation:(StopAnnotation *)annotation {
    [self displayTray];
}

- (void)detailInformationForBusAnnotation:(BusAnnotation *)annotation {
    // no detailing info for bus for now
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // don't change the view for the pin that represents user's current location
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;

    BusAnnotation *busAnnotation = (BusAnnotation *)annotation;

    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:busAnnotation reuseIdentifier:[NSString stringWithFormat:@"%@", busAnnotation.id]];
    pinView.canShowCallout = YES;
    
    if ([annotation class] == [BusAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorRed;
    } else if ([annotation class] == [StopAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorGreen;
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self dismissTray];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSObject<MKAnnotation> *annotation = view.annotation;
    if ([annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
        [self detailInformationForBusAnnotation:busAnnotation];
    } else if ([annotation class] == [StopAnnotation class]){
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        _stopTray.model.stopAnnotation = stopAnnotation;
        [self detailInformationForStopAnnotation:stopAnnotation];
    }
}

@end
