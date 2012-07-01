//
//  PartyTonightAppDelegate.h
//  PartyTonight
//
//  Created by Jacob Jewell on 12/21/10.
//  Copyright 2012 Immersive Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartyTonightAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;

@end
