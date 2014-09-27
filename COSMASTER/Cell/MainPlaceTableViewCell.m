//
//  MainPlaceTableViewCell.m
//  COSMASTER
//
//  Created by NCri on 2014. 8. 20..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "MainPlaceTableViewCell.h"

@implementation MainPlaceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    NSLog(@"SELECTEDDDDD");
}

@end
