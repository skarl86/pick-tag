//
//  FullLoadingViewController.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "FullLoadingViewController.h"

@interface FullLoadingViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *taskStack;

@end

@implementation FullLoadingViewController

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
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view setOpaque:YES];
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma interface method
- (void)startLoadingWithURL:(NSString *)theURL taskName:(NSString *)theTaskName Target:(UIViewController *)targetViewController{
    if(self.taskStack == nil)
        self.taskStack = [NSMutableArray new];
    [self.taskStack addObject:theTaskName];
    
    [targetViewController.view addSubview:self.view];
    [targetViewController.view setUserInteractionEnabled:NO];
    
    NSURL *myURL = [NSURL URLWithString:theURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_indicator setCenter:self.view.center];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview : _indicator];
    
    // ProgressBar Start
    _indicator.hidden= FALSE;
    [_indicator startAnimating];
}
#pragma -
#pragma private method

- (void)didFinishLoadingWithResponseData:(NSString *)theResponse Error:(NSError *)theError
{
    [_indicator stopAnimating];
    _indicator.hidden= TRUE;
    [self.view removeFromSuperview];
    
    // 네트워크가 종료되기 전 사용자가 이전 페이지로 이동할 경우에
    // 대한 예외처리.
    if(_delegate != nil){
        [((UIViewController *)_delegate).view setUserInteractionEnabled:YES];
        if([_delegate respondsToSelector:@selector(endLoadingWithTaskName:ResponseData:error:)]){
            [_delegate endLoadingWithTaskName:[self.taskStack lastObject] ResponseData:theResponse error:theError];
            [self.taskStack removeLastObject];
        }
    }
}
#pragma -   
#pragma connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self didFinishLoadingWithResponseData:nil Error:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[_responseData
                                                   length]);
    
    // 한국어로 인코딩
    NSString * result = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    // 유니코드로 다시 인코딩
//    NSLog(@"Response Data : %@", result);
    [self didFinishLoadingWithResponseData:result Error:nil];
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

@end
