//
//  ViewController.m
//  LolaRoute
//
//  Created by Claes Lillieskold on 2013-10-31.
//  Copyright (c) 2013 Claes Lillieskold. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController () <MapViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) IBOutlet UIView *mapViewContainer;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *routingSteps;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapViewController = [[MapViewController alloc] init];
    self.mapViewController.delegate = self;
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

#pragma mark - Map view controller delegate

- (void)mapViewController:(MapViewController *)mapViewController didSetRoutingSteps:(NSArray *)routingSteps
{
    self.routingSteps = routingSteps;
    [self.tableView reloadData];
}

#pragma mark - Routing steps table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.routingSteps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MKRouteStep *routeStep = self.routingSteps[indexPath.row];
    cell.textLabel.text = routeStep.instructions;
    return cell;
}

@end
