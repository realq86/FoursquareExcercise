//
//  MasterViewController.h
//  FoursquareExcercise
//
//  Created by Michael on 9/17/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString* catagoryID;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetLocation;

@end

