//
//  PlaceImageScrollView.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 5..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlaceImageScrollDataSource;

@interface PlaceImageScrollView : UIScrollView

@property (nonatomic, assign) id<PlaceImageScrollDataSource> datasource;

- (void) insertImage:(UIImage *)image;
- (void) setImages:(NSArray *)images;
- (void) setImageCapacity:(NSUInteger)capacity;
@end

@protocol PlaceImageScrollDataSource <NSObject>
@optional
- (void)didClickPlaceImage:(UIImage *)clickedImage;
@end
