//
//  CrimeSpotting.h
//  PublicSafety
//
//  Created by Buffalo Hird on 11/2/13.
//  Copyright (c) 2013 Buffalo Hird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrimeSpottingItem.h"
#import <CoreLocation/CoreLocation.h>

@interface CrimeSpotting : NSObject

@property (nonatomic, strong) NSMutableArray *items;

- (NSArray *)callURL:(NSString *)urlString;
- (NSDictionary *)handleJsonData:(NSData *)data;
- (void)getDataFromUrl:(NSString *)data;

@end
