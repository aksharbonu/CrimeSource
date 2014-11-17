//
//  SafetySpectMoreInformationViewController.m
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/3/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import "SafetySpectMoreInformationViewController.h"

@interface SafetySpectMoreInformationViewController ()

@end

@implementation SafetySpectMoreInformationViewController

- (IBAction)shareOnSocial
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate: self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Twitter", @"Facebook", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText: [NSString stringWithFormat: @"Type: %@\n%@\n%@\n%@", self.title, self.date.text, self.address.text, self.subtitle.text]];
            [tweetSheet addImage: self.image];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    } else if (buttonIndex == 1)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [controller setInitialText: [NSString stringWithFormat: @"Type: %@\n%@\n%@\n%@", self.title, self.date.text, self.address.text, self.subtitle.text]];
            [controller addImage: self.image];
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = self.selectedType;
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
             NSString * addressString = [NSString stringWithFormat: @"Address:\n%@", incompleteString];
             self.address.text = addressString;
             
         }
         
     }];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate: self.dateTime];
    self.date.text = [NSString stringWithFormat:@"Date: %@", dateString];
    self.subtitle.text = [NSString stringWithFormat:@"Description:\n%@", self.subtitleText];
    [self.imageView setImage: self.image];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    [self.imageView setImage:nil]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
