//
//  FullLoadingViewController.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FullLoadingResultDelegate;

@interface FullLoadingViewController : UIViewController
@property (weak) id<FullLoadingResultDelegate> delegate;
- (void)startLoadingWithURL:(NSString *)theURL taskName:(NSString *)theTaskName Target:(UIViewController *)targetViewController;

@end

@protocol FullLoadingResultDelegate <NSObject>

@optional
// theError는 있을 수도 있고 없을 수도 있다.
- (void)endLoadingWithTaskName:(NSString *)theTaskName ResponseData:(NSString *)theResponse error:(NSError *)theError;

@end
