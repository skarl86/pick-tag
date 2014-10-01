//
//  FavorSearchViewController.m
//  COSMASTER
//
//  Created by NCri on 2014. 9. 17..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "FavorSearchViewController.h"

#import "FullLoadingViewController.h"

#import "CategoryTableViewCell.h"
#import "FavorResultTableViewCell.h"
#import "PlaceDetailViewController.h"
#import "CategoryScrollView.h"

#import "AppDelegate.h"
#import "CoreDataManager.h"

// Core Data Entity;
#import "FavorCategory.h"
#import "PlaceInfo.h"

#import "NSString+Width.h"
#import "UIColor+Default.h"
#import "UILabel+PICK-TAG.h"

#import "PlaceImageDownloader.h"

#define kCategoryTableMovedFrame                    CGRectMake(0, 66, 320, 174)
#define kCategoryTableViewRestorationIdentifier     @"CategoryTable"
#define kFavorTableViewRestorationIdentifier        @"FavorResultTable"
#define kCategoryMultipleRequestDelimiter           @","
@interface FavorSearchViewController ()

@property (assign) NSInteger categoryCount;
@property (strong, nonatomic) NSArray * wordListForCell;
@property (strong, nonatomic) NSArray * categoryList;
@property (strong, nonatomic) NSMutableArray * favorPlaceList;
@property (strong, nonatomic) NSMutableDictionary * scoreInfo;


@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)_calcurateCategoryCountForCell:(NSArray *)wordList;
- (void)_selectCategory:(UIButton *)theCategoryButton;
- (void)startIconDownload:(PlaceInfo *)place forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation FavorSearchViewController

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
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont fontWithName:@"NanumGothic" size:15.0f]];
    [label setText:@"검색 결과가 없습니다."];
    [label sizeToFit];
    label.frame = CGRectMake((self.favorResultTableView.bounds.size.width - label.bounds.size.width) / 2.0f,
                             (self.favorResultTableView.rowHeight - label.bounds.size.height) / 2.0f,
                             label.bounds.size.width,
                             label.bounds.size.height);
    [self.favorResultTableView insertSubview:label atIndex:0];
    
    self.favorPlaceList = [NSMutableArray new];
    self.scoreInfo = [NSMutableDictionary new];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.navigationItem.titleView = [UILabel navigationBarTitle:@"맞춤 검색"];
    
    self.tableView.separatorColor = [UIColor clearColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont fontWithName:@"NanumGothic" size:16], NSFontAttributeName,
                                       [UIColor defaultIOSColor], NSForegroundColorAttributeName,
                                       nil]
                             forState:UIControlStateNormal];
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    self.categoryList = [CoreDataManager entitiesWithName:@"FavorCategory" sortKey:@"totalCount" inManagedContext:ap.managedObjectContext];

    [self _calcurateCategoryCountForCell:self.categoryList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDetailPlace"]) {
        NSIndexPath *indexPath = nil;
        PlaceInfo *place = nil;
        PlaceDetailViewController *destinationViewController = [segue destinationViewController];
        indexPath = [self.favorResultTableView indexPathForSelectedRow];
        place = [self.favorPlaceList objectAtIndex:indexPath.row];
        destinationViewController.selectedPlace = place;
    }
}

#pragma -
#pragma action method
- (void)deleteCategory:(UIButton *)theCategory{
    [self.categoryScrollView deleteCategory:theCategory];
    if([self.categoryScrollView isEmpty])
    {
        [self.favorPlaceList removeAllObjects];
        [self.favorResultTableView reloadData];
    }
    [self _requestFavorListWithWords:[self.categoryScrollView selectedCategoryList]];
}
#pragma -
#pragma private method
- (void)_requestFavorListWithWords:(NSArray *)selectedWords{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    NSMutableArray *favorIDList = [NSMutableArray new];
    for(NSString *word in selectedWords){
        [favorIDList addObject:[NSString stringWithFormat:@"%d",[CoreDataManager categoryIDForWord:word inManagedContext:ap.managedObjectContext]]];
    }
    
    NSString *param = [favorIDList componentsJoinedByString:kCategoryMultipleRequestDelimiter];
    FullLoadingViewController *vc = [FullLoadingViewController new];
    vc.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"http://203.253.23.38:8080/COSMASTER/favorList2.jsp?id=%@",param];
    NSString *encodeUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [vc startLoadingWithURL:encodeUrl taskName:@"" Target:self];
}
- (void)_calcurateCategoryCountForCell:(NSArray *)categoryList{
    UIFont *font = [UIFont fontWithName:@"NanumGothic" size:20];
    CGFloat width = 0;
    
    NSMutableArray *cellForWordList = [NSMutableArray new];
    NSMutableArray *tempList = [NSMutableArray new];
    
    for (FavorCategory * category in categoryList) {
        width += [NSString sizeWithString:category.word andFont:font].width;
        if(width >= 160){
            width = 0;
            [tempList addObject:category];
            [cellForWordList addObject:tempList];
            tempList = [NSMutableArray new];
        }else{
            [tempList addObject:category];
        }
    }
    
    self.wordListForCell = cellForWordList;
}
- (void)_selectCategory:(UIButton *)theCategoryButton{
    NSLog(@"%@", theCategoryButton.titleLabel.text);
    if(![self.categoryScrollView hasCategory:theCategoryButton.titleLabel.text]){
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             // any other stuff you have to move
                             [self.categoryScrollView addCategory:theCategoryButton.titleLabel.text withTarget:self action:@selector(deleteCategory:)];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             [self _requestFavorListWithWords:[self.categoryScrollView selectedCategoryList]];
                         }
         ];
    }
}
- (void)loadImagesForOnscreenRows
{
    if ([self.favorPlaceList count] > 0)
    {
        NSArray *visiblePaths = [self.favorResultTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            PlaceInfo *place = [self.favorPlaceList objectAtIndex:indexPath.row];
            
            if (!place.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:place forIndexPath:indexPath];
            }
        }
    }
}

