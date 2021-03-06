//
//  ArrivalsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalsViewController.h"
#import "ArrivalsViewControllerModel.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "ArrivalCell.h"
#import "ArrivalCellModel.h"
#import "HexColor.h"
#import "DataStore.h"
#import "RouteMapViewController.h"

@interface ArrivalsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *stops, *informationCells;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ArrivalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.arrival.name;
    
    self.model = [[ArrivalsViewControllerModel alloc] initWithArrival:self.arrival];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.informationCells = @[@"Map"];
    
    [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
        if (arrivals) {
            [self.refreshControl endRefreshing];
            Arrival *a = [[DataStore sharedManager] arrivalForID:self.model.arrival.id];
            self.stops = [self.model stopsOrderedByTimeOfArrivalWithStops:a.stops];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
}

- (void)refresh {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:NULL];
}

#pragma UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.informationCells.count;
            break;
        case 1:
            return self.stops.count;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Route information";
        case 1:
            return @"Stops";
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 100;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = self.informationCells[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        ArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        
        ArrivalStop *stop = self.stops[indexPath.row];
        ArrivalCellModel *arrivalCellModel = [[ArrivalCellModel alloc] initWithStop:stop forArrival:self.model.arrival];
        cell.model = arrivalCellModel;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:UMSegueRouteMap sender:self];
    }
    
    if (indexPath.section == 1) {
        
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:UMSegueRouteMap]) {
        RouteMapViewController *routeMap = (RouteMapViewController *)segue.destinationViewController;
        routeMap.arrival = self.model.arrival;
    }
}

@end
