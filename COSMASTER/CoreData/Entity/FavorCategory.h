//
//  FavorCategory.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 24..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavorCategory : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSNumber * characterID;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * tag;

@end
