//
//  SearchViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/3/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "SearchViewController.h"
#import "DirectionsManager.h"
#import "SPGooglePlacesAutocomplete.h"
#import "Place.h"
#import "Route.h"
#import "Stop.h"
#import "DataStore.h"

@interface SearchViewController ()

@property (strong, nonatomic) DirectionsManager *directionsManager;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _directionsManager = [[DirectionsManager alloc] init];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.placeholder = @"Where do you want to go?";
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [RACObserve(_directionsManager, directions) subscribeNext:^(Directions *directions) {
        if (directions.route) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"University of Michigan"
                                                            message:[NSString stringWithFormat:@"Get on the %@ route at %@, then get off at %@", directions.route.name, directions.origin.humanName, directions.destination.humanName]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.directionsManager.queriedLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Place *place = self.directionsManager.queriedLocations[indexPath.row];
    cell.textLabel.text = place.googlePlace.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Place *place = self.directionsManager.queriedLocations[indexPath.row];
    if (!place.placemark) {
        [place fetchPlacemark];
        
        [RACObserve(place, placemark) subscribeNext:^(CLPlacemark *placemark) {
            if (placemark) {
                [_directionsManager fetchRouteServicingOrigin:placemark.location
                                                  destination:[MKMapItem mapItemForCurrentLocation].placemark.location];
            }
        }];
    } else {
        [_directionsManager fetchRouteServicingOrigin:place.placemark.location
                                          destination:[MKMapItem mapItemForCurrentLocation].placemark.location];
    }
}

#pragma mark - UISearchDisplayController delegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [_directionsManager fetchLocationsForQuery:searchString];
    
    [RACObserve(_directionsManager, queriedLocations) subscribeNext:^(NSArray *placemarks) {
        if (placemarks) {
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    
    return YES;
}

@end
