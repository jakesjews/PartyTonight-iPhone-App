//
//  FirstViewController.h
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Reachability;

@interface FirstViewController : UIViewController {
    UISegmentedControl *ratio;
    UISegmentedControl *size;
    UISegmentedControl *drinks;
    UISegmentedControl *atmosphere;
    UISwitch *busted;
    UIButton *rate;
    CLLocationManager *locationManager;
    UITextField *apt;
    Reachability *reachability;
}

@property (nonatomic,retain) IBOutlet UISegmentedControl *ratio;
@property (nonatomic,retain) IBOutlet UISegmentedControl *size;
@property (nonatomic,retain) IBOutlet UISegmentedControl *drinks;
@property (nonatomic,retain) IBOutlet UISegmentedControl *atmosphere;
@property (nonatomic,retain) IBOutlet UISwitch *busted;
@property (nonatomic,retain) IBOutlet UIButton *rate;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UITextField *apt;

- (IBAction) buttonPressed: (id) sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (BOOL) sendRating: (NSString *) lat:(NSString *) lng:(NSString *) rating:(NSString *) bustedString:(NSString *) apartment;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
