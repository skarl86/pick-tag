//
//  CategoryScrollView.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 19..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryScrollView : UIScrollView
- (void)addCategory:(NSString *)word;
- (void)addCategory:(NSString *)word withTarget:(id)theTarget action:(SEL)theAction;
- (void)deleteCategory:(UIButton *)theCategory;
- (BOOL)hasCategory:(NSString *)word;
- (BOOL)isEmpty;
- (NSArray *)selectedCategoryList;
@end
