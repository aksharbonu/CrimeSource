//
//  CrimeSpotting.m
//  PublicSafety
//
//  Created by Buffalo Hird on 11/2/13.
//  Copyright (c) 2013 Buffalo Hird. All rights reserved.
//

//self.crimeSpotting = [[CrimeSpotting alloc] init];
//[self.crimeSpotting getDataFromUrl:@"http://sanfrancisco.crimespotting.org/crime-data?format=json&count=10"];
//self.CrimeSpotting.items

#import "CrimeSpotting.h"

@implementation CrimeSpotting



- (NSArray *)callURL:(NSString *)urlString
{
    NSArray *returnArray;
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data) {
        returnArray = [self handleJsonData:data][@"features"];
        //NSLog(returnDictionary);
    }
    else {
        //NSLog(@"error loading data: %@", urlString);
        returnArray = [[NSArray alloc] init];
    }
    
    return returnArray;
}

- (NSDictionary *)handleJsonData:(NSData *)data
{
    
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    //NSLog([NSString stringWithFormat:@"%@", jsonDictionary]);
    return jsonDictionary;
}

- (void)getDataFromUrl:(NSString *)data
{
    //NSLog(data);
    NSArray *returnData = [self callURL:data];
    NSMutableArray *returnObjects = [[NSMutableArray alloc] init];
    for (id element in returnData){
        CrimeSpottingItem *newItem = [[CrimeSpottingItem alloc] init];
        [newItem initFromDictionary:element];
        [returnObjects addObject:newItem];
        //do something else
    }
    self.items = returnObjects;
    //NSLog([NSString stringWithFormat:@"%@",returnData]);
    
}

@end
