//
//  CrimeSpottingItem.m
//  PublicSafety
//
//  Created by Buffalo Hird on 11/2/13.
//  Copyright (c) 2013 Buffalo Hird. All rights reserved.
//

#import "CrimeSpottingItem.h"

@implementation CrimeSpottingItem 

@synthesize itemId = _itemId;

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

-(void)initFromDictionary:(NSDictionary *)dictionary
{ 
    self.itemId = [dictionary[@"id"] intValue];
    self.title = dictionary[@"properties"][@"crime_type"];
    self.title = [self.title capitalizedString]; 
    
    self.time = dictionary[@"properties"][@"date_time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.date = [[NSDate alloc] init];
    self.date = [dateFormatter dateFromString: self.time];
    
    self.subtitle = dictionary[@"properties"][@"description"];
    self.subtitle = [[[self.subtitle substringToIndex:1] uppercaseString] stringByAppendingString:[[self.subtitle substringFromIndex:1] lowercaseString]];
    self.longitude = [dictionary[@"geometry"][@"coordinates"][0] doubleValue];
    self.latitude = [dictionary[@"geometry"][@"coordinates"][1] doubleValue];
    self.type = @"police"; 
    
}

- (UIImage*) thumbnail
{
    return [UIImage imageNamed: [NSString stringWithFormat:@"%@.jpg", self.title]];
}

@end
