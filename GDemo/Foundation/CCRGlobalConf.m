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

- (NSString *) loginName {
    return (NSString *) [[NSUserDefaults standardUserDefaults] stringForKey:gLOGIN_NAME];
}
- (NSString *) password {
    return (NSString *) [[NSUserDefaults standardUserDefaults] stringForKey:gPASSWORD];
}
- (NSString *) nickName {
    return (NSString *) [[NSUserDefaults standardUserDefaults] stringForKey:gNICK_NAME];
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

-(void)dealloc{
    [_myLocation release];
    [super dealloc];
}	


@end
