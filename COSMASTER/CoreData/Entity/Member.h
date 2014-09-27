//
//  Member.h
//  COSMASTER
//
//  Created by NCri on 2014. 9. 15..
//  Copyright (c) 2014년 TFD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


// 어플리케이션 이용하는 사용자 정보를
// 저장하는 Core Data Entity 구조.
@interface Member : NSManagedObject

@property (nonatomic, retain) NSString * email;     // 로그인 Email
@property (nonatomic, retain) NSString * password;  // 비밀번호 암호화 하여 저장.
//@property (nonatomic, retain) NSNumber * autoLogin; // 자동 로그인 여부.
@property (nonatomic, retain) NSDate * loginTime;
@property (nonatomic, retain) NSNumber * savedEmail; // 이메일 저장 여부.

@end
