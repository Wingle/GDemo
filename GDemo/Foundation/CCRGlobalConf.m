//
//  CCRGlobalConf.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "CCRGlobalConf.h"
#import "GDUtility.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface CCRGlobalConf ()
- (void)updateMyLocation:(CLLocation *) location;

@end

@implementation CCRGlobalConf



+(CCRGlobalConf *)share{
    static CCRGlobalConf *obj = nil;
    if (obj == nil) {
        obj = [[CCRGlobalConf alloc] init];
    }
    return obj;
}

-(BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:gHAVE_LOGIN];
}

- (NSInteger) userId {
    return (NSInteger) [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_ID];
}

- (NSInteger) gender {
    return [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_GENDER];
}

- (NSInteger) area {
    return [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_AREA];
}

- (NSString *) loginName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:gLOGIN_NAME];
}
- (NSString *) password {
    return [[NSUserDefaults standardUserDefaults] stringForKey:gPASSWORD];
}
- (NSString *) nickName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:gNICK_NAME];
}

- (UIImage *) image {
    return [GDUtility loadImageForKey:[NSString stringWithFormat:@"%d",CCRConf.userId]];
}

- (NSString *) strGender {
    NSInteger gender = [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_GENDER];
    if (gender == 0) {
        return @"男";
    }else {
        return @"女";
    }
}

- (NSString *) userContact {
    return [[NSUserDefaults standardUserDefaults] stringForKey:gUSER_CONTACT];
}

- (NSString *) userArea {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"citys.plist"]];
    NSInteger area = [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_AREA];
    NSArray *areaArray = [dic objectForKey:@"city"];
    return [areaArray objectAtIndex:area];
}

- (NSString *) userSign {
    return [[NSUserDefaults standardUserDefaults] stringForKey:gUSER_SIGN];
}

- (NSString *) userCode {
    return [[NSUserDefaults standardUserDefaults] stringForKey:gUSER_CODE];
}

- (NSString *) userGameServer {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"gameServer.plist"]];
    NSInteger game = [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_GAMESERVER];
    NSArray *gameArray = [dic objectForKey:@"server"];
    return [gameArray objectAtIndex:game];
}

- (NSInteger) game {
    return [[NSUserDefaults standardUserDefaults] integerForKey:gUSER_GAMESERVER];
}

- (NSString *) gameServerwithIndex:(NSInteger) index {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"gameServer.plist"]];
    NSArray *gameArray = [dic objectForKey:@"server"];
    return [gameArray objectAtIndex:index];
}

- (CLLocationManager *) locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

-(void)dealloc{
    [_myLocation release];
    _locationManager.delegate = nil;
    [_locationManager release];
    [super dealloc];
}

#pragma mark - Methods 
- (void)updateMyLocation:(CLLocation *) location {
    self.myLocation = location;
    [self stopLocationManagerService];
    
    NSString *strURL = [NSString stringWithFormat:@"%@/myLocation.do?userId=%d&lat=%.6f&lng=%.6f",
                         CR_REQUEST_URL,
                         CCRConf.userId,
                         self.myLocation.coordinate.latitude,
                         self.myLocation.coordinate.longitude];
    LOG(@"strurl = %@",strURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request setDelegate:self];
    [request setTimeOutSeconds:5];
    [request startAsynchronous];
    
}

- (BOOL) startLocationManagerService {
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    return YES;
}

- (BOOL) stopLocationManagerService {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    return YES;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocationAccuracy horAccuracy = newLocation.horizontalAccuracy;
    if (horAccuracy > 1000.0) {
        return;
    }
    NSTimeInterval age = [newLocation.timestamp timeIntervalSinceNow];
	if (age < -20.0f) {
		return;
	}
    [self performSelectorOnMainThread:@selector(updateMyLocation:) withObject:newLocation waitUntilDone:YES];
    
}


#pragma mark - ASIHttp---
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *string = [request responseString];
    LOG(@"string = %@",string);
//    NSMutableDictionary * dataDict = [string JSONValue];
//    NSInteger status = [[dataDict objectForKey:@"status"] integerValue];
//    if (status != 0) {
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"亲，出错了"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];
//        [alter show];
//        [alter release];
//        alter = nil;
//        return;
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                    message:@"亲，网络不通哦"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil, nil];
//    [alter show];
//    [alter release];
//    alter = nil;
//    return;
    
}



@end
