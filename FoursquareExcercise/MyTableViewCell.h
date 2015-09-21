//
//  MyTableViewCell.h
//  FoursquareExcercise
//
//  Created by Michael on 9/20/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end
