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
#define gUSER_GENDER    @"userGender"
#define gUSER_AREA      @"userArea"
#define gUSER_GAMESERVER    @"gameServer"
#define gUSER_CONTACT       @"userContact"
#define gUSER_SIGN          @"userSign"
#define gUSER_CODE          @"userCode"
#define gGAMESERVERS   @"gameServers"
#define gPERSON         @"gPersonalInfo"  

@interface CCRGlobalConf : NSObject <CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic,retain) CLLocation *myLocation;
@property (nonatomic, retain, readonly) NSString *strGender;

+(CCRGlobalConf *)share;

- (BOOL) startLocationManagerService;
- (BOOL) stopLocationManagerService;

- (NSInteger) userId;
- (NSString *) loginName;
- (NSString *) password;
- (NSString *) nickName;
- (UIImage *) image;
- (NSString *) strGender;
- (BOOL) isLogin;
- (NSString *) userArea;
- (NSString *) userGameServer;
- (NSString *) userContact;
- (NSString *) userSign;
- (NSString *) userCode;
- (NSInteger) gender;
- (NSInteger) area;
- (NSInteger) game;

- (NSString *) gameServerwithIndex:(NSInteger) index;

@end
