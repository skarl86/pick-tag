//
//  CategoryScrollView.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 19..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "CategoryScrollView.h"

#import "UIButton+Category.h"
#import "UIColor+Default.h"
#import "NSString+Width.h"

#import "CoreDataManager.h"
#import "AppDelegate.h"

#define kCategoryButtonStartPointX 5
#define kCategoryButtonGap 10
#define kCategoryScrollContentSizeGap 20
#define kMaxCategoryTagCount    3
@interface CategoryScrollView ()

@property (strong, nonatomic) NSMutableArray * selectedList;
@property (strong, nonatomic) UILabel *notifyLabel;
- (CGFloat)_calcurateWidth;
- (BOOL)_isDuplicateCategory:(NSString *)theCategoryWord;
@end

@implementation CategoryScrollView
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        label.text = @"취향을 선택해 주세요.";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.alpha = 0.4;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont fontWithName:@"NanumGothic" size:19];
        self.notifyLabel = label;
        [self addSubview:label];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
#pragma -
#pragma interface method
- (BOOL)isEmpty{
    if(self.selectedList.count > 0)
        return NO;
    return YES;
}
- (BOOL)hasCategory:(NSString *)word{
    for(UIButton *selected in self.selectedList){
        if([selected.titleLabel.text isEqualToString:word]){
            return YES;
        }
    }
    return NO;
}
- (NSArray *)selectedCategoryList{
    NSMutableArray * wordList = [NSMutableArray new];
    
    for(UIButton * categoryBtn in self.selectedList){
        [wordList addObject:[categoryBtn titleLabel].text];
    }
    
    return wordList;
    
}
- (void)addCategory:(NSString *)word withTarget:(id)theTarget action:(SEL)theAction{
    if(self.selectedList == nil)
        self.selectedList = [NSMutableArray new];
    
    // 중복 카테고리는 허용하지 않는다.
    if((![self _isDuplicateCategory:word]) && [self.selectedList count] < kMaxCategoryTagCount){
        self.notifyLabel.hidden = YES;
        AppDelegate *ap = [[UIApplication sharedApplication] delegate];
        NSString *tag = [CoreDataManager categoryTagForWord:word inManagedContext:ap.managedObjectContext];
        
        UIButton *categoryBtn = [UIButton categoryButtonWithWord:word
                                                        andFrame:CGRectZero//CGRectMake(0, (80/2) - (44/2), 0, 44)
                                                            Font:[UIFont fontWithName:@"NanumGothicExtraBold" size:20]
                                                       FontColor:[UIColor whiteColor]
                                                     borderColor:[UIColor colorForTag:tag]
                                                          Target:theTarget
                                                        Selector:theAction];
        [self.selectedList addObject:categoryBtn];
        [self addSubview:categoryBtn];
        // 최종적으로 relocationCategoryButton에서 Button 사이즈 및 위치가 결정된다.
        [self relocationCategoryButton];
        
        CGFloat currentWidth = [self _calcurateWidth];
        if( currentWidth > 320){
            [self setContentSize:CGSizeMake(currentWidth + kCategoryScrollContentSizeGap, self.frame.size.height)];
        }
    }
}
- (void)addCategory:(NSString *)word{
    [self addCategory:word withTarget:self action:@selector(deleteCategory:)];
}
/*
- (void)addCategory:(NSString *)word{
    if(self.selectedList == nil)
        self.selectedList = [NSMutableArray new];
    
    // 중복 카테고리는 허용하지 않는다.
    if(![self _isDuplicateCategory:word]){
        NSInteger lastIndex = [self.selectedList indexOfObject:[self.selectedList lastObject]];
        CGFloat x;
        if(lastIndex == NSNotFound){
            x = kCategoryButtonStartPointX;
        }else{
            CGFloat lastX = ((UIButton *)[self.selectedList lastObject]).frame.origin.x;
            CGFloat lastWidth = ((UIButton *)[self.selectedList lastObject]).frame.size.width;
            
            x += lastX + lastWidth + kCategoryButtonGap;
        }
        
        CGFloat width = [NSString sizeWithString:word].width;
        UIButton *categoryBtn = [UIButton categoryButtonWithWord:word
                                                            Font:[UIFont fontWithName:@"NanumGothicExtraBold" size:14]
                                                        andFrame:CGRectMake(x, 7, width + 5, 30)
                                                     borderColor:[UIColor redColor]
                                                          Target:self
                                                        Selector:@selector(_deleteCategory:)];
        [self.selectedList addObject:categoryBtn];
        [self addSubview:categoryBtn];
        
        CGFloat currentWidth = [self _calcurateWidth];
        if( currentWidth > 320){
            [self setContentSize:CGSizeMake(currentWidth + kCategoryScrollContentSizeGap, self.frame.size.height)];
        }
    }
}
 */
#pragma -
#pragma action method
- (void)deleteCategory:(UIButton *)theCategory{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.6f];
    [self.selectedList removeObject:theCategory];
    [theCategory removeFromSuperview];
    [self relocationCategoryButton];
    if(0 == [self.selectedList count]){
        self.notifyLabel.hidden = NO;
    }
    [UIView commitAnimations];

}
#pragma -
#pragma private method
- (CGFloat)relocationCategoryButton{
    CGFloat x = kCategoryButtonStartPointX;
    CGFloat width = ((self.frame.size.width - 20) / (self.selectedList.count));
    CGFloat height = 44;
    for(int i = 0; i < self.selectedList.count; i++){
        UIButton *selectedBtn = [self.selectedList objectAtIndex:i];
        selectedBtn.frame = CGRectMake(x, (80/2) - (44/2), width, height);
        x += width;
    }
    return x;
}
/*
- (void)_relocationCategoryButton{
    CGFloat x = kCategoryButtonStartPointX;
    CGRect orgFrame = CGRectZero;
    
    for(UIButton *categoryBtn in self.selectedList){
        orgFrame = categoryBtn.frame;
        categoryBtn.frame = CGRectMake(x, orgFrame.origin.y, orgFrame.size.width, orgFrame.size.height);
        x += orgFrame.size.width + kCategoryButtonGap;
    }
}*/
- (CGFloat)_calcurateWidth{
    CGFloat width = 0;
    if(self.selectedList != nil){
        CGRect firstCategoryFrame = ((UIButton *)[self.selectedList objectAtIndex:0]).frame;
        CGRect lastCategoryFrame = ((UIButton *)[self.selectedList lastObject]).frame;
        
        width = (lastCategoryFrame.origin.x + lastCategoryFrame.size.width) - firstCategoryFrame.origin.x;
    }
    return width;
}
- (BOOL)_isDuplicateCategory:(NSString *)theCategoryWord{
    if(self.selectedList == nil)
        return NO;
    for(UIButton *btn in self.selectedList)
        if([theCategoryWord isEqualToString:btn.titleLabel.text])
            return YES;
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
