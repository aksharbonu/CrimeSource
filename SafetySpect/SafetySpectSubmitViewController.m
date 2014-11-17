//
//  SafetySpectSubmitViewController.m
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/3/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import "SafetySpectSubmitViewController.h"

@interface SafetySpectSubmitViewController ()

@end

@implementation SafetySpectSubmitViewController


- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (IBAction)submitCrime
{
    self.submit.text = [NSString stringWithFormat: @"Contacting Server"];
    PFObject *crime = [PFObject objectWithClassName:@"UserCrimeAnnotation"];
    if (self.data)
    {
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.data];
        [crime setObject:imageFile forKey:@"image"];
    }
    else
    {
        NSNull* null = [[NSNull alloc] init];
        [crime setObject: null forKey:@"image"];
    }
    [crime setObject: [NSNumber numberWithDouble:self.coordinate.longitude] forKey:@"longitude"];
    [crime setObject: [NSNumber numberWithDouble:self.coordinate.latitude] forKey:@"latitude"];
    [crime setObject: [NSDate date] forKey:@"date"];
    [crime setObject: @"user" forKey:@"type"];
    [crime setObject: self.subtitle.text forKey:@"subtitle"];
    [crime setObject: self.selectedType forKey:@"title"];
    [crime saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
    if (!error)
    {
        self.submit.text = [NSString stringWithFormat: @"Submission Successful"];
    }
    else
    {
        self.submit.text = [NSString stringWithFormat: @"Submission Failed"];
    }
    }];
}

- (UIImagePickerController*) mediaPicker
{
    if (!_mediaPicker)
    {
        _mediaPicker = [[UIImagePickerController alloc] init];
        _mediaPicker.delegate = self;
        _mediaPicker.allowsEditing = YES;
    }
    return _mediaPicker;
}
- (IBAction)addImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate: self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController: self.mediaPicker animated: YES completion: NULL];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController: self.mediaPicker animated: YES completion: NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.photoStatus.text = @"Photo Selected";
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [image drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    self.data = UIImageJPEGRepresentation(smallImage, 0.05f);
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selectedType = self.typeOfCrimes[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.typeOfCrimes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.typeOfCrimes[row];
}

- (BOOL)textViewShouldReturn:(UITextView *)textView {
    [textView resignFirstResponder];
    return NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.submit.text = @"";
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^ (NSArray *placemark, NSError *error)
     {
         self.address.text = @"Establishing address...";
         if (error)
         {
             self.address.text = @"Establshing address failed with error: %@";
         }
         else
         {
             CLPlacemark* placemarkObj = [placemark firstObject];
             NSArray *lines = placemarkObj.addressDictionary[ @"FormattedAddressLines"];
             NSString *incompleteString = [lines componentsJoinedByString:@"\n"];
             NSString * addressString = [NSString stringWithFormat: @"The address is %@", incompleteString];
             self.address.text = addressString;
             
         }
         
     }];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    self.date.text = [NSString stringWithFormat:@"The date is %@", dateString];
    [self.type selectRow:4 inComponent:0 animated:YES];
    self.selectedType = self.typeOfCrimes[4];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"What happened?"])
    {
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (NSArray*) typeOfCrimes
{
    if (!_typeOfCrimes)
    {
        self.typeOfCrimes = @[@"Aggravated Assault", @"Murder", @"Robbery", @"Simple Assault", @"Disturbing the Peace", @"Narcotics", @"Alcohol", @"Prostitution", @"Theft", @"Vehicle Theft", @"Vandalism", @"Burglary", @"Arson"];
    }
    return _typeOfCrimes;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.type.delegate = self; 
    self.type.dataSource = self;
}

@end
