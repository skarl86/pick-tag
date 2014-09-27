//
//  CoreDataManager.m
//  COSMASTER
//
//  Created by NCri on 2014. 8. 27..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import "CoreDataManager.h"
#import "PlaceInfo.h"
#import "PlaceImage.h"
#import "Member.h"
#import "FavorCategory.h"
#import "UserChoiceCategory.h"

#import "AppDelegate.h"

#define kPlaceListKey @"placeList"
#define kImageListKey @"imageList"
#define kFavorCategoryListKey @"categoryList"

@implementation CoreDataManager
#pragma -
#pragma - get base Data
+(void)prepareBaseData:(NSDictionary *)theDictionary inManagedContext:(NSManagedObjectContext *)theContext{
    NSArray *placeList = [theDictionary objectForKey:kPlaceListKey];
    [CoreDataManager inputPlaceInfo:placeList inManagedContext:theContext];
    
    NSArray *imageList = [theDictionary objectForKey:kImageListKey];
    [CoreDataManager inputImageList:imageList inManagedContext:theContext];
    
    NSArray *categoryList = [theDictionary objectForKey:kFavorCategoryListKey];
    [CoreDataManager inputCategoryList:categoryList inManagedContext:theContext];
}

#pragma -
#pragma - base method
+(NSInteger)entityCountWithName:(NSString *)entityName inManagedContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if(error)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return -1;
    }
    
    return [fetchedObjects count];
}
+(NSArray *)entitiesWithName:(NSString *)entityName inManagedContext:(NSManagedObjectContext *)context{
    return [CoreDataManager entitiesWithName:entityName sortKey:nil inManagedContext:context];
}
+(NSArray *)entitiesWithName:(NSString *)entityName sortKey:(NSString *)sortKey inManagedContext:(NSManagedObjectContext *)context
{
    return [CoreDataManager entitiesWithName:entityName sortKey:sortKey predicate:nil inManagedContext:context];
}
+(NSArray *)entitiesWithName:(NSString *)entityName sortKey:(NSString *)sortKey predicate:(NSPredicate *)predicate inManagedContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = nil;
    if(sortKey){
        sortDescriptor = [[NSSortDescriptor alloc]
                          initWithKey:@"score"
                          ascending:NO];
        NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:descriptors];
    }
    if(predicate){
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if(error)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    
    return fetchedObjects;
}

#pragma -
#pragma - member reference method
+(Member *)memberSavedEmail{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = ap.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"savedEmail == %@", [NSNumber numberWithBool:YES]];
    
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"Member" sortKey:nil predicate:predicate inManagedContext:moc];
    if (array == nil || [array count] == 0)
    {
        NSLog(@"%@",error);
        return nil;
    }
    
    return [array lastObject];
}
+(void)setMemberSavedEmailWith:(NSString *)theEmail{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"email == %@", theEmail];
    
    NSArray *array = [CoreDataManager entitiesWithName:@"Member" sortKey:nil predicate:predicate inManagedContext:ap.managedObjectContext];

    Member * member;
    
    if (array == nil || [array count] == 0)
    {
        member = [CoreDataManager insertMemberEmail:theEmail savedEmail:YES];
        member.savedEmail = [NSNumber numberWithBool:YES];
        
    }else{
        member = [array lastObject];
        member.savedEmail = [NSNumber numberWithBool:YES];
    }
    
    [ap saveContext];
}
+(Member *)insertMemberEmail:(NSString *)theEmail savedEmail:(BOOL)savedEmail{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = ap.managedObjectContext;
    
    Member *newMemer = (Member *)[NSEntityDescription
                                  insertNewObjectForEntityForName:@"Member"
                                  inManagedObjectContext:context];
    newMemer.email = theEmail;
    
    [ap saveContext];
    
    return newMemer;
}
+(Member *)insertMemberEmail:(NSString *)theEmail{
    return [CoreDataManager insertMemberEmail:theEmail savedEmail:NO];
}

+(Member *)currentLoginUser{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSArray * array = [CoreDataManager entitiesWithName:@"Member" sortKey:@"loginTime" inManagedContext:ap.managedObjectContext];
    
    return [array lastObject];
}

+(void)loginUser:(NSString *)theEmail{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = ap.managedObjectContext;
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@",theEmail];
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"Member" sortKey:nil predicate:predicate inManagedContext:moc];
    if (array == nil)
    {
        // Deal with error...
        NSLog(@"%@",error);
    }else{
        Member *member = [array lastObject];
        member.loginTime = [NSDate date];
        [ap saveContext];
    }
    

    
}

