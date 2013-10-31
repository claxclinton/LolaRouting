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
    _mapViewController = [[MapViewController alloc] init];
    [_mapViewContainer addSubview:_mapViewController.view];
    _mapViewController.view.frame = _mapViewContainer.bounds;
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
}

- (IBAction)didPressMaps:(UIButton *)sender
{
}

@end
