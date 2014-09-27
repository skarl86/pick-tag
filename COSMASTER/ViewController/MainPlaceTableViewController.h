//
//  MainPlaceTableViewController.h
//  COSMASTER
//
//  Created by NCri on 2014. 8. 20..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullLoadingResultDelegate;

@interface MainPlaceTableViewController : UITableViewController<FullLoadingResultDelegate>
- (void)reloadData;
@end
