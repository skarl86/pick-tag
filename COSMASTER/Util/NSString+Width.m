//
//  NSString+Width.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 18..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "NSString+Width.h"

@implementation NSString (Width)
+(CGSize)sizeWithString:(NSString *)theString andFont:(UIFont *)theFont{
    NSDictionary *userAttributes = @{NSFontAttributeName: theFont,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    return [theString sizeWithAttributes: userAttributes];
}
+(CGSize)sizeWithString:(NSString *)theString{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:18];
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    return [theString sizeWithAttributes: userAttributes];
}
@end
