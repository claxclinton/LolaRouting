//
//  LocationManager.m
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

typedef enum {
    kRequestedStateActivated = 1,
    kRequestedStateDeactivated = 2,
} kRequestedState;

typedef enum {
    kPermissionStateAllowed = 1,
    kPermissionStateProhibited = 2,
} kPermissionState;

@interface LocationManager () <CLLocationManagerDelegate>

@property (assign, nonatomic) kRequestedState requestedState;
@property (assign, nonatomic) kPermissionState permissionState;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationManager

- (id)init
{
    self = [super init];
    if (self) {
        _requestedState = kRequestedStateDeactivated;
        _permissionState = kPermissionStateAllowed;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (void)activate
{
    self.requestedState = kRequestedStateActivated;
    if (self.permissionState == kPermissionStateAllowed) {
        [self startUpdatingLocation];
        [self.delegate locationManager:self changedToState:kLocationManagerStateRequestPermission];
    } else {
        [self.delegate locationManager:self changedToState:kLocationManagerStateProhibited];
    }
}

- (void)deactivate
{
    self.requestedState = kRequestedStateDeactivated;
    [self stopUpdatingLocation];
    [self.delegate locationManager:self changedToState:kLocationManagerStateDeactivated];
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    NSLog(@">>> UPDATING");
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
    NSLog(@"<<< NOT UPDATING");
}

#pragma mark - Core location delegate

/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s: Locations:%@",__PRETTY_FUNCTION__, locations);
}

#pragma mark Error and permissions

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s: Error %@",__PRETTY_FUNCTION__, error);
}

/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            self.permissionState = kPermissionStateProhibited;
            if (self.requestedState == kRequestedStateActivated) {
                [self.delegate locationManager:self changedToState:kLocationManagerStateProhibited];
            }
            break;
        case kCLAuthorizationStatusAuthorized:
            self.permissionState = kPermissionStateAllowed;
            if (self.requestedState == kRequestedStateActivated) {
                [self startUpdatingLocation];
                [self.delegate locationManager:self changedToState:kLocationManagerStateActivated];
            }
            break;
    }
}

#pragma mark Region

/*
 *  locationManager:didStartMonitoringForRegion:
 *
 *  Discussion:
 *    Invoked when a monitoring for a region started successfully.
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark Pause, resume and deferred updates

/*
 *  Discussion:
 *    Invoked when location updates are automatically paused.
 */
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
};

/*
 *  Discussion:
 *    Invoked when location updates are automatically resumed.
 *
 *    In the event that your application is terminated while suspended, you will
 *	  not receive this notification.
 */
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/*
 *  locationManager:didFinishDeferredUpdatesWithError:
 *
 *  Discussion:
 *    Invoked when deferred updates will no longer be delivered. Stopping
 *    location, disallowing deferred updates, and meeting a specified criterion
 *    are all possible reasons for finishing deferred updates.
 *
 *    An error will be returned if deferred updates end before the specified
 *    criteria are met (see CLError).
 */
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"%s: Error %@",__PRETTY_FUNCTION__, error);
}


@end
