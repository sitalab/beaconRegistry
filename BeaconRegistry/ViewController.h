//
//  ViewController.h
//  BeaconRegistry
//
//  Created by Apple on 10/31/14.
//  Copyright (c) 2014 SITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeaconRegistrySDK.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong) BeaconRegistrySDK *beaconRegistrySDKObject;
@property (strong) CLLocationManager *locationManager;
@property (strong) NSMutableArray *tableViewBeaconsArray;
@property (strong) NSMutableArray *tableViewBeaconsActivityArray;
@property (strong) NSMutableArray *arrayOfRegions;
@property (assign) int currentRegionIndex;

@property (strong, nonatomic) IBOutlet UIButton *getBeaconsBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewActivityBtn;
@property (strong, nonatomic) IBOutlet UIButton *provideFeedbackBtn;
@property (strong, nonatomic) IBOutlet UIButton *backToRanging;

@property (strong, nonatomic) IBOutlet UILabel *beaconsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *tableViewLabel;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *activityTableView;

- (IBAction)getBeacons:(id)sender;
- (IBAction)viewActivity:(id)sender;
- (IBAction)provideFeedback:(id)sender;
- (IBAction)backToRanging:(id)sender;
@end
