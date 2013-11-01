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
@property (assign, nonatomic) CLLocationCoordinate2D destinationCoordinate;
@property (assign, nonatomic) BOOL locationAvailable;
@property (strong, nonatomic) MKPointAnnotation *destinationAnnotation;
@property (strong, nonatomic) MKDirectionsRequest *request;
@property (strong, nonatomic) MKDirectionsResponse *directionsResponse;
@property (assign, nonatomic) BOOL shouldStartRouting;
@property (strong, nonatomic) MKPolyline *routePolyLine;

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
        _destinationCoordinate = kCLLocationCoordinate2DInvalid;
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
        [self updateVisibleRegion];
    }
    
    if (locationAvailable) {
        if (self.shouldStartRouting) {
            [self startRouting];
        }
    } else {
        [self removeRoutePolyLine];
    }
}

#pragma mark - Route

#pragma mark Destination annotation

- (void)addDestinationAnnotation
{
    if (!self.destinationAnnotation) {
        self.destinationAnnotation = [[MKPointAnnotation alloc] init];
        self.destinationAnnotation.coordinate = self.destinationCoordinate;
        [self.mapView addAnnotation:self.destinationAnnotation];
    }
}

- (void)removeDestinationAnnotation
{
    if (self.destinationAnnotation) {
        [self.mapView removeAnnotation:self.destinationAnnotation];
        self.destinationAnnotation = nil;
    }
}

#pragma mark Route polyline overlay

- (void)addRoutePolyline
{
    [self.mapView addOverlay:self.routePolyLine level:MKOverlayLevelAboveRoads];
}

- (void)removeRoutePolyLine
{
    [self.mapView removeOverlay:self.routePolyLine];
}

#pragma mark Map items

- (MKMapItem *)userLocationMapItem
{
    CLLocationCoordinate2D userLocationCoordinate = self.mapView.userLocation.coordinate;
    MKPlacemark *userLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocationCoordinate addressDictionary:nil];
    MKMapItem *userLocationMapItem = [[MKMapItem alloc] initWithPlacemark:userLocationPlacemark];
    userLocationMapItem.name = @"Me";
    NSAssert(userLocationMapItem != nil, @"The caller is responsible of just requesting this if available.");
    return userLocationMapItem;
}

- (MKMapItem *)destinationMapItem
{
    CLLocationCoordinate2D destinationCoordinate = self.destinationCoordinate;
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc]
                                         initWithCoordinate:destinationCoordinate addressDictionary:nil];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    destinationMapItem.name = @"Lolas Tobak";
    NSAssert(destinationMapItem != nil, @"The caller is responsible of just requesting this if available.");
    return destinationMapItem;
}

#pragma mark Update visible region

- (void)updateVisibleRegion
{
    BOOL locationAvailable = self.locationAvailable;
    BOOL destinationAnnotationAvailable = (self.destinationAnnotation != nil);
    BOOL userAnnotationAvailable = (self.mapView.userLocation != nil);
    if (locationAvailable && destinationAnnotationAvailable && userAnnotationAvailable) {
        id <MKAnnotation> annotation1 = self.destinationAnnotation;
        id <MKAnnotation> annotation2 = self.mapView.userLocation;
        [self.mapView showAnnotations:@[annotation1, annotation2] animated:YES];
    } else {
        if (self.destinationAnnotation) {
            id <MKAnnotation> annotation = self.destinationAnnotation;
            [self.mapView showAnnotations:@[annotation] animated:YES];
        }
    }
}

- (void)startRouting
{
    if (self.locationAvailable) {
        MKMapItem *startMapItem = [self userLocationMapItem];
        MKMapItem *endMapItem = [self destinationMapItem];
        [self findDirectionsFrom:startMapItem to:endMapItem];
    }
}

- (void)startRoutingToDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate
{
    self.destinationCoordinate = destinationCoordinate;
    [self addDestinationAnnotation];
    [self updateVisibleRegion];
    self.shouldStartRouting = YES;
    [self startRouting];
}

- (void)openMapsWithStatus:(kMapViewControllerOpenMaps *)status
{
    CLLocationCoordinate2D destinationCoordinate = self.destinationCoordinate;
    if ((destinationCoordinate.latitude == kCLLocationCoordinate2DInvalid.latitude) &&
        (destinationCoordinate.longitude == kCLLocationCoordinate2DInvalid.longitude)) {
        if (status) {
            *status = kMapViewControllerOpenMapsNoDestination;
        }
    } else {
        if (self.locationAvailable) {
            MKMapItem *startMapItem = [self userLocationMapItem];
            MKMapItem *endMapItem = [self destinationMapItem];
            BOOL transportartionByWalking = YES;
            NSString *transportationMode = (transportartionByWalking) ?
            MKLaunchOptionsDirectionsModeWalking : MKLaunchOptionsDirectionsModeDriving;
            NSDictionary *launchOptionsBasic = @{MKLaunchOptionsDirectionsModeKey: transportationMode};
            NSMutableDictionary *launchOptions = [NSMutableDictionary dictionaryWithDictionary:launchOptionsBasic];
            if (!transportartionByWalking) {
                [launchOptions setObject:@YES forKey:MKLaunchOptionsShowsTrafficKey];
            }
            [MKMapItem openMapsWithItems:@[startMapItem, endMapItem] launchOptions:launchOptions];
            if (status) {
                *status = kMapViewControllerOpenMapsRouting;
            }
        } else {
            MKMapItem *endMapItem = [self destinationMapItem];
            NSValue *centerCoordinate = [[NSValue alloc] initWithBytes:&destinationCoordinate objCType:@encode(CLLocationCoordinate2D)];
            NSDictionary *launchOptions = @{MKLaunchOptionsMapCenterKey: centerCoordinate};
            [MKMapItem openMapsWithItems:@[endMapItem] launchOptions:launchOptions];
            if (status) {
                *status = kMapViewControllerOpenMapsDestinationOnly;
            }
        }
    }
}

- (void)stopRouting
{
    self.destinationCoordinate = kCLLocationCoordinate2DInvalid;
    self.shouldStartRouting = NO;
    [self removeDestinationAnnotation];
    [self removeRoutePolyLine];
}

#pragma mark - Map directions

- (void)findDirectionsFrom:(MKMapItem *)source to:(MKMapItem *)destination
{
    self.request = [[MKDirectionsRequest alloc] init];
    [self.request setSource:source];
    [self.request setDestination:destination];
    self.request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:self.request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
//            NSAssert(NO, @"");
        } else {
            [self showDirectionsWithDirectionsResponsee:response];
        }
    }];
}

- (void)showDirectionsWithDirectionsResponsee:(MKDirectionsResponse *)directionsResponse
{
    self.directionsResponse = directionsResponse;
    MKRoute *route = self.directionsResponse.routes[0];
    [self.delegate mapViewController:self didSetRoutingSteps:route.steps];
    for (MKRouteStep *step in route.steps) {
        NSLog(@"step: %@", step.instructions);
    }
    self.routePolyLine = route.polyline;
    [self addRoutePolyline];
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
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor purpleColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers
{
}

@end
