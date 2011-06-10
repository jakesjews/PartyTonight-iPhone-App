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

@synthesize partyMap,locationManager,reverseCoder,bannerIsVisible,adBanner;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    adBanner.delegate = self;
    [super viewDidLoad];
}

- (void) getParties
{
    CLLocation *curPos = self.locationManager.location;
    NSArray *parties = [NSArray arrayWithContentsOfURL:
                        [NSURL URLWithString:[NSString stringWithFormat:
                        @"http://ifindparties3.appspot.com/ifindparties?lat=%@&lng=%@",
                                              [[[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue] substringToIndex:9],[[[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue] substringToIndex:9]]]];
    for (NSArray *party in parties) {
            
        NSNumber *latitude = [party objectAtIndex:0];
        NSNumber *longitude = [party objectAtIndex:1];
        NSString *apartment = [party objectAtIndex:2];
        NSString *rating = [party objectAtIndex:3];
        NSNumber *busted = [party objectAtIndex:4];
            
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)latitude.doubleValue,((CLLocationDegrees)longitude.doubleValue)); 
            
        PartyAnnotation *annotation = [[[PartyAnnotation alloc] initWithCoordinate:coordinate :[busted boolValue] :rating : apartment]autorelease]; 
            
        [partyMap addAnnotation:annotation];
    } 
}

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
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"An internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.locationManager startUpdatingLocation];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D location = {.latitude = locationManager.location.coordinate.latitude, .longitude = locationManager.location.coordinate.longitude};
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5*1609.344, 0.5*1609.344);
    MKCoordinateRegion adjustedRegion = [partyMap regionThatFits:viewRegion];
    [partyMap setRegion:adjustedRegion animated:YES];
    
    partyMap.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [[Reachability reachabilityForInternetConnection] retain];
    [reachability startNotifier];
    
    [self getParties];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    if (!self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
