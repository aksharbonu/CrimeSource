//
//  UserGenerated.h
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/2/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h> 
#import "UserGeneratedItem.h"

@interface UserGenerated : NSObject

@property (nonatomic, strong) NSMutableArray *items;

- (void)getDataForParseObject:(NSString *)data;

@end
