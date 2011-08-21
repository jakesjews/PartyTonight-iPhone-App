//
//  SecondViewController.m
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import <CFNetwork/CFNetwork.h>
#import "PartyAnnotation.h"
#import "Reachability.h"

@implementation SecondViewController

@synthesize partyMap,locationManager,bannerIsVisible,adBanner;

NSString * const serviceURL = @"http://ifindparties3.appspot.com/ifindparties?";

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    adBanner.delegate = self;
    [super viewDidLoad];
}

- (void) getParties
{
    //Retrieve the parties on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Get the current location
        CLLocation *curPos = self.locationManager.location;
        
        //Latitude
        NSString *lat = [[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue];
        if ([lat length] > 9) { lat = [ lat substringToIndex:9]; }
        
        //Longitude
        NSString *lng = [[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue];
        if ([lng length] > 9) { lng = [ lng substringToIndex:9]; } 

        //Load an array from a plist file returned by the google app engine servlet.
        //The servlet needs the users latitude and longitude to determine what parties to send
        NSArray *parties = [NSArray arrayWithContentsOfURL:
                            [NSURL URLWithString:[NSString stringWithFormat:
                                                  @"%@?lat=%@&lng=%@", serviceURL, lat,lng]]];
        
        //Run this on a the main thread so the UI can be updated
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //For each party make a map annotation
            for (NSArray *party in parties) {
                
                //Need to fix this in the future so it doesn't depend on a magical order of the elements
                NSNumber *latitude = [party objectAtIndex:0];
                NSNumber *longitude = [party objectAtIndex:1];
                NSString *apartment = [party objectAtIndex:2];
                NSString *rating = [party objectAtIndex:3];
                NSNumber *busted = [party objectAtIndex:4];
                
                //Build a coordinate for the party from its latitude and longitude
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)latitude.doubleValue,((CLLocationDegrees)longitude.doubleValue)); 
                
                //Create and add the parties annotation
                PartyAnnotation *annotation = [[[PartyAnnotation alloc] initWithCoordinate:coordinate :[busted boolValue] :rating : apartment]autorelease]; 
                [partyMap addAnnotation:annotation];
            } 
        });
    });
}

/*
 This is supposed to change the color of the pin and do other effects but I haven't got it working yet
 */
- (MKAnnotationView *)partyMap:(MKMapView *)Mv viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *defaultPinID = @"party";
    
    if ([annotation isKindOfClass:[PartyAnnotation class]]) {
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[partyMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if (pinView == nil)
        {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID]autorelease];
        } else {
            pinView.annotation = annotation;
        }
        
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        pinView.pinColor = MKPinAnnotationColorGreen;
        
        return pinView;
        
    }
    
    return nil;
}

- (void) checkNetworkStatus:(NSNotification *)notice {
    //Check if there is a network connection
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    //Alert the user if there is not network connection
    if (internetStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"An internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Start grabbing the current location
    [self.locationManager startUpdatingLocation];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    //Get the current location so we can set the map view's center to it
    CLLocationCoordinate2D location = {.latitude = locationManager.location.coordinate.latitude, .longitude = locationManager.location.coordinate.longitude};
    
    //Show a half mile region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5*1609.344, 0.5*1609.344);
    MKCoordinateRegion adjustedRegion = [partyMap regionThatFits:viewRegion];
    [partyMap setRegion:adjustedRegion animated:YES];
    
    partyMap.delegate = self;
    
    //Add a monitor for the network connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    reachability = [[Reachability reachabilityForInternetConnection] retain];
    [reachability startNotifier];
    
    //Get parties to fill the map
    [self getParties];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    //If the ad banner was not visible and an ad was loaded then make the banner visible
    if (!self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    //If the ad banner was visible but an ad could not be loaded then make the banner invisible
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    [self setAdBanner:nil];
    [super viewDidUnload];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    self.partyMap = nil;
}

- (void)dealloc {
    [partyMap release];
    [locationManager release];
    [adBanner release];
    [super dealloc];
}

@end
