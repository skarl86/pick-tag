//
//  UserChoiceCategory.h
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 28..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserChoiceCategory : NSManagedObject

@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSArray * selectedCategories;
@property (nonatomic, retain) NSDate * date;

@end
