//
//  StopTray.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "StopTray.h"
#import "StopTrayModel.h"
#import "MapViewController.h"
#import "TTTAttributedLabel.h"
#import "StopAnnotation.h"
#import "Stop.h"
#import "Bus.h"

@interface StopTray ()

@property (nonatomic, copy) NSString *timeUntilNextBus;
@property (strong, nonatomic) UIButton *streetViewButton, *directionsButton, *shareButton;
@property (strong, nonatomic) TTTAttributedLabel *titleLabel, *subtitleLabel;

@end

@implementation StopTray

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 100)]) {
        _model = [[StopTrayModel alloc] init];
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 10, 310, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 30, 310, 16)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_subtitleLabel];
        
        _streetViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_streetViewButton setTitle:@"Street View" forState:UIControlStateNormal];
        _streetViewButton.frame = CGRectMake(10, 60, 90, 30);
        [_streetViewButton addTarget:self action:@selector(displayStreetView) forControlEvents:UIControlEventTouchUpInside];
        _streetViewButton.layer.cornerRadius = 3;
        _streetViewButton.layer.borderWidth = 1;
        _streetViewButton.layer.borderColor = _streetViewButton.titleLabel.textColor.CGColor;
        [self addSubview:_streetViewButton];
        
        _directionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_directionsButton setTitle:@"Directions" forState:UIControlStateNormal];
        _directionsButton.frame = CGRectMake(115, 60, 90, 30);
        [_directionsButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        _directionsButton.layer.cornerRadius = 3;
        _directionsButton.layer.borderWidth = 1;
        _directionsButton.layer.borderColor = _directionsButton.titleLabel.textColor.CGColor;
        [self addSubview:_directionsButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_shareButton setTitle:@"Share" forState:UIControlStateNormal];
        _shareButton.frame = CGRectMake(220, 60, 90, 30);
        [_shareButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        _shareButton.layer.cornerRadius = 3;
        _shareButton.layer.borderWidth = 1;
        _shareButton.layer.borderColor = _shareButton.titleLabel.textColor.CGColor;
        [self addSubview:_shareButton];

    }
    return self;
}

- (void)reset {
    [_titleLabel setText:nil];
    [_subtitleLabel setText:nil];
}

- (void)displayStreetView {
    [(MapViewController *)_target displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)_model.stopAnnotation];
}

@end
