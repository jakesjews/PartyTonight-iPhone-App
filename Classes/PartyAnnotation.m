//
//  PartyAnnotation.m
//  PartyTonight
//
//  Created by Jacob Jewell on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PartyAnnotation.h"

@implementation PartyAnnotation
@synthesize coordinate,busted,rating,apartment;

- (NSString *)subtitle{
    
    NSString *bustedString = @"";
    NSString *returnApartment;
    
    //Show if the party was busted
    if (busted) {
        bustedString = @"BUSTED! ";
    } 
    
    //If there is an apartment number 
    if (apartment == nil || [apartment isEqualToString:@""]) {
        returnApartment = @"";
    } else {
        returnApartment = [NSString stringWithFormat: @"Apartment: %@",apartment];
    }
    
    //Return the subtitle in the format '[busted?] rating = [rating] Apartment: [Apartment]
    return [NSString stringWithFormat:@"%@rating = %@ %@",bustedString,rating,returnApartment];
}
- (NSString *)title{
    
    //Fire up the reverse geocoder
    MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
    
    //Either show the address or notify the user that the address was not found
    if (!address) {
        return @"Address Not Found";
    } else {
        return [NSString stringWithFormat:@"%@",address];
    }
    
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) cor: (BOOL) bust: (NSString *) rate: (NSString *) apt{
	coordinate = cor;
    busted = bust;
    rating = rate;
    apartment = apt;
	return self;
}

/*
 Called when the reverse geocoder successfully translates coordinated
 */
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    address = [placemark.addressDictionary valueForKey:@"Street"];
}

/*
 Log the error if the reverse geocoder fails
 */
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}


@end
