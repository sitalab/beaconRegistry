//
//  BeaconRegistrySDK.h
//  BeaconRegistrySDK
//
//  Created by Bilal Itani on 10/27/14.
//  Copyright (c) 2014 SITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconRegistrySDK : NSObject{
    void (^_completionHandler) (NSDictionary *response);
    void (^_completionHandlerDetails) (NSDictionary *response);
    void (^_completionHandlerReport) (int response);
}

/*
 *  @brief Allocates and initializes the BeaconRegistrySDK instance with API info.
 *  @since 1.0
 *
 *  This is the initialization method that will create an instance of the BeaconRegistrySDK and initializes it with API info: APIkey, flightNumber, AppID, EndPoint, and TimeOut.
 *
 */
- (BeaconRegistrySDK*)initializeWithAPIParams:(NSString *)APIkey : (NSString *)AppID : (NSString *)EndPoint : (int)TimeOut;

/*
 *  @brief Initializes the BeaconRegistrySDK instance's flight info.
 *  @since 1.0
 *
 *  This is an optional method that sets the BeaconRegistrySDK flight info: airportCode, flightNumber, flightDate, and flightDate.
 *  @note This method must be called prior to invoking getBeacons:, getBeaconDetails:, addBeaconsLog:, and postBeaconsLogToServer .
 *
 */
- (void)setFlightInfo: (NSString *)airportCode : (NSString *)flightNumber : (NSString *)flightDate : (NSString *)paxName;

/*
 *  @brief Gets available beacons at an airport.
 *  @since 1.0
 *
 *  This method gets a list of available beacons at a selected airport code, it accepts airport code as input and returns a NSDictionary of beacons, response can be retrieved from the completion handler of this method, if airportCode is nil then the airportcode set in method setFlightInfo: will be used.
 *
 */
- (void)getBeacons:(NSString *)airportCode :(void (^) (NSDictionary *response))handler;

/*
 *  @brief Gets a beacon's details.
 *  @since 1.0
 *
 *  This method gets the details of a beacon from registry, it accepts beacon's UUID, major, minor, and rssi code as inputs and returns a NSDictionary of beacon details, response can be retrieved from the completion handler of this method.
 *
 */
- (void)getBeaconDetails:(NSString *)UUID : (NSString *)major : (NSString *)minor : (int)rssi :(void (^) (NSDictionary *response))handler;

/*
 *  @brief Stores a log for a beacon.
 *  @since 1.0
 *
 *  This method accepts an Array of beacon objects (CLBeacon) and locally stores a log for every beacon, later these logs can be posted to API via the postBeaconsLogToServer method.
 *
 */
- (void)beaconDetectionLog:(NSArray *)beaconsArray;

/*
 *  @brief Posts locally stored beacons logs to API.
 *  @since 1.0
 *
 *  This method will post the locally stored beacons logs to API, on success response value will be "200", response can be retrieved from the completion handler of this method.
 *
 */
- (void) beaconDetectionReport:(void (^) (int response))handler;

@end
