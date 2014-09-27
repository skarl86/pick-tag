//
//  PlaceMapViewController.h
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 28..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceInfo, MKMapView;
@protocol CLLocationManagerDelegate;

@interface PlaceMapViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) PlaceInfo * selectedPlace;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
