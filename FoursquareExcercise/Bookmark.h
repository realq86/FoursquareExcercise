//
//  Bookmark.h
//  FoursquareExcercise
//
//  Created by Michael on 9/20/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"
@interface Bookmark : NSObject

@property (nonatomic, strong) NSMutableArray *bookmarks;

- (BOOL)saveBookmarks;
- (Bookmark *)initBookmarks;
- (BOOL)saveVenue:(Venue *)venue;
- (int)size;

@end
