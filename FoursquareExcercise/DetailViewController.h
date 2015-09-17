//
//  DetailViewController.h
//  FoursquareExcercise
//
//  Created by Michael on 9/17/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

