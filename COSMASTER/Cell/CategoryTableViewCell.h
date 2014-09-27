//
//  CategoryTableViewCell.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 18..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
- (void)addCategories:(NSArray *)theWordList withActionTarget:(id)theTarget andSelector:(SEL)selector;
@end
