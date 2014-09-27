//
//  MainPlaceTableViewCell.h
//  COSMASTER
//
//  Created by NCri on 2014. 8. 20..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPlaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