#pragma -
#pragma - category reference method
+(FavorCategory *)categoryWith:(NSString *)theWord{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = ap.managedObjectContext;
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word == %@",theWord];
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"FavorCategory" sortKey:nil predicate:predicate inManagedContext:moc];
    
    if (array == nil)
    {
        // Deal with error...
        NSLog(@"%@",error);
        return nil;
    }
    
    return [array lastObject];
}
+(void)inputCategoryList:(NSArray *)theCategoryList inManagedContext:(NSManagedObjectContext *)context{
    if ([theCategoryList count] == 0)
        abort();
    for (NSDictionary *categoryInfo in theCategoryList){
        FavorCategory *category = (FavorCategory *)[NSEntityDescription
                                           insertNewObjectForEntityForName:@"FavorCategory"
                                           inManagedObjectContext:context];
        category.word = [categoryInfo objectForKey:@"word"];
        category.characterID =[NSNumber numberWithInt:[[categoryInfo objectForKey:@"id"] intValue]];
        category.category = [categoryInfo objectForKey:@"category"];
        category.tag = [categoryInfo objectForKey:@"tag"];
    }
}
+(NSInteger)categoryIDForWord:(NSString *)word inManagedContext:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"word == %@", word];
    
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
    //                                        initWithKey:@"firstName" ascending:YES];
    //    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"FavorCategory" sortKey:nil predicate:predicate inManagedContext:context];
    if (array == nil)
    {
        NSLog(@"%@",error);
        return -1;
    }
    FavorCategory *searchedEntity = (FavorCategory *)[array objectAtIndex:0];
    
    return [searchedEntity.characterID integerValue];
}
+(NSString *)categoryTagForWord:(NSString *)word inManagedContext:(NSManagedObjectContext *)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"word == %@", word];
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"FavorCategory" sortKey:nil predicate:predicate inManagedContext:context];
    
    if (array == nil)
    {
        NSLog(@"%@",error);
        return nil;
    }
    FavorCategory *searchedEntity = (FavorCategory *)[array objectAtIndex:0];
    
    return searchedEntity.tag;
}
// 사용자가 선택한 카테고리를 저장해 놓는다.
+(void)saveUserCategories:(NSArray *)categories WithPlaceName:(NSString *)thePlaceName{
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = ap.managedObjectContext;
    
    UserChoiceCategory *category = (UserChoiceCategory *)[NSEntityDescription
                                                          insertNewObjectForEntityForName:@"UserChoiceCategory"
                                                          inManagedObjectContext:context];
    
    category.date = [NSDate date];
    category.selectedCategories = categories;
    
    Member *currentUser = [CoreDataManager currentLoginUser];
    category.userEmail = currentUser.email;
    category.placeName = thePlaceName;
    [ap saveContext];
}
#pragma -
#pragma - Place Image reference method

+(void)inputImageList:(NSArray *)imageList inManagedContext:(NSManagedObjectContext *)context{
    if ([imageList count] == 0)
        abort();
    for (NSDictionary *imageInfo in imageList)
    {
        PlaceImage *image = (PlaceImage *)[NSEntityDescription
                                           insertNewObjectForEntityForName:@"PlaceImage"
                                           inManagedObjectContext:context];
        
        image.placeName = [imageInfo objectForKey:@"place_name"];
        image.linkUrl = [imageInfo objectForKey:@"link"];
        
    }
}

+(NSString *)typicalImageWithPlaceName:(NSString *)placeName inManagedContext:(NSManagedObjectContext *)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeName CONTAINS[c] %@",placeName];
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"PlaceImage" sortKey:nil predicate:predicate inManagedContext:context];
    if (array == nil || 0 == [array count])
    {
        NSLog(@"%@",error);
        return nil;
    }
    
    PlaceImage *image = [array objectAtIndex:0];
    
    return image.linkUrl;
}
+(NSArray *)placeImageEntitiesWithPlaceName:(NSString *)placeName{
    
    AppDelegate *ap = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = ap.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeName CONTAINS[c] %@",placeName];
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"PlaceImage" sortKey:nil predicate:predicate inManagedContext:moc];
    if (array == nil)
    {
        // Deal with error...
        NSLog(@"%@",error);
    }
    
    return array;
}
#pragma -
#pragma - place reference method
+(void)inputPlaceInfo:(NSArray *)placeList inManagedContext:(NSManagedObjectContext *)context
{
    if ([placeList count] == 0)
        abort();
//    NSLog(@"LIST 갯수 : %ud",[placeList count]);
    
    double totalSympathyCount = 0.0f;
    double totalTodayCount = 0.0f;
    for (NSDictionary *placeDic in placeList)
    {
        PlaceInfo *place = (PlaceInfo *)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"PlaceInfo"
                                         inManagedObjectContext:context];
        place.name = [placeDic objectForKey:@"name"];
        place.category = [placeDic objectForKey:@"category"];
        place.address = [placeDic objectForKey:@"address"];
        place.telephone = [placeDic objectForKey:@"telephone"];
        place.pointX = [NSNumber numberWithFloat:[[placeDic objectForKey:@"pointx"] floatValue]];
        place.pointY = [NSNumber numberWithFloat:[[placeDic objectForKey:@"pointy"] floatValue]];
        
        place.desc = [placeDic objectForKey:@"description"];
        place.url = [placeDic objectForKey:@"url"];
        place.local = [placeDic objectForKey:@"local"];
        place.imageUrl = [placeDic objectForKey:@"image_url"];
        
        totalSympathyCount = [[placeDic objectForKey:@"total_sympathy_score"] doubleValue];
        totalTodayCount = [[placeDic objectForKey:@"total_today_count"] doubleValue];
        
        place.score = [NSNumber numberWithDouble:(totalTodayCount * 0.3) + (totalSympathyCount * 0.7)];
    }
}

+(NSManagedObject *)placeInfoEntityWith:(NSString *)placeName inManagedContext:(NSManagedObjectContext *)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"name == %@", placeName];
    
    
    NSError *error;
    NSArray *array = [CoreDataManager entitiesWithName:@"PlaceInfo" sortKey:nil predicate:predicate inManagedContext:context];
    if (array == nil)
    {
        NSLog(@"%@",error);
        return nil;
    }
    
    return [array objectAtIndex:0];
}

@end
