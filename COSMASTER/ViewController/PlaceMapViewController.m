//
//  PlaceMapViewController.m
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 28..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "PlaceMapViewController.h"

#import "UIColor+Default.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKUserLocation.h>
#import <CoreLocation/CLLocation.h>
#import "PlaceInfo.h"

#define kMeterPerMile 0.001f
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue])
@interface PlaceMapViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation PlaceMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor defaultIOSColor];
    titleLabel.text = self.selectedPlace.name;
    
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *myBtnItem = self.navigationItem.leftBarButtonItem;
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"NanumGothic" size:16], NSFontAttributeName,
                                  [UIColor defaultIOSColor], NSForegroundColorAttributeName,
                                  nil];
    [myBtnItem setTitleTextAttributes:attributeDic
                             forState:UIControlStateNormal];
    UIBarButtonItem *favorBtnItem = self.navigationItem.rightBarButtonItem;
    [favorBtnItem setTitleTextAttributes:attributeDic
                                forState:UIControlStateNormal];

    _locationManager = [[CLLocationManager alloc] init];
    
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [_mapView setShowsUserLocation:NO];
        [_locationManager setDelegate:self];
        [_locationManager requestWhenInUseAuthorization];
    }
    else{
        //Before iOS 8
        [_mapView setShowsUserLocation:YES];
    }
    // Do any additional setup after loading the view.
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    double latitude = [self.selectedPlace.pointY doubleValue];
    double longitude =[self.selectedPlace.pointX doubleValue];
    
    region.center = CLLocationCoordinate2DMake(longitude, latitude);
    region.span = span;
    
    [_mapView setRegion:region animated:YES];
    [_mapView setCenterCoordinate:region.center animated:YES];
    [_mapView regionThatFits:region];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = region.center;
    point.title = self.selectedPlace.name;
    point.subtitle = self.selectedPlace.address;
//    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        // permission denied
        [_mapView setShowsUserLocation:NO];
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // permission granted
        [_mapView setShowsUserLocation:YES];
    }
}
#pragma mark -
#pragma mark - action
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showMyLocation:(id)sender {
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

@end
