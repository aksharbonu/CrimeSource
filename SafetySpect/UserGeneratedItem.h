//
//  UserGeneratedItem.h
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/2/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface UserGeneratedItem : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;

@property (nonatomic) int itemId;

@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) UIImage *image;

-(void)initFromParseObject:(PFObject *) parseObject;
-(CLLocationCoordinate2D)coordinate;
- (UIImage *)thumbnail; 
@end
