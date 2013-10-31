//
//  ViewController.m
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()

@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) IBOutlet UIView *mapViewContainer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapViewController = [[MapViewController alloc] init];
    [self.mapViewContainer addSubview:_mapViewController.view];
    self.mapViewController.view.frame = _mapViewContainer.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User interaction

- (IBAction)didPressResetButton:(UIButton *)sender
{
}

- (IBAction)didPressRoute:(UIButton *)sender
{
    CLLocationCoordinate2D bontouchCoordinate = CLLocationCoordinate2DMake(59.314951, 18.071176);
    [self.mapViewController startRoutingToDestinationCoordinate:bontouchCoordinate];
}

- (IBAction)didPressMaps:(UIButton *)sender
{
}

@end
