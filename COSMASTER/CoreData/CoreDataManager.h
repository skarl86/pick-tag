//
//  CoreDataManager.h
//  COSMASTER
//
//  Created by NCri on 2014. 8. 27..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Member, FavorCategory;

@interface CoreDataManager : NSObject
// 사전 데이터 관련 메소드.
+(void)prepareBaseData:(NSDictionary *)theDictionary inManagedContext:(NSManagedObjectContext *)theContext;

// 모든 메소드의 기본이 되는 메소드
+(NSInteger)entityCountWithName:(NSString *)entityName inManagedContext:(NSManagedObjectContext *)context;

+(NSArray *)entitiesWithName:(NSString *)entityName sortKey:(NSString *)sortKey inManagedContext:(NSManagedObjectContext *)context;
+(NSArray *)entitiesWithName:(NSString *)entityName inManagedContext:(NSManagedObjectContext *)context;
+(NSArray *)entitiesWithName:(NSString *)entityName sortKey:(NSString *)sortKey predicate:(NSPredicate *)predicate inManagedContext:(NSManagedObjectContext *)context;

// 맴버 관련 메소드.
+(void)setMemberSavedEmailWith:(NSString *)theEmail;
+(Member *)insertMemberEmail:(NSString *)theEmail;
+(Member *)insertMemberEmail:(NSString *)theEmail savedEmail:(BOOL)savedEmail;
+(void)inputPlaceInfo:(NSArray *)placeList inManagedContext:(NSManagedObjectContext *)context;
+(Member *)memberSavedEmail;
+(Member *)currentLoginUser;
+(void)loginUser:(NSString *)theEmail;

// 태그 관련 메소드.
+(NSString *)categoryTagForWord:(NSString *)word inManagedContext:(NSManagedObjectContext *)context;
+(NSInteger)categoryIDForWord:(NSString *)word inManagedContext:(NSManagedObjectContext *)context;
+(FavorCategory *)categoryWith:(NSString *)theWord;
+(void)saveUserCategories:(NSArray *)categories WithPlaceName:(NSString *)thePlaceName;

// 장소 관련 메소드.
+(NSString *)typicalImageWithPlaceName:(NSString *)placeName inManagedContext:(NSManagedObjectContext *)context;
+(NSArray *)placeImageEntitiesWithPlaceName:(NSString *)placeName;

+(NSString *)placeInfoEntityWith:(NSString *)placeName inManagedContext:(NSManagedObjectContext *)context;

@end
