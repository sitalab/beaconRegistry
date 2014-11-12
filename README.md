
SITA Common Use Beacon Registry
============

This is an example XCode project and library that provides methods to call and interact with the SITA Beacon Registry.

The Beacon Registry is a registry of common use iBeacons for the Air Transport Industry (ATI).

The registry is a SITA initiative and provides the following services:

- It allows beacon owners (airlines, airports or 3rd parties) to manage their beacon infrastructure and track where they are placed in an airport.
- It enables airports to monitor beacon deployment to prevent radio interference with existing Wi-Fi access points
- It provides beacons owners with a simple mechanism to set the 'meta-data' associated with beacons.
- It provides an API for app developers who want to use these beacons for developing travel and other related apps.

The aims of the registry are to promote the use of beacons in the Air Transport Industry and reduce the cost and complexity of deployment. This can be achieved with the following design goals:

- Promote shared beacon infrastructure to reduce cost and complexity of deployment.
- Introduce standard beacon types and data definition to encourage reuse.
- Provide a simple to use API to discover beacons and get meta-data about beacons.
- Provide tools to airport operators and beacon owners to visualize and track beacons.
- Be vendor agnostic - the service should work with beacons from any vendor.

Please visit [developer.aero](http://www.developer.aero) for more information on the Beacon Registry.

What the sample app does
============

The app is a simple use case showing how to use the three key APIs from the SITA iBeacon Common Use Registry. 

- Get list of beacons at a given airport
- Get details about a specific beacon at a given airport
- Post a beacon detection report to be used for health monitoring of beacons at the registry.

Additionally, the methods above are complimented with some code to:

- Range for beacons based upon unique UUIDs returned from the registry.
- Store beacon detection logs in application local storage until they are posted to the registry.
- Trigger method to post the beacon detection report.

How to build the sample app
============

- Download this package and launch the project in Xcode.  
- Add your API Key and AppID to the constants.h (get your API keys from  [developer.aero](http://www.developer.aero))
- Fix the provisioning and code signing files.
- Turn Bluetooth ON on your device.
- Build the project to your iOS device.

When the application launches and you tap on the Get Beacons button, the app will retrieve a list of beacons for the airport defined in constants.h. The app will then:

- Range for beacons in the proximity of your device.
- Show beacons that match the registry and others that may not already be included.  All beacons that show up when the app ranges will be saved to the beacon detection logs.
- Tapping on a beacons that is registered in the registry will get details about this beacon.
- Post the beacon detection report to the registry when the device is no longer in proximity of the beacons.

How can I use this code in my project?
============

The methods for using the Beacon Registry are included in the /BeaconRegistrySDK folder of the project:

- Include the /BeaconRegistrySDK folder in your project. (BeaconRegistrySDK.h & libBeaconRegistrySDK.a)
- Link the library (libBeaconRegistrySDK.a) in your project:
![alt tag](https://github.com/sitalab/beaconRegistry/blob/master/BeaconRegistrySDK%20Library.png)

The library has multiple methods you can use all included in BeaconRegistrySDK.h:

'- (BeaconRegistrySDK*)initializeWithAPIParams:(NSString *)APIkey : (NSString *)AppID : (NSString *)EndPoint : (int)TimeOut;'
 This is the initialization method that will create an instance of the BeaconRegistrySDK and initializes it with API info: APIkey, flightNumber, AppID, service endpoint, and timeout.

'- (void)setFlightInfo: (NSString *)airportCode : (NSString *)flightNumber : (NSString *)flightDate : (NSString *)paxName;'
This is a mandatory method that sets the BeaconRegistrySDK flight info: airportCode, flightNumber, flightDate, and flightDate.  This method must be called prior to invoking getBeacons:, getBeaconDetails:, addBeaconsLog:, and postBeaconsLogToServer.

'- (void)getBeacons:(NSString *)airportCode :(void (^) (NSDictionary *response))handler;'
This method gets a list of beacons at a given airport code, it accepts airport code as input and returns a NSDictionary of beacons, response can be retrieved from the completion handler of this method, if airportCode is nil then the airportcode set in method setFlightInfo: will be used.

'- (void)getBeaconDetails:(NSString *)UUID : (NSString *)major : (NSString *)minor : (int)rssi :(void (^) (NSDictionary *response))handler;'
This method gets the details of a beacon from registry, it accepts beacon's UUID, major, minor, and rssi code as inputs and returns a NSDictionary of beacon details, response can be retrieved from the completion handler of this method.

'- (void)beaconDetectionLog:(NSArray *)beaconsArray;'
This method accepts an Array of beacon objects (CLBeacon) and locally stores a log for every beacon, later these logs can be posted to API via the postBeaconsLogToServer method.


'- (void) beaconDetectionReport:(void (^) (int response))handler;'
This method will post the locally stored beacons logs to API, on success response value will be "200", response can be retrieved from the completion handler of this method.



FAQs
===
- Can I get access to the iBeacons deployed at airports?
-- Currently access is still limited to airlines, airports and ground handlers. The plan is to open access to general 3rd parties in the future. 


Contributors
============
* [bilalitani](https://github.com/bilalitani) / Bilal Itani
* [kosullivansita](https://github.com/kosullivansita) / [Kevin O'Sullivan](http://www.sita.aero/surveys-reports/sita-lab)

License
=======

This project is licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
