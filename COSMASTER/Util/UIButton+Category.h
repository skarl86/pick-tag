//
//  UIButton+Category.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 19..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)
+ (UIButton *)categoryButtonWithWord:(NSString *)theWord
                                Font:(UIFont *)theFont
                            andFrame:(CGRect)theFrame
                         borderColor:(UIColor *)theBorderColor
                              Target:(id)theTarget Selector:(SEL)theSelector;
+ (UIButton *)categoryButtonWithWord:(NSString *)theWord
                            andFrame:(CGRect)theFrame
                              Target:(id)theTarget Selector:(SEL)theSelector;

+ (UIButton *)categoryButtonWithWord:(NSString *)theWord
                            andFrame:(CGRect)theFrame
                         borderColor:(UIColor *)theBorderColor
                              Target:(id)theTarget Selector:(SEL)theSelector;
+ (UIButton *)categoryButtonWithWord:(NSString *)theWord
                            andFrame:(CGRect)theFrame
                                Font:(UIFont *)theFont
                           FontColor:(UIColor *)theFontColor
                         borderColor:(UIColor *)theBorderColor
                              Target:(id)theTarget
                            Selector:(SEL)theSelector;

@end
