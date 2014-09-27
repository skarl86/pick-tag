//
//  FavorResultTableViewCell.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 25..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavorResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@end
