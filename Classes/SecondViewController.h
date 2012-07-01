//
//  SecondViewController.h
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Reachability;

@interface SecondViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, ADBannerViewDelegate>
{
    IBOutlet MKMapView *partyMap;
    CLLocationManager *locationManager;
    BOOL adBannerViewIsVisible;
    ADBannerView *adBanner;
    BOOL bannerIsVisible;
    Reachability *reachability;
}

//The mapview that shows the parties
@property (nonatomic, strong) IBOutlet MKMapView *partyMap;
//Location manager
@property (nonatomic, strong) CLLocationManager *locationManager;
//Used to display beautiful ads for the benefit of the user
@property (nonatomic, strong) IBOutlet ADBannerView *adBanner;
//Whether the ad will be shown, needed when there are no available ads to display so apple doesn't
//get pissed off
@property (nonatomic, assign) BOOL bannerIsVisible;

//Gets parties for the user's location from the Google App Engine service
- (void) getParties;
//If the banner loaded an ad make sure it is visible
- (void) bannerViewDidLoadAd:(ADBannerView *)banner;
//If the banner failed to load an ad make it invisible
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;
//Check if the network is available
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
