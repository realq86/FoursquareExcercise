//
//  Venue.m
//  FoursquareExcercise
//
//  Created by Michael on 9/17/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "Venue.h"

@implementation Venue


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"bookMarkName"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        
        _name = [aDecoder decodeObjectForKey:@"bookMarkName"];
        
    }
    
    return self;
    
}



@end
