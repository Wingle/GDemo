//
//  CCRGlobalConf.h
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define CCRConf [CCRGlobalConf share]

#define gUSER_ID        @"userID"
#define gLOGIN_NAME     @"loginName"
#define gNICK_NAME      @"nickName"
#define gPASSWORD       @"passWord"
#define gHAVE_LOGIN     @"logIn"
#define gUSER_GENDER    @"gender"

@interface CCRGlobalConf : NSObject
@property(nonatomic,retain) CLLocation *myLocation;
@property (nonatomic, retain, readonly) NSString *strGender;

+(CCRGlobalConf *)share;

- (NSInteger) userId;
- (NSString *) loginName;
- (NSString *) password;
- (NSString *) nickName;
- (UIImage *) image;
- (NSString *) strGender;
- (BOOL) isLogin;

@end
