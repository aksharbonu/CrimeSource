//
//  SafetySpectMoreInformationViewController.h
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/3/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>

@interface SafetySpectMoreInformationViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UITextView *subtitle;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString* selectedType;
@property (strong, nonatomic) NSDate* dateTime;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* subtitleText;

@end
