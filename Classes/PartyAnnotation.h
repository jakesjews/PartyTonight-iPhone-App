//
//  PartyAnnotation.h
//  PartyTonight
//
//  Created by Jacob Jewell on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PartyAnnotation : NSObject <MKAnnotation, MKReverseGeocoderDelegate> {
    CLLocationCoordinate2D coordinate;
    NSString *address;
    BOOL busted;
    NSString *rating;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (assign) BOOL busted;
@property (nonatomic,retain) NSString *apartment;
@property (nonatomic,retain) NSString *rating;

- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate: (BOOL) Busted: (NSString *) rating: (NSString *) apt;
- (NSString *)subtitle;
- (NSString *)title;

@end
