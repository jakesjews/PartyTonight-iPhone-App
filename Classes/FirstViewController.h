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

//The ratio picker
@property (nonatomic,strong) IBOutlet UISegmentedControl *ratio;
//The size picker
@property (nonatomic,strong) IBOutlet UISegmentedControl *size;
//The drinks picker
@property (nonatomic,strong) IBOutlet UISegmentedControl *drinks;
//The atmosphere picker
@property (nonatomic,strong) IBOutlet UISegmentedControl *atmosphere;
//The busted switch
@property (nonatomic,strong) IBOutlet UISwitch *busted;
//The button to rate the party
@property (nonatomic,strong) IBOutlet UIButton *rate;
//Location manager
@property (nonatomic,strong) CLLocationManager *locationManager;
//Text field to input the apartment name
@property (nonatomic, strong) IBOutlet UITextField *apt;

//Handles the rating button being pressed
- (IBAction) buttonPressed: (id) sender;
//Handles the user finishing editing the apartment number
- (IBAction)textFieldDoneEditing:(id)sender;
/*
 Sends rating details made of |lat|, |lng|, |rating|, |bustedString| and |apartment| to the google app engine servlet 
 */
- (BOOL) sendRating: (NSString *) lat:(NSString *) lng:(NSString *) rating:(NSString *) bustedString:(NSString *) apartment;
//Checks if there network is available
- (void) checkNetworkStatus:(NSNotification *)notice;
//Computers the parties rating based on the user's selection
- (NSNumber *) getRating;

@end
