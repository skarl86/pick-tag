//
//  UIButton+Category.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 19..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)
+ (UIButton *)categoryButtonWithWord:(NSString *)theWord
                            andFrame:(CGRect)theFrame
                                Font:(UIFont *)theFont
                           FontColor:(UIColor *)theFontColor
                         borderColor:(UIColor *)theBorderColor
                              Target:(id)theTarget
                            Selector:(SEL)theSelector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:theFrame];
    [button addTarget:theTarget action:theSelector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:theWord forState:UIControlStateNormal];
    [button setTitleColor:theFontColor forState:UIControlStateNormal];
    [button setBackgroundColor:theBorderColor];
    button.titleLabel.font = theFont;
    [[button layer] setCornerRadius:8.0f];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:theBorderColor.CGColor];
    
    return button;
}
+ (UIButton *)categoryButtonWithWord:(NSString *)theWord Font:(UIFont *)theFont andFrame:(CGRect)theFrame borderColor:(UIColor *)theBorderColor Target:(id)theTarget Selector:(SEL)theSelector{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:theFrame];
    [button addTarget:theTarget action:theSelector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:theWord forState:UIControlStateNormal];
    button.titleLabel.font = theFont;
    [[button layer] setCornerRadius:8.0f];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:theBorderColor.CGColor];
    
    return button;
}
+ (UIButton *)categoryButtonWithWord:(NSString *)theWord andFrame:(CGRect)theFrame borderColor:(UIColor *)theBorderColor Target:(id)theTarget Selector:(SEL)theSelector{
    
    return [UIButton categoryButtonWithWord:theWord
                                       Font:[UIFont fontWithName:@"NanumGothic" size:14]
                                   andFrame:theFrame
                                borderColor:theBorderColor
                                     Target:theTarget Selector:theSelector];
}

+ (UIButton *)categoryButtonWithWord:(NSString *)theWord andFrame:(CGRect)theFrame Target:(id)theTarget Selector:(SEL)theSelector{
    return [UIButton categoryButtonWithWord:theWord
                            andFrame:theFrame
                         borderColor:[UIColor blueColor]
                              Target:theTarget
                            Selector:theSelector];
}
@end
