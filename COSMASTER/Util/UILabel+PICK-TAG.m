//
//  UILabel.m
//  PICK-TAG
//
//  Created by NCri on 2014. 10. 1..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "UILabel+PICK-TAG.h"
#import "UIColor+Default.h"

@implementation UILabel (PickTag)
+(UILabel *)navigationBarTitle:(NSString *)theTitle{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    titleLabel.textColor = [UIColor defaultIOSColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = theTitle;
    
    return titleLabel;
}
@end
