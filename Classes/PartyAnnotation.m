//
//  PartyAnnotation.m
//  PartyTonight
//
//  Created by Jacob Jewell on 2/13/11.
//  Copyright 2012 Immersive Applications. All rights reserved.
//

#import "PartyAnnotation.h"

@implementation PartyAnnotation
@synthesize coordinate, busted, rating, apartment, geocoder;

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
    return [NSString stringWithFormat:@"%@Rating = %@ %@",bustedString,rating,returnApartment];
}
- (NSString *)title{
    
    //Either show the address or notify the user that the address was not found
    if (!address) {
        return @"Address Not Available";
    } else {
        return [NSString stringWithFormat:@"%@", address];
    }
    
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) cor :(BOOL)bust :(NSString *) rate :(NSString *) apt {
    if ( self = [super init] ) {
        geocoder = [[CLGeocoder alloc] init];
        coordinate = cor;
        busted = bust;
        rating = rate;
        apartment = apt;

        CLLocation *location = [[CLLocation alloc] initWithLatitude:cor.latitude longitude:cor.longitude];

        [[self geocoder] reverseGeocodeLocation:location completionHandler: ^void (NSArray *placemarks, NSError *error) {
            if (error != nil) {
                NSLog(@"%@",error);
            }
            else if (placemarks.count > 0) {
                MKPlacemark *placemark = placemarks[0];
                address = [placemark.addressDictionary valueForKey:@"Street"];
            }
        }];
        
    }

    return self;
}

@end
