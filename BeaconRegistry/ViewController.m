//
//  ViewController.m
//  BeaconRegistry
//
//  Created by Apple on 10/31/14.
//  Copyright (c) 2014 SITA. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _tableViewBeaconsArray = [[NSMutableArray alloc] init];
    _tableViewBeaconsActivityArray = [[NSMutableArray alloc] init];
    _arrayOfRegions = [[NSMutableArray alloc] init];
    _currentRegionIndex = 0;
    
    _beaconsCountLabel.hidden = YES;
    _viewActivityBtn.hidden = YES;
    _tableViewLabel.hidden = YES;
    _mainTableView.hidden = YES;
    _provideFeedbackBtn.hidden = YES;
    _backToRanging.hidden = YES;
    
    //API and Flight info are set in Constants.h
    _beaconRegistrySDKObject = [[BeaconRegistrySDK alloc]initializeWithAPIParams:BeaconRegistryAPIKey :AppId :EndPointURL :Timeout];
    [_beaconRegistrySDKObject setFlightInfo: AirportCode: Flight :FlightDate :PassengerName];
    
    _locationManager = [[CLLocationManager alloc] init];
    for (CLBeaconRegion *monitoredRegion in [_locationManager monitoredRegions]){
        [_locationManager stopMonitoringForRegion:monitoredRegion];
    }
    _locationManager.delegate = self;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _activityTableView.hidden = YES;
    _activityTableView.delegate = self;
    _activityTableView.dataSource = self;
    
    //Removing all monitored regions to monitor for a fresh list later
    for (CLBeaconRegion *monitoredRegion in [_locationManager monitoredRegions]){
        [_locationManager stopMonitoringForRegion:monitoredRegion];
    }
}

- (IBAction)getBeacons:(id)sender{
    _getBeaconsBtn.enabled = NO;
    [_beaconRegistrySDKObject getBeacons:AirportCode :^(NSDictionary* response){
        _getBeaconsBtn.enabled = YES;
        //NSLog(@"getBeacons response %@", response);
        if ([[response objectForKey:@"beaconsList"] isKindOfClass:[NSArray class]]) {
            if([[response objectForKey:@"beaconsList"] count] > 0)
            {
                NSMutableArray *beacons = [response objectForKey:@"beaconsList"];
                NSMutableArray *arrayOfUniqueUUIDs = [[NSMutableArray alloc] init];
                
                _beaconsCountLabel.hidden = NO;
                _beaconsCountLabel.text = [NSString stringWithFormat:@"%lu Beacons retrieved from registry", (unsigned long)beacons.count];
                
                for (id currBeaconObj in beacons) {
                    if( ![arrayOfUniqueUUIDs containsObject:[currBeaconObj objectForKey:@"uuid"]] ){
                        [arrayOfUniqueUUIDs addObject:[currBeaconObj objectForKey:@"uuid"]];
                    }
                }
                
                for (CLBeaconRegion *monitoredRegion in [_locationManager monitoredRegions]){
                    [_locationManager stopMonitoringForRegion:monitoredRegion];
                }
                
                //NSLog(@"Unique Beacons: %@",arrayOfUniqueUUIDs);
                
                for (int i = 0; i < arrayOfUniqueUUIDs.count; i++) {
                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:arrayOfUniqueUUIDs[i]] identifier:[NSString stringWithFormat:@"BeaconReg%d", i]];
                    region.notifyOnEntry = TRUE;
                    region.notifyOnExit = TRUE;
                    region.notifyEntryStateOnDisplay = YES;
                    [_locationManager startMonitoringForRegion:region];
                    [_arrayOfRegions addObject:region];
                }
            }
        }
    }];
}

- (IBAction)viewActivity:(id)sender{
    [self sopRangingAllRegions];
    _mainTableView.hidden = YES;
    _viewActivityBtn.hidden = YES;
    
    _provideFeedbackBtn.hidden = NO;
    _backToRanging.hidden = NO;
    _activityTableView.hidden = NO;
    [_activityTableView reloadData];

}

