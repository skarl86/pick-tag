//
//  PlaceDetailViewController.m
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 26..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "PlaceImageScrollView.h"
#import "PlaceImageDownloader.h"
#import "UserSelectCategoryViewController.h"
#import "PlaceMapViewController.h"

#import <MapKit/MapKit.h>

#import "UIColor+Default.h"
#import "UIButton+PICK-TAG.h"

// Core Data Entity
#import "PlaceInfo.h"
#import "PlaceImage.h"

#import "CoreDataManager.h"

@interface PlaceDetailViewController ()
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray * placeImages;
@property (strong, nonatomic) NSMutableDictionary * imageDownloadsInProgress;

@end

@implementation PlaceDetailViewController

-(void)startDownload:(NSArray *)downloadList
{
    for (int i=0; i<[downloadList count]; i++)   //download array have url links
    {
        NSURL *URL = [NSURL URLWithString:[downloadList objectAtIndex:i]];
        NSLog(@"IMAGE DOWNLOAD START : %@", [downloadList objectAtIndex:i]);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ( !error )
                                   {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       [self.imageScrollView insertImage:image];
                                   } else{
                                       
                                   }
                               }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    titleLabel.font = [UIFont fontWithName:@"NanumGothicBold" size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor defaultIOSColor];
    titleLabel.text = self.selectedPlace.name;
    
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *myBtnItem = self.navigationItem.leftBarButtonItem;
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"NanumGothic" size:16], NSFontAttributeName,
                                  [UIColor defaultIOSColor], NSForegroundColorAttributeName,
                                  nil];
    [myBtnItem setTitleTextAttributes:attributeDic
                             forState:UIControlStateNormal];
    UIBarButtonItem *favorBtnItem = self.navigationItem.rightBarButtonItem;
    [favorBtnItem setTitleTextAttributes:attributeDic
                                forState:UIControlStateNormal];
    
    NSString *reName = self.selectedPlace.name;
    
    // Create the predicate
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"SELF endswith %@", @"점"];
    
    // Run the predicate
    // match == YES if the predicate is successful
    BOOL match = [myPredicate evaluateWithObject:reName];
    
    // Do what you want
    if (match) {
        // do something
        NSMutableArray *strList = [NSMutableArray arrayWithArray:[reName componentsSeparatedByString:@" "]];
        // 마지막 ??점 을 빼기 위한 작업.
        [strList removeLastObject];
        reName = [strList componentsJoinedByString:@" "];
    }
    
    NSArray *imageEntities = [CoreDataManager placeImageEntitiesWithPlaceName:reName];
    
    NSMutableArray *imageUrls = [NSMutableArray new];
    
    for(PlaceImage * img in imageEntities){
        [imageUrls addObject:img.linkUrl];
    }
    // 공간을 먼저 잡고.
    [self.imageScrollView setImageCapacity:[imageUrls count]];
    // 다운로드가 완료되면 이미지를 삽입한다.
    [self startDownload:imageUrls];

    self.placeNameLabel.text = self.selectedPlace.name;
    self.localLabel.text = self.selectedPlace.local;
    self.addressLabel.text = self.selectedPlace.address;
    self.categoryLabel.text = self.selectedPlace.category;
    
    [self.showMap defaultGenerateButton];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openMap:(id)sender {
    
}
#pragma mark - 
#pragma mark - private method

#pragma mark - 
#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showUserSelect"]) {
        UserSelectCategoryViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.selectedPlace = self.selectedPlace;
    }else if([segue.identifier isEqualToString:@"showMap"]){
        UINavigationController *destinationViewController = [segue destinationViewController];
        PlaceMapViewController *mpaViewController = (PlaceMapViewController *)destinationViewController.topViewController;
        mpaViewController.selectedPlace = self.selectedPlace;
    }
}
@end
