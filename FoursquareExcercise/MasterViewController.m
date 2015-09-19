//
//  MasterViewController.m
//  FoursquareExcercise
//
//  Created by Michael on 9/17/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <RestKit/RestKit.h>
#import "Venue.h"
#define kCLIENTID @"IAMG115USX1ZA52JFAQ2VWZQHC4FL532PPPN2PZRY4EJDTBJ"
#define kCLIENTSECRET @"QYQSOIZG0KVAKVMS3O1LZGJ1A5JWGTM5YZYYKZOWKQ2A4MTM"
@interface MasterViewController (){
    NSString *latitude;
    NSString *longitude;
}

@property NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray *venues;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    
    self.locationManager = [appDelegate returnLocationManager];
    [self setLatAndLon];
    [self configureRestKit];
    [self loadVenue];
    NSLog(@"\n viewWillAppear latitude = %@, longitude = %@\n", latitude, longitude);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Lat and Lon

- (void) setLatAndLon {
    
    CLLocation *location = self.locationManager.location;
    latitude = [[NSString alloc] initWithFormat:@"%g", location.coordinate.latitude];
    longitude = [[NSString alloc] initWithFormat:@"%g", location.coordinate.longitude];
    
}

- (IBAction)resetLocation:(id)sender {
    [self setLatAndLon];
    [self configureRestKit];
    [self loadVenue];
    [self.tableView setNeedsDisplay];
}



#pragma mark - Foursquare
- (void) configureRestKit {
    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/v2/venues/search"
                                                keyPath:@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
}

- (void) loadVenue{

    NSString *latLon = [[NSString alloc] initWithFormat:@"%@,%@", latitude, longitude];
    NSString *clientID = kCLIENTID;
    NSString *clientSecret = kCLIENTSECRET;
    
    NSDictionary *queryParams = @{@"ll" : latLon,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"categoryId" : [self catagoryID],
                                  @"v" : @"20140118"};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _venues = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self venues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];


    Venue *venue = _venues[indexPath.row];
    cell.textLabel.text = venue.name;
    return cell;
}

@end
