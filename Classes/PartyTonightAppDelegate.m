//
//  PartyTonightAppDelegate.m
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2012 Immersive Applications. All rights reserved.
//

#import "PartyTonightAppDelegate.h"

#pragma mark -
#pragma mark PartyTonightAppDelegate

@implementation PartyTonightAppDelegate

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}


@end