- (IBAction)provideFeedback:(id)sender{
    _provideFeedbackBtn.hidden = YES;
    _backToRanging.hidden = NO;
    
    [_beaconRegistrySDKObject beaconDetectionReport:^(int response){
        if( response == 200 ){
            _tableViewBeaconsActivityArray = nil;
            _tableViewBeaconsActivityArray = [[NSMutableArray alloc] init];
            [_activityTableView reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Feedback sent!"
                                  message: nil
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            _provideFeedbackBtn.hidden = NO;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Feedback sending failed!"
                                  message: nil
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
     }];
}

- (IBAction)backToRanging:(id)sender{
    [self startRangingAllRegions];
    _activityTableView.hidden = YES;
    _provideFeedbackBtn.hidden = YES;
    _backToRanging.hidden = YES;
    _mainTableView.hidden = NO;
    _viewActivityBtn.hidden = NO;
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [_locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        NSLog(@"didDetermineState ProximityUUID:%@", beaconRegion.proximityUUID);
        
        if (state == CLRegionStateInside) {
            [_locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", [error description]);
}

- (void) locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    
    NSLog(@"%@", [error description]);
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        NSLog(@"monitoringDidFailForRegion: ProximityUUID:%@", beaconRegion.proximityUUID);
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        NSLog(@"didEnterRegion ProximityUUID:%@", beaconRegion.proximityUUID);
        
        [_locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        NSLog(@"didExitRegion ProximityUUID:%@", beaconRegion.proximityUUID);
    }
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count > 0){
        [_beaconRegistrySDKObject beaconDetectionLog:beacons];
        for(id currBeacon in beacons){
            CLBeacon *beacon = currBeacon;
            
            NSLog(@"%@", beacon.description);
            
            NSString *currentKey = [NSString stringWithFormat:@"%@%@%@",[[beacon proximityUUID] UUIDString],[beacon.major stringValue],[beacon.minor stringValue]];
            
            NSMutableDictionary *tempBeacon = [[NSMutableDictionary alloc] init];
            [tempBeacon setObject:[beacon.proximityUUID UUIDString] forKey:@"uuid"];
            [tempBeacon setObject:beacon.major forKey:@"majorId"];
            [tempBeacon setObject:beacon.minor forKey:@"minorId"];
            [tempBeacon setObject:[self textForProximity:beacon.proximity] forKey:@"proximity"];
            NSString *rssi = [NSString stringWithFormat:@"%ld", (long)beacon.rssi];
            [tempBeacon setObject:rssi forKey:@"rssi"];
            
            //Ranging
            int existRanging = 0;
            for(int i = 0; i < _tableViewBeaconsArray.count; i++)
            {
                NSString *savedKey = [NSString stringWithFormat:@"%@%@%@",[_tableViewBeaconsArray[i] objectForKey:@"uuid"],[_tableViewBeaconsArray[i] objectForKey:@"majorId"],[_tableViewBeaconsArray[i] objectForKey:@"minorId"]];
                if([currentKey isEqualToString:savedKey])
                    existRanging++;
            }
            if(existRanging == 0)
                [_tableViewBeaconsArray insertObject:tempBeacon atIndex:_tableViewBeaconsArray.count];
            //Ranging
            
            //Activity
            int existActivity = 0;
            for(int i = 0; i < _tableViewBeaconsActivityArray.count; i++)
            {
                NSString *savedKey = [NSString stringWithFormat:@"%@%@%@",[_tableViewBeaconsActivityArray[i] objectForKey:@"uuid"],[_tableViewBeaconsActivityArray[i] objectForKey:@"majorId"],[_tableViewBeaconsActivityArray[i] objectForKey:@"minorId"]];
                
                if([currentKey isEqualToString:savedKey]){
                    existActivity++;
                    long currCount = [[_tableViewBeaconsActivityArray[i] objectForKey:@"detectionCount"] longValue];
                    currCount++;
                    [_tableViewBeaconsActivityArray[i] setValue:@(currCount) forKey:@"detectionCount"];
                }
            }
            if(existActivity == 0){
                [tempBeacon setObject:@(1) forKey:@"detectionCount"];
                [_tableViewBeaconsActivityArray addObject:tempBeacon];
            }
            //Activity
        }
        
        if(_activityTableView.hidden == YES){
            _viewActivityBtn.hidden = NO;
            _tableViewLabel.hidden = NO;
            _mainTableView.hidden = NO;
        }
        
        [_mainTableView reloadData];
        [_locationManager stopRangingBeaconsInRegion:region];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if(_activityTableView.hidden == YES){
                _tableViewBeaconsArray = nil;
                [_mainTableView reloadData];
                _tableViewBeaconsArray = [[NSMutableArray alloc] init];
                    [self startRangingAllRegions];
            }
        });
    }
}

- (void) sopRangingAllRegions
{
    for (CLBeaconRegion *monitoredRegion in _arrayOfRegions){
        [_locationManager stopRangingBeaconsInRegion:monitoredRegion];
    }
}

- (void) startRangingAllRegions
{
    for (CLBeaconRegion *monitoredRegion in _arrayOfRegions){
        [_locationManager startRangingBeaconsInRegion:monitoredRegion];
    }
}

#pragma mark Table View Functions

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( tableView == _mainTableView )
        return _tableViewBeaconsArray.count;
    else
        return _tableViewBeaconsActivityArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item;
    if( tableView == _mainTableView )
        item = _tableViewBeaconsArray[indexPath.row];
    else
        item = _tableViewBeaconsActivityArray[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UILabel *UUIDLabel = [[UILabel alloc] init];
    [UUIDLabel setFrame:CGRectMake(10, 5, 300, 20)];
    [UUIDLabel setText:[item objectForKey:@"uuid"]];
    [UUIDLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    UILabel *majorLabel = [[UILabel alloc] init];
    [majorLabel setFrame:CGRectMake(10, 30, 150, 20)];
    [majorLabel setText:[[item objectForKey:@"majorId"] stringValue]];
    [majorLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    UILabel *minorLabel = [[UILabel alloc] init];
    [minorLabel setFrame:CGRectMake(160, 30, 150, 20)];
    [minorLabel setText:[[item objectForKey:@"minorId"] stringValue]];
    [minorLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    if( tableView == _mainTableView ){
        UILabel *proximityLabel = [[UILabel alloc] init];
        [proximityLabel setFrame:CGRectMake(10, 55, 150, 20)];
        [proximityLabel setText:[item objectForKey:@"proximity"]];
        [proximityLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
        UILabel *rssiLabel = [[UILabel alloc] init];
        [rssiLabel setFrame:CGRectMake(160, 55, 150, 20)];
        [rssiLabel setText:[item objectForKey:@"rssi"]];
        [rssiLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
        [cell.contentView addSubview:proximityLabel];
        [cell.contentView addSubview:rssiLabel];
    }else{
        UILabel *detectionLabel = [[UILabel alloc] init];
        [detectionLabel setFrame:CGRectMake(10, 55, 300, 20)];
        [detectionLabel setText:[NSString stringWithFormat:@"Detection Count: %@", [item objectForKey:@"detectionCount"]]];
        [detectionLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [cell.contentView addSubview:detectionLabel];
    }
    
    [cell.contentView addSubview:UUIDLabel];
    [cell.contentView addSubview:majorLabel];
    [cell.contentView addSubview:minorLabel];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separatorLineView.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:separatorLineView];
    [cell setBackgroundColor: [UIColor colorWithRed:256 green:256 blue:256 alpha:1.0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item;
    if( _mainTableView.hidden == NO )
        item = _tableViewBeaconsArray[indexPath.row];
    else
        item = _tableViewBeaconsActivityArray[indexPath.row];
    
    [_beaconRegistrySDKObject getBeaconDetails:[item objectForKey:@"uuid"] :[item objectForKey:@"majorId"] :[item objectForKey:@"minorId"] :[[item objectForKey:@"rssi"] intValue] :^(NSDictionary *response){
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Beacon Details!"
                              message: [response description]
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }];
}

- (NSString *)textForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return @"Far";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        default:
            return @"Unknown";
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
