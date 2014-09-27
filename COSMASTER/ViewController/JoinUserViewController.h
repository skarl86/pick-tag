//
//  JoinUserViewController.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FullLoadingResultDelegate;

@interface JoinUserViewController : UIViewController <FullLoadingResultDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emilTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswdTextfield;
@property (weak, nonatomic) IBOutlet UILabel *warningEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningRepwLabel;

- (IBAction)join:(id)sender;
- (IBAction)close:(id)sender;
@end
