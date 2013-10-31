//
//  MapViewController.h
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController

@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;

- (id)init;

@end
