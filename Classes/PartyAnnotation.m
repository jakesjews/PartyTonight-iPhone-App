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
    
    if (busted) {
        bustedString = @"BUSTED! ";
    } 
    
    if (apartment == nil || [apartment isEqualToString:@""]) {
        returnApartment = @"";
    } else {
        returnApartment = [NSString stringWithFormat: @"Apartment: %@",apartment];
    }
    
    return [NSString stringWithFormat:@"%@rating = %@ %@",bustedString,rating,returnApartment];
}
- (NSString *)title{
    
    MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
    
    if (!address) {
        return @"Address Not Found";
    } else {
        return [NSString stringWithFormat:@"%@",address];
    }
    
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) cor: (BOOL) bust: (NSString *) rate: (NSString *) apt{
	coordinate = cor;
    busted = bust;
    rating = [rate retain];
    apartment = [apt retain];
	return self;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    address = [placemark.addressDictionary valueForKey:@"Street"];
    [geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)dealloc {
    [rating release];
    [apartment release];
    [super dealloc];
}

@end
