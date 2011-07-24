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
    int bust = 0;
    
    //Grab the current location
    CLLocation *curPos = self.locationManager.location;
    
    UIAlertView *alert;
    
    //Latitude
    NSString *latString = [[[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue] substringToIndex:9];
    //Longitude
    NSString *lngString = [[[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue] substringToIndex:9];
    //Busted
    NSString *bustedString = [[NSNumber numberWithInt:bust] stringValue];
    //Rating
    NSString *ratingString = [[self getRating] stringValue];

    if (busted.on) {
        bust = 1;
    }
    
    //Try sending the rating and notify the user if the rating submission was successfull
    if ([self sendRating:latString :lngString :ratingString :bustedString :[apt text]]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Rating submited" message:@"Your rating has been stored" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have already rated this party" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }

    //Show the results of the rating
    [alert show];
    [alert release];
}

- (NSNumber *) getRating {
    
    int rating = 0;
    
    //if ratio = + girls add 10
    if (ratio.selectedSegmentIndex == 0) {
        rating += 10;
    } else if (ratio.selectedSegmentIndex == 1) { //If ratio = + guys subtract 10
        rating -= 10;
    }
    
    //If size = big add 5
    if (size.selectedSegmentIndex == 0) {
        rating += 5;
    } else if (size.selectedSegmentIndex == 2) { //if size = small subtract 5
        rating -= 5;
    }
    
    //If drinks = keg then add 10
    if (drinks.selectedSegmentIndex == 0) {
        rating += 10;
    }
    
    //If atmosphere = cool add 15
    if (atmosphere.selectedSegmentIndex == 0) {
        rating += 15;
    } else if (atmosphere.selectedSegmentIndex == 1) { //If atmosphere = shady subtract 15
        rating -= 15;
    }
    
    return [NSNumber numberWithInt: rating];
}

- (BOOL) sendRating: (NSString *) lat:(NSString *) lng:(NSString *) rating:(NSString *) bustedString:(NSString *) apartment {
    
    NSHTTPURLResponse *response;
    NSError *error;
    
    //A unique identifier for the iPhone
    NSString *idString = [[UIDevice currentDevice].uniqueIdentifier stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    // The address that will be used to send the party rating
    // The base url is http://ifindparties3.appspot.com/ifindparties
    // The parameters are rating, busted, lat, lng, apt, and id
    NSString *putRequest = [NSString stringWithFormat:@"http://ifindparties3.appspot.com/ifindparties?rating=%@&busted=%@&lat=%@&lng=%@&apt=%@&id=%@",rating,bustedString,lat,lng,apartment,idString];

    //Make the put request string into a url
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:putRequest]];
    
    //Set the header
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%d",[putRequest length]] forHTTPHeaderField:@"Content-length"];
    
    //Send dat shit
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request release];
    
    //If the response was created then the party was stored
    if (response.statusCode == 201) {
        return true;
    } else { //If the response was accepted then the party has already been rated
        return false;
    }

}

-(IBAction) textFieldDoneEditing:(id)sender {
    //Free the keyboard from bondage
    [sender resignFirstResponder];
}

- (void) checkNetworkStatus:(NSNotification *)notice {
    //Check if we have a connection
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    //If we don't have a network connection slap the user in the face
    if (internetStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"An internet connection is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)viewDidLoad {    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    //Start getting the users location
    [self.locationManager startUpdatingLocation];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    //Set an observer to keep track of the network status
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    reachability = [[Reachability reachabilityForInternetConnection] retain];
    [reachability startNotifier];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    //Stop updating location
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
