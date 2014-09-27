//
//  LazyImage.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 5..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LazyImage : NSObject

@property (nonatomic, strong)   NSString *name;
@property (nonatomic, strong)   UIImage *image;
@property (nonatomic, strong)   NSString *imageURLString;
@property (nonatomic)           CGFloat width;
@property (nonatomic)           CGFloat height;


@end
