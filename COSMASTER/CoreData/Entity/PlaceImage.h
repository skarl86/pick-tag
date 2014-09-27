//
//  PlaceImage.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 5..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PlaceImage : NSManagedObject

@property (nonatomic, retain) NSString * linkUrl;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * placeName;

@end
