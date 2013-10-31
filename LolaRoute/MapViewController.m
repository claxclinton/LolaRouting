//
//  MapViewController.m
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "LocationManager.h"

@interface MapViewController () <MKMapViewDelegate, LocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) LocationManager *locationManager;

@end

@implementation MapViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _locationManager = [[LocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager activate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location manager delegate

- (void)locationManager:(LocationManager *)locationManager changedToState:(kLocationManagerState)state
{
    switch (state) {
        case kLocationManagerStateRequestPermission:
            NSLog(@"BBB RequestPermissions");
            break;
        case kLocationManagerStateActivated:
            NSLog(@"BBB Activated");
            break;
        case kLocationManagerStateProhibited:
            NSLog(@"BBB Prohibited");
            break;
        case kLocationManagerStateDeactivated:
            NSLog(@"BBB Deactivated");
            break;
        default:
            break;
    }
}
- (void)locationManager:(LocationManager *)locationManager movedToLocation:(CLLocation *)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
    CLLocationCoordinate2D centeringCoord = location.coordinate;
    self.mapView.region = MKCoordinateRegionMake(centeringCoord, span);
}

@end
