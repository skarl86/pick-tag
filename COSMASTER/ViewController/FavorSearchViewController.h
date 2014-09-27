//
//  FavorSearchViewController.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 17..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FullLoadingResultDelegate;

@class CategoryScrollView;

@interface FavorSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FullLoadingResultDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *favorResultTableView;
@property (weak, nonatomic) IBOutlet CategoryScrollView *categoryScrollView;

@end
