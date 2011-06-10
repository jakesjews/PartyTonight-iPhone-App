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

@property (nonatomic, retain) IBOutlet MKMapView *partyMap;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MKReverseGeocoder *reverseCoder;
@property (nonatomic, retain) IBOutlet ADBannerView *adBanner;
@property (nonatomic, assign) BOOL bannerIsVisible;

- (void) getParties;
- (void) bannerViewDidLoadAd:(ADBannerView *)banner;
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
