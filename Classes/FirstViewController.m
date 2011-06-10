//
//  FirstViewController.m
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "Reachability.h"

@implementation FirstViewController

@synthesize apt,ratio,size,drinks,atmosphere,rate,locationManager,busted;

- (IBAction) buttonPressed:(id)sender 
{
    int rating = 0;
    int bust = 0;
    
    if (busted.on)
    {
        bust = 1;
    }
    
    switch (ratio.selectedSegmentIndex)
    {
        case 0:
            rating = rating + 10;
            break;
        case 1:
            rating = rating - 10;
            break;
    }
    
    switch (size.selectedSegmentIndex)
    {
        case 0:
            rating = rating + 5;
            break;
        case 2:
            rating = rating - 5;
            break;
    }
    
    switch (drinks.selectedSegmentIndex)
    {
        case 0:
            rating = rating + 10;
            break;
    }
    
    switch (atmosphere.selectedSegmentIndex)
    {
        case 0:
            rating = rating + 15;
            break;
        case 1:
            rating = rating - 15;
            break;
    }
    
    CLLocation *curPos = self.locationManager.location;
    
    UIAlertView *alert;
    NSString *latString = [[[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue] substringToIndex:9];
    NSString *lngString = [[[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue] substringToIndex:9];
    NSString *bustedString = [[NSNumber numberWithInt:bust] stringValue];
    NSString *ratingString = [[NSNumber numberWithInt:rating] stringValue];

    if ([self sendRating:latString :lngString :ratingString :bustedString :[apt text]]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Rating submited" message:@"Your rating has been stored" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have already rated this party" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }

    [alert show];
    [alert release];
}

- (BOOL) sendRating: (NSString *) lat:(NSString *) lng:(NSString *) rating:(NSString *) bustedString:(NSString *) apartment {
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSString *idString = [[UIDevice currentDevice].uniqueIdentifier stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *getString = @"";
    NSString *getBody = [NSString stringWithFormat:@"http://ifindparties3.appspot.com/ifindparties?rating=%@&busted=%@&lat=%@&lng=%@&apt=%@&id=%@",rating,bustedString,lat,lng,apartment,idString];
    NSString *combinedRequest = [NSString stringWithFormat:@"%@%@",getString,getBody];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:combinedRequest]];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%d",[getBody length]] forHTTPHeaderField:@"Content-length"];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request release];
       
    if (response.statusCode == 201) {
        return true;
    } else {
        return false;
    }

}

-(IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void) checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"An internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.locationManager startUpdatingLocation];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [[Reachability reachabilityForInternetConnection] retain];
    [reachability startNotifier];
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
    [super viewDidUnload];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ratio release];
    [size release];
    [drinks release];
    [atmosphere release];
    [rate release];
    [busted release];
    [apt release];
    [super dealloc];
}

@end
