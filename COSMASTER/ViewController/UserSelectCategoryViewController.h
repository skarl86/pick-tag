//
//  UserSelectCategoryViewController.h
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 26..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceInfo;

@interface UserSelectCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *selectedListTableView;
@property (strong, nonatomic) PlaceInfo * selectedPlace;
- (IBAction)saveUserSelectedCategory:(id)sender;
@end
