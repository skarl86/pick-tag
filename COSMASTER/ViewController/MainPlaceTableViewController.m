//
//  MainPlaceTableViewController.m
//  COSMASTER
//
//  Created by NCri on 2014. 8. 20..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "MainPlaceTableViewController.h"
#import "MainPlaceTableViewCell.h"
#import "FullLoadingViewController.h"
#import "FavorSearchViewController.h"
#import "PlaceDetailViewController.h"

#import "AppDelegate.h"
#import "CoreDataManager.h"

#import "PlaceImageDownloader.h"

#import "UIColor+Default.h"
#import "UILabel+PICK-TAG.h"

// CoreData Entity
#import "PlaceInfo.h"

@interface MainPlaceTableViewController ()
@property (strong, nonatomic) NSArray * placeList;
// the set of PlaceImageDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSArray * categoryImageNameList;
@property (nonatomic, strong) NSArray * searchResults;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

@property NSUInteger viewedListCount;
@end

@implementation MainPlaceTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.searchResults = [NSArray new];
    
    self.navigationItem.titleView = [UILabel navigationBarTitle:@"목록"];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
    
}
#pragma mark - 
#pragma mark - private method
- (void)loadImagesForOnscreenRows
{
    if ([self.placeList count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            PlaceInfo *place = [self.placeList objectAtIndex:indexPath.row];
            
            if (!place.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:place forIndexPath:indexPath];
            }
        }
    }
}
#pragma mark -
#pragma mark - interface method
- (void)reloadData{
    // 상호 리스트를 재갱신 해준다.
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    self.placeList = [CoreDataManager entitiesWithName:@"PlaceInfo" sortKey:@"score" inManagedContext:ap.managedObjectContext];
    self.viewedListCount = 30;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell

        if(self.viewedListCount != [self.placeList count]){
            self.viewedListCount += 20;
            if((self.viewedListCount > [self.placeList count])){
                self.viewedListCount = [self.placeList count];
            }
        }
        
        [tableView reloadData];
    }
}

#pragma mark -
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return self.viewedListCount;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainPlaceCell";
    MainPlaceTableViewCell *cell = (MainPlaceTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MainPlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    PlaceInfo *place = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        place = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        place = [self.placeList objectAtIndex:indexPath.row];
    }
    
    if (!place.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:place forIndexPath:indexPath];
        }
        cell.placeImageView.image = [UIImage imageNamed:@"food.png"];//[UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        cell.placeImageView.image = [UIImage imageWithData:place.image];
    }
    
    cell.placeNameLabel.text = place.name;
    cell.locationLabel.text = place.local;
    cell.placeImageView.clipsToBounds = YES;    
    cell.placeImageView.layer.cornerRadius = 15;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetailPlace"]) {
        NSIndexPath *indexPath = nil;
        PlaceInfo *place = nil;
        PlaceDetailViewController *destinationViewController = [segue destinationViewController];
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            place = [self.searchResults objectAtIndex:indexPath.row];
            destinationViewController.selectedPlace = place;
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            place = [self.placeList objectAtIndex:indexPath.row];
            destinationViewController.selectedPlace = place;
        }
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ or local contains[c] %@", searchText, searchText];
    self.searchResults = [self.placeList filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


#pragma -
#pragma - Lazy Image Download
/*
 장소 리스트에서 현재 화면에 보여지는 이미지만 다운로드 하는 형태를 Lazy Image Download 라고 한다.
 이 작업은 불필요한 네트워크 처리와 화면간 상호작용 성능을 저하시키는 문제를 해결하기 위한 수단이다.
 */
- (void)startIconDownload:(PlaceInfo *)place forIndexPath:(NSIndexPath *)indexPath
{
    PlaceImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[PlaceImageDownloader alloc] init];
        imageDownloader.placeInfo = place;
        [imageDownloader setCompletionHandler:^{
            
            MainPlaceTableViewCell *cell = (MainPlaceTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
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

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
