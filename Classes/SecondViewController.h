//
//  SecondViewController.h
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2012 Immersive Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Reachability;

@interface SecondViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet MKMapView *partyMap;
    CLLocationManager *locationManager;
    BOOL bannerIsVisible;
    Reachability *reachability;
}

//The mapview that shows the parties
@property (nonatomic, strong) IBOutlet MKMapView *partyMap;
//Location manager
@property (nonatomic, strong) CLLocationManager *locationManager;

//Gets parties for the user's location from the Google App Engine service
- (void) getParties;
//Check if the network is available
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
