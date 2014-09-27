//
//  PlaceDetailViewController.h
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 26..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceInfo, PlaceImageScrollView;

@protocol CLLocationManagerDelegate;

@interface PlaceDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PlaceImageScrollView *imageScrollView;
@property (strong, nonatomic) PlaceInfo *selectedPlace;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *showMap;


@end
