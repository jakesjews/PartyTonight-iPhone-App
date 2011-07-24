//
//  PartyAnnotation.h
//  PartyTonight
//
//  Created by Jacob Jewell on 2/13/11.
//  Copyright 2011 Immersive Applications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 An single map point annotation representing a party on the mapview
 */
@interface PartyAnnotation : NSObject <MKAnnotation, MKReverseGeocoderDelegate> {
    CLLocationCoordinate2D coordinate;
    NSString *address;
    BOOL busted;
    NSString *rating;
}

//The coordinates of the party
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//Whether the party is busted
@property (assign) BOOL busted;
//The apartment number of the party
@property (nonatomic,retain) NSString *apartment;
//The rating of the party
@property (nonatomic,retain) NSString *rating;

/*
 Creates a party annotation for the location |coordinate| and sets whether it is busted to |busted|,
 its rating to |rating| and its apartment number to |apt| 
 */
- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate: (BOOL) Busted: (NSString *) rating: (NSString *) apt;
/*
 Gets the subtitle for the party annotation
 The subtitle shows if the apartment number, whether the party was busted, and the rating for the party
 */
- (NSString *)subtitle;
/*
 Gets the title for the party annotation
 The title shows the reverse geocoded address for the party
 */
- (NSString *)title;

@end
