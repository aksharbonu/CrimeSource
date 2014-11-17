//
//  SafetySpectViewController.m
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/2/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import "SafetySpectViewController.h"
#import "SafetySpectSettingsViewController.h"
#import <Parse/Parse.h>
#import "MessageUI/MessageUI.h"

@interface SafetySpectViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SafetySpectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleGesture:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 2.0;  //user must press for 2 seconds
    
    [self.mapView addGestureRecognizer:longPress];
    
    self.mapView.delegate = self;
    self.locationManager.delegate = self; 
    self.mapView.showsUserLocation = YES;
    self.crimeSpotting = [[CrimeSpotting alloc] init];
    [self.crimeSpotting getDataFromUrl:@"http://sanfrancisco.crimespotting.org/crime-data?format=json&count=1000"];
    
    self.userGenerated = [[UserGenerated alloc] init];
    [self.userGenerated getDataForParseObject: @"UserCrimeAnnotation"];
    
    self.twitter = YES;
    self.police = YES;
    self.user = YES;
    
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView: self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView: self.mapView];
    
    self.coordSubmit = touchMapCoordinate;
    [self performSegueWithIdentifier:@"submitCrime" sender:self];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (CLLocationManager*) locationManager {
    if (!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 50;
    }
    return _locationManager;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.mapView.showsUserLocation = YES;
}

- (IBAction)addUserInformation:(id)sender
{
    self.coordSubmit = self.mapView.userLocation.coordinate;
    [self performSegueWithIdentifier:@"submitCrime" sender:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.mapView removeAnnotations: self.mapView.annotations];
    
    [self.crimeSpotting getDataFromUrl:@"http://sanfrancisco.crimespotting.org/crime-data?format=json&count=1000"];
    [self.userGenerated getDataForParseObject: @"UserCrimeAnnotation"];
    
    if (self.police)
    {
        [self.mapView addAnnotations: self.crimeSpotting.items];
    }
    
    if (self.user)
    {
        [self.mapView addAnnotations: self.userGenerated.items];
    }
    
    if (self.twitter)
    {
        
    }
    else
    {
        
    }
    
}

/* TODO: GeoLocated information for the person
 
 - (IBAction)geoLocatedInformation
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate: self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Wikipedia", @"Facebook", @"Twitter", @"Emergency Contact", @"Instagram", nil];
    [actionSheet showInView:self.view];
}
 */

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString* reuseID = @"SafetySpectMap";
    MKPinAnnotationView* view = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: reuseID];
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        view.canShowCallout = YES;
        if ([annotation isKindOfClass: [CrimeSpottingItem class]])
        {
            view.pinColor = MKPinAnnotationColorRed;
        }
        else if ([annotation isKindOfClass: [UserGeneratedItem class]])
        {
            view.pinColor = MKPinAnnotationColorPurple;
        }
        if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    return view;
}
- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"moreInformation" sender: view];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnail)]) {
            // this should be done in a different thread!
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"setSettingsForMap"])
    {
        SafetySpectSettingsViewController* destination = segue.destinationViewController;
        destination.twitter = self.twitter;
        destination.police = self.police;
        destination.user = self.user; 
    }
    else if ([segue.identifier isEqualToString:@"submitCrime"])
    {
        
        SafetySpectSubmitViewController* destination = segue.destinationViewController;
        destination.coordinate = self.coordSubmit;
    }
    else if ([segue.identifier isEqualToString:@"moreInformation"])
    {
        MKAnnotationView* annotationView = sender;
        SafetySpectMoreInformationViewController* destination = segue.destinationViewController;
        destination.coordinate = annotationView.annotation.coordinate;
        destination.selectedType = annotationView.annotation.title;
        destination.subtitleText = annotationView.annotation.subtitle;
        
        if ([annotationView.annotation isKindOfClass:[CrimeSpottingItem class]])
        {
            CrimeSpottingItem *crime = annotationView.annotation;
            destination.dateTime = crime.date;
            destination.image = crime.thumbnail;
        }
        else if ([annotationView.annotation isKindOfClass:[UserGeneratedItem class]])
        {
            UserGeneratedItem *crime = annotationView.annotation;
            destination.dateTime = crime.date;
            destination.image = crime.thumbnail;
        }
    }
}

- (IBAction)setSettingsForMap:(id)sender
{
    [self performSegueWithIdentifier:@"setSettingsForMap" sender:self];
}

-(IBAction)returned:(UIStoryboardSegue *)segue
{
    SafetySpectSettingsViewController* destination = segue.sourceViewController;
    self.twitter = destination.twitter;
    self.police = destination.police;
    self.user = destination.user;
}

- (void)mapView:(MKMapView *)MapView didUpdateUserLocation:(MKUserLocation *)UserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = UserLocation.coordinate.latitude;
    location.longitude = UserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [MapView setRegion:region animated:YES];
}

- (IBAction)sendEmail:(UIButton *)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailcontroller = [[MFMailComposeViewController alloc] init];
        mailcontroller.mailComposeDelegate = self;
        NSArray *usersTo = [NSArray arrayWithObject: @"akshar.bonu@gmail.com"];
        [mailcontroller setToRecipients:usersTo];
        [mailcontroller setSubject: @"CrimeSource Feedback"];
        [self presentViewController: mailcontroller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
