//
//  SafetySpectSubmitViewController.h
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/3/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface SafetySpectSubmitViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString* selectedType;
@property (weak, nonatomic) IBOutlet UIPickerView *type;
@property (strong, nonatomic) NSArray* typeOfCrimes;
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UILabel *submit;
@property (weak, nonatomic) IBOutlet UITextView *subtitle;
@property (strong, nonatomic) UIImagePickerController* mediaPicker; 
@property (weak, nonatomic) IBOutlet UILabel *photoStatus;
@property (strong, nonatomic) NSData *data;

@end
