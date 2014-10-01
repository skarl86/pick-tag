//
//  UserSelectCategoryViewController.m
//  PICK-TAG
//
//  Created by NCri on 2014. 9. 26..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "UserSelectCategoryViewController.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"

#import "FavorCategory.h"

#import "NSString+Width.h"
#import "UIColor+Default.h"
#import "UILabel+PICK-TAG.h"

#import "CategoryTableViewCell.h"
#import "PlaceInfo.h"

@interface UserSelectCategoryViewController ()
@property (strong, nonatomic) NSArray * categoryList;
@property (strong, nonatomic) NSArray * wordListForCell;
@property (strong, nonatomic) NSArray * selectedWordListForCell;
@property (strong, nonatomic) NSMutableArray * selectedWordList;
@end

@implementation UserSelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.selectedWordListForCell = [NSMutableArray new];
    
    self.navigationItem.titleView = [UILabel navigationBarTitle:self.selectedPlace.name];
    
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"NanumGothic" size:16], NSFontAttributeName,
                                  [UIColor defaultIOSColor], NSForegroundColorAttributeName,
                                  nil];

    UIBarButtonItem *favorBtnItem = self.navigationItem.rightBarButtonItem;
    [favorBtnItem setTitleTextAttributes:attributeDic
                                forState:UIControlStateNormal];
    
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    self.categoryList = [CoreDataManager entitiesWithName:@"FavorCategory" inManagedContext:ap.managedObjectContext];
    
    self.wordListForCell = [self _calcurateCategoryCountForCell:self.categoryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSArray *)_calcurateCategoryCountForCellforWillAdd:(NSArray *)categoryList {
    UIFont *font = [UIFont fontWithName:@"NanumGothic" size:20];
    CGFloat width = 0;
    
    NSMutableArray *cellForWordList = [NSMutableArray new];
    NSMutableArray *tempList = [NSMutableArray new];
    
    for (FavorCategory * category in categoryList) {
        width += [NSString sizeWithString:category.word andFont:font].width;
        if(width >= 160){
            width = 0;
            [cellForWordList addObject:tempList];
            tempList = [NSMutableArray new];
            [tempList addObject:category];
        }else{
            [tempList addObject:category];
        }
    }
    
    return cellForWordList;
}
- (NSArray *)_calcurateCategoryCountForCell:(NSArray *)categories{
    UIFont *font = [UIFont fontWithName:@"NanumGothic" size:20];
    CGFloat width = 0;
    NSInteger lineCount = 0;
    
    NSMutableArray *cellForWordList = [NSMutableArray new];
    NSMutableArray *tempList = [NSMutableArray new];
    
    for (FavorCategory * category in categories) {
        width += [NSString sizeWithString:category.word andFont:font].width;
        if(width >= 160){
            width = 0;
            [cellForWordList addObject:tempList];
            lineCount++;
            tempList = [NSMutableArray new];
            [tempList addObject:category];
        }else{
            [tempList addObject:category];
        }
    }
    // 나머지 라인의 값도 넣어준다.
    [cellForWordList addObject:tempList];
    
    return cellForWordList;

}

#pragma -
#pragma action
- (void)selectCategory:(UIButton *)theButton{
    if(nil == self.selectedWordList){
        self.selectedWordList = [NSMutableArray new];
    }
    FavorCategory * selectedFavorCategory = [CoreDataManager categoryWith:theButton.titleLabel.text];
    // 중복검사.
    NSArray *array = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.word == %@",theButton.titleLabel.text];
    array = [self.selectedWordList filteredArrayUsingPredicate:predicate];
    
    if(array == nil || [array count] == 0){
        [self.selectedWordList addObject:selectedFavorCategory];
        self.selectedWordListForCell = [self _calcurateCategoryCountForCell:self.selectedWordList];
        [self.selectedListTableView reloadData];
    }
    
}
#pragma -
#pragma uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[tableView restorationIdentifier] isEqualToString:@"typicalTableView"]){
        return [self.wordListForCell count];
    }else{
        return [self.selectedWordListForCell count];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"Cell";

    cell = (CategoryTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([[tableView restorationIdentifier] isEqualToString:@"typicalTableView"]){
        NSArray * wordList = [self.wordListForCell objectAtIndex:[indexPath row]];
        [cell addCategories:wordList withActionTarget:self andSelector:@selector(selectCategory:)];
    }else{
        NSArray * wordList = [self.selectedWordListForCell objectAtIndex:[indexPath row]];
        [cell addCategories:wordList withActionTarget:self andSelector:@selector(selectCategory:)];
    }

    return cell;
}
- (IBAction)saveUserSelectedCategory:(id)sender {
    [CoreDataManager saveUserCategories:self.selectedWordList WithPlaceName:self.selectedPlace.name];
}
@end
