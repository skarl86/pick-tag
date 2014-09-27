//
//  UIColor+Default.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 24..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "UIColor+Default.h"

@implementation UIColor(Default)
+(UIColor *)defaultIOSColor{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}
+(UIColor *)backgroundColor{
    return [UIColor magentaColor];
}
+(UIColor *)shapeColor{
    return [UIColor darkGrayColor];
}
+(UIColor *)moodColor{
    return [UIColor defaultIOSColor];
}
+(UIColor *)feelColor{
    return [UIColor brownColor];
}
+(UIColor *)tasteColor{
    return [UIColor orangeColor];
}
+(UIColor *)colorForTag:(NSString *)theTag{
    NSDictionary *colorForTag = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor shapeColor], @"모양",
                                 [UIColor moodColor], @"분위기",
                                 [UIColor feelColor], @"질감",
                                 [UIColor tasteColor], @"미각",
                                 nil];
    return [colorForTag objectForKey:theTag];
}
@end
