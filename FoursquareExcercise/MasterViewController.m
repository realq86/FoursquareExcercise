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
#import "MyTableViewCell.h"

#define kCLIENTID @"IAMG115USX1ZA52JFAQ2VWZQHC4FL532PPPN2PZRY4EJDTBJ"
#define kCLIENTSECRET @"QYQSOIZG0KVAKVMS3O1LZGJ1A5JWGTM5YZYYKZOWKQ2A4MTM"
@interface MasterViewController (){
    NSString *latitude;
    NSString *longitude;
    Bookmark *bookmarks;
}

@property NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray *venues;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    bookmarks = [[Bookmark alloc] initBookmarks];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.locationManager = [appDelegate returnLocationManager];
    [self setLatAndLon];
    [self configureRestKit];
    [self loadVenue];
    NSLog(@"\n viewWillAppear latitude = %@, longitude = %@\n", latitude, longitude);

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [bookmarks saveBookmarks];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
        return [bookmarks size];
    
    else if(section ==1)
        return [[self venues] count];
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    
    if(section ==0)
        headerCell.textLabel.text = @"BOOKMARKS";
    
    else if(section ==1){
        headerCell.textLabel.text = @"LOCATIONS";
    }
    return headerCell;
    
}

- (MyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Venue *venue;
    if (indexPath.section == 0) {
        
        venue = bookmarks.bookmarks[indexPath.row];
    }
    
    if(indexPath.section==1){
        cell.likeButton.tag = indexPath.row;
        [cell.likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
        venue = _venues[indexPath.row];
    }
    
    cell.name.text = venue.name;
    
    return cell;
}



- (void)likeButtonClicked:(UIButton *)sender{
    int buttonIndex = sender.tag;
    Venue *venue = self.venues[buttonIndex];
    
    BOOL newBookmark = [bookmarks saveVenue:venue];
    
    if(newBookmark == YES){
        UIAlertView *bookmarkAlert = [[UIAlertView alloc] initWithTitle:@"Location added to bookmark!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [bookmarkAlert show];
        [bookmarkAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];

}

@end
