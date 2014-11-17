//
//  UserGenerated.m
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/2/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import "UserGenerated.h"

@implementation UserGenerated

- (void)getDataForParseObject:(NSString *)data
{
    PFQuery *newQuery = [PFQuery queryWithClassName: data];
    newQuery.limit = 1000;
    NSArray* objects = [newQuery findObjects];
    NSMutableArray *returnObjects = [[NSMutableArray alloc] init];
    for (PFObject *item in objects)
    {
        UserGeneratedItem* newItem = [[UserGeneratedItem alloc] init];
        [newItem initFromParseObject:item];
        [returnObjects addObject: newItem];
    }
    self.items = returnObjects;
}

@end
