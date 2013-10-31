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
@property (assign, nonatomic) CLLocationCoordinate2D destination;
@property (assign, nonatomic) BOOL locationAvailable;
@property (strong, nonatomic) MKPointAnnotation *destinationAnnotation;

@end

@implementation MapViewController

@synthesize locationAvailable = _locationAvailable;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _locationAvailable = NO;
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
            self.locationAvailable = YES;
            break;
        case kLocationManagerStateProhibited:
            NSLog(@"BBB Prohibited");
            self.locationAvailable = NO;
            break;
        case kLocationManagerStateDeactivated:
            NSLog(@"BBB Deactivated");
            self.locationAvailable = NO;
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

#pragma mark - Availibility of user location

- (BOOL)locationAvailable
{
    return _locationAvailable;
}

- (void)setLocationAvailable:(BOOL)locationAvailable
{
    if (_locationAvailable != locationAvailable) {
        _locationAvailable = locationAvailable;
        self.mapView.showsUserLocation = locationAvailable;
    }
}

#pragma mark - Route

- (void)addDestinationAnnotation
{
    self.destinationAnnotation = [[MKPointAnnotation alloc] init];
    self.destinationAnnotation.coordinate = self.destination;
    [self.mapView addAnnotation:self.destinationAnnotation];
}

- (void)removeDestinationAnnotation
{
    if (self.destinationAnnotation) {
        [self.mapView removeAnnotation:self.destinationAnnotation];
        self.destinationAnnotation = nil;
    }
}

- (void)startRoutingToDestination:(CLLocationCoordinate2D)destination
{
    self.destination = destination;
    [self addDestinationAnnotation];
}

- (void)stopRouting
{
    [self removeDestinationAnnotation];
}

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
#if 0
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor purpleColor];
    renderer.lineWidth = 5.0;
    [self.view setNeedsDisplay];
    return renderer;
#endif
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers
{
}

@end
