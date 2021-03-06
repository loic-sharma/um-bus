//
//  ArrivalCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCellModel.h"
#import "ArrivalStop.h"
#import "Arrival.h"

@implementation ArrivalCellModel

- (instancetype)initWithStop:(ArrivalStop *)stop forArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.stop = stop;
        self.arrival = arrival;
    }
    return self;
}

- (NSString *)abbreviatedArrivalTimeForTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == -1) {
        return @"--";
    }
    
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"Arr";
    }
    
    return [NSString stringWithFormat:@"%02im", minutes];
}

@end
