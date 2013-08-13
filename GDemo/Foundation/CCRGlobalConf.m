//
//  CCRGlobalConf.m
//  GDemo
//
//  Created by Wingle Wong on 8/13/13.
//  Copyright (c) 2013 Wingle. All rights reserved.
//

#import "CCRGlobalConf.h"

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
    return (NSInteger) [[NSUserDefaults standardUserDefaults] objectForKey:gUSER_ID];
}

- (NSString *) loginName {
    return (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:gLOGIN_NAME];
}
- (NSString *) password {
    return (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:gPASSWORD];
}
- (NSString *) nickName {
    return (NSString *) [[NSUserDefaults standardUserDefaults] objectForKey:gNICK_NAME];
}

-(void)dealloc{
    [_myLocation release];
    [super dealloc];
}	


@end
