//
//  UIButton+PICK-TAG.m
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 28..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "UIButton+PICK-TAG.h"

@implementation UIButton (PICK_TAG)
- (void)defaultGenerateButton{
    [[self layer] setCornerRadius:8.0f];
    [[self layer] setMasksToBounds:YES];
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:[UIColor blackColor].CGColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
