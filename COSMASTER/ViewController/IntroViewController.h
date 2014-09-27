//
//  IntroViewController.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullLoadingResultDelegate;

@interface IntroViewController : UIViewController<FullLoadingResultDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *saveEmailSwitch;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (assign, nonatomic) UIViewController *parentVC;

- (IBAction)loginUser:(id)sender;
- (IBAction)joinUser:(id)sender;

@end
