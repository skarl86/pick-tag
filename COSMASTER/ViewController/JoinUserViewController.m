//
//  JoinUserViewController.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "JoinUserViewController.h"
#import "FullLoadingViewController.h"

#import "NSString+Encrypt.h"
#import "UILabel+PICK-TAG.h"

#define kSecuryKey  @"TFD"

@interface JoinUserViewController ()

@end

@implementation JoinUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [UILabel navigationBarTitle:@"회원가입"];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"NanumGothic" size:16], NSFontAttributeName,
                                                          [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0], NSForegroundColorAttributeName,
                                                          nil]
                                                forState:UIControlStateNormal];
    
    [self.emilTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma -
#pragma action method
- (IBAction)join:(id)sender {
    if([self isValidate]){
        FullLoadingViewController *vc = [FullLoadingViewController new];
        vc.delegate = self;
        NSString *url = [NSString stringWithFormat:@"http://203.253.23.38:8080/COSMASTER/join.jsp?email=%@&passwd=%@",self.emilTextField.text, [self.passwdTextField.text encryptWithKey:kSecuryKey]];
        [vc startLoadingWithURL:url taskName:@"" Target:self];
    }else{
        NSLog(@"INPUT WRONG");
        self.warningRepwLabel.text = @"비밀번호가 일치하지 않습니다.";
    }

}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -
#pragma private method
- (BOOL)isValidate{
    if((self.emilTextField.text.length > 0 && self.passwdTextField.text.length > 0)
       && ([self.passwdTextField.text isEqualToString:self.rePasswdTextfield.text]))
        return YES;
    return NO;
}

#pragma -
#pragma full loading delegate
- (void)endLoadingWithTaskName:(NSString *)theTaskName ResponseData:(NSString *)theResponse error:(NSError *)theError{
    if(theError != nil){
        NSLog(@"ERROR:%@",theError);
    }else{
        NSLog(@"RESPONSE : %@",theResponse);
        NSData *data = [theResponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *json = [NSJSONSerialization
                                           JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSInteger isDuplicated = [[json objectForKey:@"duplicated"] integerValue];
        NSInteger result = [[json objectForKey:@"result"] integerValue];
        if(isDuplicated == 0 && result == 1){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if(isDuplicated == 1 && result == 0){
            self.warningEmailLabel.text = @"이미 등록 된 Email 주소 입니다.";
        }
    }
}
#pragma -
#pragma textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}
@end
