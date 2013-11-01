//
//  MapViewController.h
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MapViewControllerDelegate;

typedef enum {
    kMapViewControllerOpenMapsDestinationOnly = 1,
    kMapViewControllerOpenMapsRouting = 2,
    kMapViewControllerOpenMapsNoDestination = 3
} kMapViewControllerOpenMaps;

@interface MapViewController : UIViewController

@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;

- (id)init;
- (void)startRoutingToDestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate;
- (void)openMapsWithStatus:(kMapViewControllerOpenMaps *)status;
- (void)stopRouting;

@end

@protocol MapViewControllerDelegate
- (void)mapViewController:(MapViewController *)mapViewController didSetRoutingSteps:(NSArray *)routingSteps;
@end

