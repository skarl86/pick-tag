//
//  IntroViewController.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "IntroViewController.h"
#import "FullLoadingViewController.h"
#import "MainPlaceTableViewController.h"

#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "Member.h"

#import "NSString+Encrypt.h"
#import "UIButton+PICK-TAG.h"

#define kSecuryKey          @"TFD"
#define kTaskNameLogin      @"Login"
#define kTaskNameLoadData   @"LoadData"

@interface IntroViewController ()
@property (assign) UITextField *currentUsedTextField;
@end

@implementation IntroViewController

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
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2)];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    [self.joinButton defaultGenerateButton];
    [self.loginButton defaultGenerateButton];
    
    // 이메일 저장 을 선택한 사용자에 이메일을 미리 입력해놓는다.
    Member *member = [CoreDataManager memberSavedEmail];
    self.emailTextField.text = member.email;
    self.saveEmailSwitch.on = [member.savedEmail boolValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
#pragma button action

- (IBAction)loginUser:(id)sender {
    FullLoadingViewController *vc = [FullLoadingViewController new];
    vc.delegate = self;
    NSString *urlString = [NSString stringWithFormat:@"http://203.253.23.38:8080/COSMASTER/login.jsp?email=%@&passwd=%@", self.emailTextField.text, [self.passwdTextField.text encryptWithKey:kSecuryKey]];
    [vc startLoadingWithURL:urlString taskName:kTaskNameLogin Target:self];
}

- (IBAction)joinUser:(id)sender {
    
}

#pragma -
#pragma textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.currentUsedTextField = textField;
    [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

#pragma -
#pragma uiview touch event handler
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if(self.currentUsedTextField != nil){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.currentUsedTextField resignFirstResponder];
        self.currentUsedTextField = nil;
    }
    //Do stuff here...
}
#pragma -
#pragma full loading result delegate
- (void)endLoadingWithTaskName:(NSString *)theTaskName ResponseData:(NSString *)theResponse error:(NSError *)theError{
    if(theError != nil){
        NSLog(@"ERROR:%@",theError);
    }else{
//        NSLog(@"RESPONSE : %@",theResponse);
        if([theTaskName isEqualToString:kTaskNameLogin]){
            NSData *data = [theResponse dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSMutableDictionary *json = [NSJSONSerialization
                                         JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSInteger result = [[json objectForKey:@"result"] integerValue];
            
            if(result == 1){
                NSLog(@"LOGIN SUCCESS");
                [CoreDataManager loginUser:self.emailTextField.text];
                
                if(YES == self.saveEmailSwitch.on){
                    [CoreDataManager setMemberSavedEmailWith:self.emailTextField.text];
                }
                
                // 현재 장소 정보가 Core Data에 저장되어 있는 확인 후,
                // 없으면 서버로 부터 요청을 시작한다.
                AppDelegate *apDelegate = [[UIApplication sharedApplication] delegate];
                if(0 == [CoreDataManager entityCountWithName:@"PlaceInfo"
                                            inManagedContext:apDelegate.managedObjectContext]){
                    FullLoadingViewController *vc = [FullLoadingViewController new];
                    vc.delegate = self;
                    NSString *urlString = @"http://203.253.23.38:8080/COSMASTER/loadData2.jsp";
                    [vc startLoadingWithURL:urlString taskName:kTaskNameLoadData Target:self];
                }else{
                    [self dismissViewControllerAnimated:YES completion:^{
                        MainPlaceTableViewController * vc = (MainPlaceTableViewController *)((UINavigationController *)self.parentVC).topViewController;
                        [vc reloadData];
                    }];
                }
            }
        }else if([theTaskName isEqualToString:kTaskNameLoadData]){
            NSData *data = [theResponse dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            
            NSMutableArray *json = [NSJSONSerialization
                                    JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            //        NSLog(@"%@",json);
            
            // LoadData API 를 통해 전달 받은
            // 장소 정보와 카테고리 정보.
            NSMutableDictionary *dic = [json objectAtIndex:0];
            
            // LoadData API로 받은 JSON 데이터를
            // Dictionary로 바꿔서
            // Table View에서 사용하기 위해서 값을 넘긴다.
            
            // 서버로 부터 전달받은 JSON Data를 iPhone CoreData에 저장하여
            // 다음 뷰에서 사용할 수 있도록 준비해놓는다.
            AppDelegate *apDelegate = [[UIApplication sharedApplication] delegate];
            [CoreDataManager prepareBaseData:dic inManagedContext:apDelegate.managedObjectContext];
            [apDelegate saveContext];
            
            [self dismissViewControllerAnimated:YES completion:^{
                MainPlaceTableViewController * vc = (MainPlaceTableViewController *)((UINavigationController *)self.parentVC).topViewController;
                [vc reloadData];
            }];
        }

    }
}
@end
