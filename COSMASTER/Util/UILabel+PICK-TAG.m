//
//  UILabel.m
//  PICK-TAG
//
//  Created by NCri on 2014. 10. 1..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "UILabel+PICK-TAG.h"
#import "UIColor+Default.h"

#define kCategoryFrame          CGRectMake(0,0,50,50)
#define kNavigationTitleFrame   CGRectMake(0, 0, 100, 60)

@implementation UILabel (PickTag)
+(UILabel *)navigationBarTitle:(NSString *)theTitle{
    UIFont * font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    return [UILabel _generateLabelWithText:theTitle
                                      font:font
                                 textColor:[UIColor defaultIOSColor]
                                  AndFrame:kNavigationTitleFrame];
}
+(UILabel *)tasteCategory{
    UIFont * font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    return [UILabel _generateLabelWithText:@"맛"
                                      font:font
                                 textColor:[UIColor tasteColor]
                                  AndFrame:kCategoryFrame];
}
+(UILabel *)feelCategory{
    UIFont * font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    return [UILabel _generateLabelWithText:@"느낌"
                                      font:font
                                 textColor:[UIColor feelColor]
                                  AndFrame:kCategoryFrame];
}
+(UILabel *)moodCategory{
    UIFont * font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    return [UILabel _generateLabelWithText:@"분위기"
                                      font:font
                                 textColor:[UIColor moodColor]
                                  AndFrame:kCategoryFrame];
}
+(UILabel *)shapeCategory{
    UIFont * font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    return [UILabel _generateLabelWithText:@"모양"
                                      font:font
                                 textColor:[UIColor shapeColor]
                                  AndFrame:kCategoryFrame];
}

+(UILabel *)_generateLabelWithText:(NSString *)theText
                            font:(UIFont *)theFont
                       textColor:(UIColor *)theTextColor
                        AndFrame:(CGRect)theFrame{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:theFrame];
    newLabel.font = theFont;
    newLabel.textColor = theTextColor;
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.text = theText;
    [newLabel sizeToFit];
    
    return newLabel;
    
}
@end
