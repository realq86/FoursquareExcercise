//
//  CatagoryViewController.m
//  FoursquareExcercise
//
//  Created by Michael on 9/18/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "CatagoryViewController.h"
#import "MasterViewController.h"
@interface CatagoryViewController ()



@end

@implementation CatagoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *segueID = [segue identifier];
    
    MasterViewController *destinationController = [segue destinationViewController];
    
    if([segueID isEqualToString:@"showFood"]){
        destinationController.catagoryID = @"4d4b7105d754a06374d81259";
        destinationController.navigationItem.title = @"Food";
    }
    else if([segueID isEqualToString:@"showHotel"]){
        destinationController.catagoryID = @"4bf58dd8d48988d1fa931735";
        destinationController.navigationItem.title = @"Hotel";

    }
    else if([segueID isEqualToString:@"showShopping"]){
        destinationController.catagoryID = @"4bf58dd8d48988d1fd941735";
        destinationController.navigationItem.title = @"Shopping";

    }
    else if([segueID isEqualToString:@"showPlay"]){
        destinationController.catagoryID = @"4d4b7104d754a06370d81259";
        destinationController.navigationItem.title = @"Play";

    }

}


@end
