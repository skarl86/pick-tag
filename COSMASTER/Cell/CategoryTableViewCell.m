//
//  CategoryTableViewCell.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 18..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "CategoryTableViewCell.h"

#import "NSString+Width.h"
#import "UIButton+Category.h"
#import "UIColor+Default.h"

#import "FavorCategory.h"

@interface CategoryTableViewCell ()

- (void)_createCategoryButton:(NSArray *)theWordList withTarget:(id)theTarget andSelector:(SEL)theSelector;

@end
@implementation CategoryTableViewCell

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
}

- (void)addCategories:(NSArray *)theWordList withActionTarget:(id)theTarget andSelector:(SEL)selector
{
    // Cell 을 재사용(Reuse)하기 때문에
    // 다른 IndexPath에 해당하는 Cell에서 사용했던
    // UIButton 을 없애고
    // 새롭게 다시 UIButton 을 재 배치한다.
    if([self.contentView subviews].count > 0){
        for(UIView *sub in [self.contentView subviews]){
            if([sub isKindOfClass:[UIButton class]]){
                [sub removeFromSuperview];
            }
        }
    }
    
    [self _createCategoryButton:theWordList withTarget:theTarget andSelector:selector];
    
}

- (void)_createCategoryButton:(NSArray *)theWordList withTarget:(id)theTarget andSelector:(SEL)theSelector{
    CGFloat x = 20;
    CGFloat width = 0;
    CGRect frame = CGRectZero;
    UIButton *button = nil;
    
    UIFont *font = [UIFont fontWithName:@"NanumGothic" size:20];
    
    for(FavorCategory *category in theWordList){
        width = [NSString sizeWithString:category.word andFont:font].width;
        frame = CGRectMake(x, 7, width + 5, 30);
        button = [UIButton categoryButtonWithWord:category.word
                                         andFrame:frame
                                             Font:font FontColor:[UIColor whiteColor]
                                      borderColor:[UIColor colorForTag:category.tag]
                                           Target:theTarget
                                         Selector:theSelector];

        x += 15 + width;
        
        [self.contentView addSubview:button];
    }
}
@end