#pragma -
#pragma full loading delegate
- (void)endLoadingWithTaskName:(NSString *)theTaskName ResponseData:(NSString *)theResponse error:(NSError *)theError{
    NSLog(@"RESPONSE DATA\n%@",theResponse);
    NSData *data = [theResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSMutableArray *json = [NSJSONSerialization
                                         JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *resultList = [json objectAtIndex:0];
    
//    double blogParsingPerPlaceAvg = [[resultDic objectForKey:@"blog_parsing_per_place_avg"] doubleValue];
//    int placeBlogCount = 0;
    
    NSMutableDictionary *placeDic = [NSMutableDictionary new];
    
    for(NSDictionary * obj in resultList){
        double score = [[obj objectForKey:@"count"] doubleValue];
//        placeBlogCount = [[obj objectForKey:@"place_blog_count"] intValue];
        // 가중치 적용하여 점수를 계산.
        // 블로그의 갯수가 적은 것은 점수가 높아지고 블로그의 갯수가 많은 것은 점수가 평균값을 찾아가기 때문에.
//        double weightScore = (((double)placeBlogCount / blogParsingPerPlaceAvg) * 0.2) * score;
        [placeDic setObject:[NSNumber numberWithDouble:score] forKey:[obj objectForKey:@"place_name"]];
    }
    

    NSArray *orderedPlaceNameList = [placeDic keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }}];
    
    self.scoreInfo = placeDic;
    
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    // 새로운 데이터를 넣기 위해서 기존의 데이터를 지운다.
    [self.favorPlaceList removeAllObjects];
    
    for (NSString *name in orderedPlaceNameList) {
        PlaceInfo *place = (PlaceInfo *)[CoreDataManager placeInfoEntityWith:name inManagedContext:ap.managedObjectContext];
        place.name = name;
        [self.favorPlaceList addObject:place];
        NSLog(@"장소 : %@ 점수 : %@",name,[placeDic valueForKey:name]);
    }

    [self.favorResultTableView reloadData];
}

#pragma -
#pragma - Lazy Image Download
- (void)startIconDownload:(PlaceInfo *)place forIndexPath:(NSIndexPath *)indexPath
{
    PlaceImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[PlaceImageDownloader alloc] init];
        imageDownloader.placeInfo = place;
        [imageDownloader setCompletionHandler:^{
            
            FavorResultTableViewCell *cell = (FavorResultTableViewCell *)[self.favorResultTableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.placeImageView.image = [UIImage imageWithData:place.image];
            
            // Remove the PlaceImageDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
#pragma -
#pragma uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rowCount = 0;
    if([[tableView restorationIdentifier] isEqualToString:kCategoryTableViewRestorationIdentifier]){
        rowCount = [self.wordListForCell count];
    }else if([[tableView restorationIdentifier] isEqualToString:kFavorTableViewRestorationIdentifier]){
        rowCount = [self.favorPlaceList count];
    }
    return rowCount;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if([[tableView restorationIdentifier] isEqualToString:kCategoryTableViewRestorationIdentifier]){
        height = 44;
    }else if([[tableView restorationIdentifier] isEqualToString:kFavorTableViewRestorationIdentifier]){
        height = 108;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if([[tableView restorationIdentifier] isEqualToString:kCategoryTableViewRestorationIdentifier]){
        static NSString *CellIdentifier = @"Cell";
        cell = (CategoryTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
    }else if([[tableView restorationIdentifier] isEqualToString:kFavorTableViewRestorationIdentifier]){
        static NSString *CellIdentifier2 = @"FavorResultCell";
        cell = (FavorResultTableViewCell *)[self.favorResultTableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[FavorResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if([cell isKindOfClass:[CategoryTableViewCell class]]){
        CategoryTableViewCell *theCell = (CategoryTableViewCell *)cell;
        NSArray * wordList = [self.wordListForCell objectAtIndex:[indexPath row]];
        
        [theCell addCategories:wordList withActionTarget:self andSelector:@selector(_selectCategory:)];
    }else if([cell isKindOfClass:[FavorResultTableViewCell class]]){
        FavorResultTableViewCell *theCell = (FavorResultTableViewCell *)cell;
        PlaceInfo *place = [self.favorPlaceList objectAtIndex:[indexPath row]];

        theCell.placeNameLabel.text = place.name;
        theCell.placeLocationLabel.text = place.local;
        double score = [[self.scoreInfo objectForKey:place.name] doubleValue];
//        score *= 100;
        theCell.scoreLabel.text = [NSString stringWithFormat:@"%d",(int)score];
        
        if (!place.image)
        {
            if (self.favorResultTableView.dragging == NO && self.favorResultTableView.decelerating == NO)
            {
                [self startIconDownload:place forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            theCell.placeImageView.image = [UIImage imageNamed:@"food.png"];
        }
        else
        {
            theCell.placeImageView.image = [UIImage imageWithData:place.image];
        }
        theCell.placeImageView.clipsToBounds = YES;
        
        theCell.placeImageView.layer.cornerRadius = 15;
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[tableView restorationIdentifier] isEqualToString:kCategoryTableViewRestorationIdentifier]){
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
            // This is the last cell
            [tableView reloadData];
        }
    }else if([[tableView restorationIdentifier] isEqualToString:kFavorTableViewRestorationIdentifier]){
        
    }

}
@end
