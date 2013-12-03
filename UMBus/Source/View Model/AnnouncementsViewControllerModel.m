//
//  AnnouncementsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementsViewControllerModel.h"
#import "DataStore.h"

@implementation AnnouncementsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        RAC(self, announcements) = RACObserve([DataStore sharedManager], announcements);
    }
    return self;
}

- (void)fetchAnnouncements {
    [[DataStore sharedManager] fetchAnnouncements];
}

@end
