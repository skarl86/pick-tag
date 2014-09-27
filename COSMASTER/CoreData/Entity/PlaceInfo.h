//
//  PlaceInfo.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 5..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaceInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * local;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pointX;
@property (nonatomic, retain) NSNumber * pointY;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * score;
@end
