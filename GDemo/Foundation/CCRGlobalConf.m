//
//  CCRGlobalConf.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "CCRGlobalConf.h"
#import "GDUtility.h"

@interface CCRGlobalConf ()

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

-(void)dealloc{
    [_myLocation release];
    [super dealloc];
}	


@end
