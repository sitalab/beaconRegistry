
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

Please visit [Developer.aero](http://www.developer.aero) for more information on the Beacon Registry.

What it does
============

The app is a simple use case showing how to use the three key APIs from the SITA iBeacon Common Use Registry. 

- Get list of beacons at a given airport
- Get details about a specific beacon at a given airport
- Post a beacon detection report to be used for health monitoring of beacons at the registry.

The methods above are included in a library that you can reuse  with a


![alt tag](https://raw.github.com/username/projectname/branch/path/to/img.png)




The first two APIs are called on app startup. The third API is called when the user comes into proximity of an iBeacon, to get the meta-details for that iBeacon.

FAQ
===
- Can I get access to the iBeacons deployed at airports
- Currently access is still limited to airlines, airports and ground handlers. The plan is to open access to general 3rd parties in the future. 
- How do I build the project
- To build the project, check out the code (don't forget to use the --recursive option) and run the beaconTrac project in Xcode.
- Update constants.h with your own API and Google Maps SDK keys.  
- Update constants.h the appid.


Contributors
============
* [bilalitani](https://github.com/bilalitani) / Bilal Itani
* [kosullivansita](https://github.com/kosullivansita) / [Kevin O'Sullivan](http://www.sita.aero/surveys-reports/sita-lab)

License
=======

This project is licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
