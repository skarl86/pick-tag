//
//  CategoryInfoView.m
//  PICK-TAG
//
//  Created by NCri on 2014. 10. 1..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "CategoryInfoView.h"

#import "UILabel+PICK-TAG.h"

#define kGap 10
@interface CategoryInfoView ()
- (void)remakeSubviewFrame:(NSArray *)subviews;
@end

@implementation CategoryInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        UILabel *tasteLabel = [UILabel tasteCategory];
        UILabel *feelLabel = [UILabel feelCategory];
        UILabel *shapeLabel = [UILabel shapeCategory];
        UILabel *moodLabel = [UILabel moodCategory];
        
        [self addSubview:tasteLabel];
        [self addSubview:feelLabel];
        [self addSubview:shapeLabel];
        [self addSubview:moodLabel];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self remakeSubviewFrame:self.subviews];
    }
    
    return self;
}
- (void)remakeSubviewFrame:(NSArray *)subviews{
    float x = 80;
    float y = 0;
    float width = 0;
    float totalWidth = 0;
    UILabel *label = [subviews objectAtIndex:0];
    CGRect newFrame = CGRectZero;
    
    y = ([self frame].size.height / 2) - (label.frame.size.height/2);
    
    for (int i = 0; i < subviews.count; i++) {
        x += width;
        label = [subviews objectAtIndex:i];
        width = label.frame.size.width + kGap;
        totalWidth += width;
        newFrame = label.frame;
        newFrame.origin.x = x;
        newFrame.origin.y = y;
        label.frame = newFrame;
    }
}
@end
