//
//  LazyDownload.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 5..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LazyImage;

@interface LazyDownload : NSObject

@property (nonatomic, strong) LazyImage *imageInfo;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
