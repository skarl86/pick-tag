//
//  NSString+Width.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 18..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Width)
+(CGSize)sizeWithString:(NSString *)theString andFont:(UIFont *)theFont;
+(CGSize)sizeWithString:(NSString *)theString;
@end
