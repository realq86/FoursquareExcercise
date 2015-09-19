//
//  AppDelegate.h
//  FoursquareExcercise
//
//  Created by Michael on 9/17/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(CLLocationManager*)returnLocationManager;

@end

