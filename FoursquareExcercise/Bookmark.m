//
//  Bookmark.m
//  FoursquareExcercise
//
//  Created by Michael on 9/20/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

- (Bookmark *)initBookmarks{
    
    self = [super init];
    
    if(self){
        
        NSString *path = [self archivePath];
        self.bookmarks = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if(!self.bookmarks){
            self.bookmarks = [[NSMutableArray alloc] init];
        }
    }
    return self;
    
}

- (int)size{
    
    return [self.bookmarks count];
}

- (BOOL)saveVenue:(Venue *)venue{
    NSString *newVenueName = venue.name;

    
    for(int i=0; i<[self.bookmarks count]; i++){
        Venue *currentVenue = self.bookmarks[i];
        if([currentVenue.name isEqualToString:newVenueName]){
            return NO;
        }
    }
    
    [self.bookmarks addObject:venue];
    
    //return YES for entering a new bookmark
    return YES;
}


- (NSString *)archivePath{
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [[documentDirectories firstObject] stringByAppendingPathComponent:@"bookmarks.archive"];
    
    return path;
    
    
}



- (BOOL)saveBookmarks{
    NSString *path = [self archivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.bookmarks toFile:path];
    
    
}


@end
