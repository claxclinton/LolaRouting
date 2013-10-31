//
//  LocationManager.h
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@protocol LocationManagerDelegate;

@interface LocationManager : NSObject

@property (weak, nonatomic) id <LocationManagerDelegate> delegate;
@property (readonly, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *destinationLocation;

- (id)init;
- (void)activate;
- (void)deactivate;

@end

@protocol LocationManagerDelegate

- (void)locationManager:(LocationManager *)locationManager currentLocationAvailable:(BOOL)locationAvailable
       updatingLocation:(BOOL)updatingLocation;
- (void)locationManager:(LocationManager *)locationManager movedToLocation:(CLLocation *)location;

@end
